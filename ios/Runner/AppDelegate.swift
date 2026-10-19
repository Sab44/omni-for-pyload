import Flutter
import Network
import UIKit
import dnssd

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LocalNetworkAccess") {
      LocalNetworkAccessCheck.registerMethodChannel(with: registrar)
    }
  }
}

/// Finds if the app can connect to a server in the local network.
///
/// iOS has no API that gives the status of the local network permission.
/// Instead, this class opens a TCP connection to the server and monitors it.
/// If iOS blocks the connection, the connection waits with the reason
/// `localNetworkDenied`. iOS gives this reason only for a connection to an IP
/// address, so the class first resolves a host name to an IP address.
///
/// The first connection to the local network causes iOS to show a permission
/// prompt. iOS gives the reason `localNetworkDenied` immediately, before the
/// user answers. So the check waits for the answer before it sends a result:
///
/// - "Allow": the waiting connection opens by itself, and the check sends
///   `granted`.
/// - "Don't Allow": the connection stays blocked, and the check sends `denied`.
///
/// The Dart side receives one of the values in `AccessResult`.
class LocalNetworkAccessCheck {
  /// The values that the method channel sends to the Dart side.
  private enum AccessResult: String {
    /// The connection to the server is open. iOS gives local network access.
    case granted
    /// iOS blocks local network access for the app.
    case denied
    /// The result is not known. For example, the server is off or the address
    /// is incorrect. The usual connection test on the Dart side then shows the
    /// applicable error.
    case unknown
  }

  private static let channelName = "com.downloader.omni_for_pyload/local_network"

  /// The time to wait for the permission prompt to show.
  ///
  /// iOS shows the prompt approximately 0.2 seconds after the connection
  /// starts. When this time ends, the check looks at the app state to find
  /// out if there is a prompt.
  private static let waitForPromptToShow: TimeInterval = 0.5

  /// The maximum time to wait for a connection result.
  ///
  /// The connection can stay without a result, for example during a slow
  /// name resolution. When this time ends, the check sends `denied` or
  /// `unknown`. This limit does not apply while the user answers the prompt,
  /// because the user can take a long time to answer.
  private static let maximumWaitForConnectionResult: TimeInterval = 3

  /// The time to wait for the connection to open after the user answers the prompt.
  ///
  /// If the user selects "Allow", the waiting connection usually opens before
  /// the app is active again. This time is a safety margin. If the connection
  /// does not open in this time, the check sends `denied` or `unknown`.
  private static let waitForConnectionAfterPromptAnswer: TimeInterval = 1

  /// Connects the method channel `checkAccess` to this class.
  ///
  /// The Dart side must send the arguments `host` (String) and `port` (Int).
  static func registerMethodChannel(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "checkAccess" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let arguments = call.arguments as? [String: Any],
        let host = arguments["host"] as? String,
        let port = arguments["port"] as? Int,
        let networkPort = NWEndpoint.Port(rawValue: UInt16(clamping: port))
      else {
        result(FlutterError(code: "invalid_arguments", message: "host and port are required", details: nil))
        return
      }

      let check = LocalNetworkAccessCheck(host: host, port: networkPort)
      check.startCheck { accessResult in
        result(accessResult.rawValue)
      }
    }
  }

  /// The host name or IP address of the server.
  private let host: String
  private let port: NWEndpoint.Port

  /// The test connection to the server. The check sends no data on it.
  ///
  /// The value is `nil` until the name resolution of the host is complete.
  private var connection: NWConnection?

  /// Sends the result to the Dart side.
  ///
  /// The value is `nil` after the check sent its result. This makes sure that
  /// the check sends one result only, as Flutter requires.
  private var sendResultToFlutter: ((AccessResult) -> Void)?

  /// Is `true` after the connection failed or started to wait one time or more.
  private var didConnectionFail = false

  /// Is `true` if iOS blocked the most recent connection attempt because of
  /// the local network permission.
  private var isBlockedByLocalNetworkPermission = false

  /// Is `true` after the time for the prompt to show ended.
  private var didWaitForPromptEnd = false

  /// Is `true` after the app became inactive one time or more during the check.
  ///
  /// The app becomes inactive when the permission prompt shows. If the app is
  /// active again when the check looks for the prompt, the user answered the
  /// prompt already.
  private var didAppBecomeInactive = false

  /// Is `true` after the check started to wait for the answer of the user.
  private var isWaitingForPromptAnswer = false

  /// Receive the notifications when the app state changes.
  private var appStateObservers: [NSObjectProtocol] = []

  private init(host: String, port: NWEndpoint.Port) {
    self.host = host
    self.port = port
  }

  /// Starts the timers, resolves the host and then opens the test connection.
  ///
  /// No other object keeps a reference to the check. Instead, the closures
  /// below keep a strong reference to `self`, which keeps the check in memory
  /// until `sendResultOnce` stops the connection and all timers have ended.
  ///
  /// All code runs on the main queue, so the check needs no locks.
  private func startCheck(sendResult: @escaping (AccessResult) -> Void) {
    sendResultToFlutter = sendResult

    // Start to monitor the app state before the connection can cause the prompt.
    observeAppState(UIApplication.willResignActiveNotification) { [self] in
      didAppBecomeInactive = true
    }

    // Start the timers before the name resolution, because a slow name
    // resolution must not extend the maximum wait.
    DispatchQueue.main.asyncAfter(deadline: .now() + Self.waitForPromptToShow) { [self] in
      didWaitForPromptEnd = true
      sendResultOrWaitForPromptAnswer(isMaximumWaitEnded: false)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + Self.maximumWaitForConnectionResult) { [self] in
      sendResultOrWaitForPromptAnswer(isMaximumWaitEnded: true)
    }

    Self.resolveToIPAddress(host) { [self] resolvedHost in
      openConnection(to: resolvedHost)
    }
  }

  /// Resolves a host name to an IP address on a background queue, and calls
  /// `completion` on the main queue.
  ///
  /// For a connection to a host name, iOS does not give the reason
  /// `localNetworkDenied`. The connection only waits with the error "Network
  /// is down". So the check connects to the IP address.
  ///
  /// The name resolution for a usual DNS name does not need local network
  /// access. If the resolution fails, for example for a local name such as
  /// `nas.local` without local network access, `completion` receives the
  /// host name, and the connection resolves the name itself.
  private static func resolveToIPAddress(_ host: String, completion: @escaping (NWEndpoint.Host) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      let resolvedHost = firstIPAddress(of: host).map { NWEndpoint.Host($0) } ?? NWEndpoint.Host(host)
      DispatchQueue.main.async {
        completion(resolvedHost)
      }
    }
  }

  /// Returns the first IP address of `host`, an IPv4 address if there is one.
  /// For an IP address, returns the same address. This call blocks until the
  /// name resolution is complete.
  private static func firstIPAddress(of host: String) -> String? {
    var hints = addrinfo()
    hints.ai_family = AF_UNSPEC
    hints.ai_socktype = SOCK_STREAM
    var firstInfo: UnsafeMutablePointer<addrinfo>?
    guard getaddrinfo(host, nil, &hints, &firstInfo) == 0, let firstInfo else {
      return nil
    }
    defer { freeaddrinfo(firstInfo) }

    var addresses: [(family: Int32, address: String)] = []
    for info in sequence(first: firstInfo, next: { $0.pointee.ai_next }) {
      var buffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
      let status = getnameinfo(
        info.pointee.ai_addr, info.pointee.ai_addrlen, &buffer, socklen_t(buffer.count), nil, 0, NI_NUMERICHOST)
      if status == 0 {
        addresses.append((info.pointee.ai_family, String(cString: buffer)))
      }
    }
    return (addresses.first { $0.family == AF_INET } ?? addresses.first)?.address
  }

  /// Opens the test connection, if the check did not send its result yet.
  private func openConnection(to resolvedHost: NWEndpoint.Host) {
    if sendResultToFlutter == nil {
      return
    }

    let connection = NWConnection(host: resolvedHost, port: port, using: .tcp)
    connection.stateUpdateHandler = { [self] state in
      handleConnectionStateChange(state)
    }
    self.connection = connection
    connection.start(queue: .main)
  }

  /// Examines each new state of the test connection.
  private func handleConnectionStateChange(_ state: NWConnection.State) {
    switch state {
    case .ready:
      // The connection is open, so iOS gives local network access.
      sendResultOnce(.granted)

    case .waiting(let error), .failed(let error):
      didConnectionFail = true
      isBlockedByLocalNetworkPermission = isLocalNetworkPermissionError(error)
      // Before the time for the prompt ends, it is not known if there is a
      // prompt. The timer then examines the failure.
      if didWaitForPromptEnd {
        sendResultOrWaitForPromptAnswer(isMaximumWaitEnded: false)
      }

    default:
      // The connection is not ready yet. Wait for the subsequent state.
      break
    }
  }

  /// Finds if iOS blocked the connection because of the local network permission.
  private func isLocalNetworkPermissionError(_ error: NWError) -> Bool {
    if connection?.currentPath?.unsatisfiedReason == .localNetworkDenied {
      return true
    }
    // iOS also blocks the name resolution of local host names, for example
    // `nas.local`.
    if case .dns(let code) = error, code == DNSServiceErrorType(kDNSServiceErr_PolicyDenied) {
      return true
    }
    return false
  }

  /// Waits for the answer of the user if there is a prompt. Otherwise, sends
  /// the result of the connection, if one is available.
  ///
  /// If no result is available yet, the check waits for a new connection
  /// state, or for the end of the maximum wait.
  private func sendResultOrWaitForPromptAnswer(isMaximumWaitEnded: Bool) {
    // The check sent a result already, or waits for the answer already.
    if sendResultToFlutter == nil || isWaitingForPromptAnswer {
      return
    }

    if UIApplication.shared.applicationState != .active {
      // While a system prompt is on the screen, the app is not active. The app
      // becomes active again when the user answers the prompt.
      isWaitingForPromptAnswer = true
      observeAppState(UIApplication.didBecomeActiveNotification) { [self] in
        waitForConnectionAfterPromptAnswer()
      }
    } else if didAppBecomeInactive {
      // The user answered the prompt already.
      isWaitingForPromptAnswer = true
      waitForConnectionAfterPromptAnswer()
    } else if didConnectionFail || isMaximumWaitEnded {
      // There was no prompt.
      sendResultOfConnectionState()
    }
  }

  /// Gives the connection time to open after the user answered the prompt.
  ///
  /// If the user selected "Allow", the connection opens and
  /// `handleConnectionStateChange` sends `granted`. Otherwise, the check sends
  /// the result of the connection state.
  private func waitForConnectionAfterPromptAnswer() {
    DispatchQueue.main.asyncAfter(deadline: .now() + Self.waitForConnectionAfterPromptAnswer) { [self] in
      sendResultOfConnectionState()
    }
  }

  /// Sends `denied` if iOS blocks the connection because of the local network
  /// permission, and `unknown` for all other failures.
  private func sendResultOfConnectionState() {
    sendResultOnce(isBlockedByLocalNetworkPermission ? .denied : .unknown)
  }

  /// Calls `handler` on the main queue each time the app sends `notification`.
  private func observeAppState(_ notification: Notification.Name, handler: @escaping () -> Void) {
    let observer = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { _ in
      handler()
    }
    appStateObservers.append(observer)
  }

  /// Sends the result to the Dart side and stops the check.
  ///
  /// Different parts of the check can call this function. Only the first call
  /// sends a result. All subsequent calls do nothing.
  private func sendResultOnce(_ result: AccessResult) {
    guard let sendResult = sendResultToFlutter else {
      return
    }
    sendResultToFlutter = nil

    appStateObservers.forEach(NotificationCenter.default.removeObserver)
    appStateObservers = []

    // Remove the state handler before the connection stops. This removes the
    // strong reference from the connection to the check.
    connection?.stateUpdateHandler = nil
    connection?.cancel()

    sendResult(result)
  }
}
