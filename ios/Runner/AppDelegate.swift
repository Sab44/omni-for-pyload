import Flutter
import Network
import UIKit

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
/// Instead, this class opens a TCP connection to the server and monitors the
/// result. If iOS blocks the connection, the reason is `localNetworkDenied`.
///
/// The first connection to the local network causes iOS to show a permission
/// prompt. iOS also gives the reason `localNetworkDenied` while the prompt is
/// on the screen, so this class waits for the answer of the user before it
/// sends the result.
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

  /// The maximum time to wait for a connection result.
  ///
  /// If this time ends before a result is available, the check sends
  /// `denied` or `unknown`. This limit does not apply when the permission
  /// prompt is on the screen, because the user can take a long time to answer.
  private static let maximumWaitForConnectionResult: TimeInterval = 3

  /// The time to wait for the permission prompt to show.
  ///
  /// iOS shows the prompt a short time after the connection starts. When
  /// this time ends, the check looks at the app state. If the app is not
  /// active, the prompt is displayed on the screen.
  private static let waitForPromptToShow: TimeInterval = 1

  /// The time to wait for the second connection after the user answers the prompt.
  ///
  /// If the user selects "Allow", the second connection usually opens in this
  /// time and the check sends `granted`. If the connection does not open in
  /// this time, the check sends `denied`.
  private static let waitForRetryAfterPromptAnswer: TimeInterval = 1

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

  /// The test connection to the server. The check sends no data on it.
  private let connection: NWConnection

  /// Sends the result to the Dart side.
  ///
  /// The value is `nil` after the check sent its result. This makes sure that
  /// the check sends one result only, as Flutter requires.
  private var sendResultToFlutter: ((AccessResult) -> Void)?

  /// Is `true` after iOS blocked the connection with `localNetworkDenied` one time or more.
  private var didReceiveLocalNetworkDenied = false

  /// Is `true` when the permission prompt is on the screen and the check waits
  /// for the answer of the user.
  private var isWaitingForPromptAnswer = false

  /// Receives the notification when the app becomes active again.
  private var appBecameActiveObserver: NSObjectProtocol?

  private init(host: String, port: NWEndpoint.Port) {
    connection = NWConnection(host: NWEndpoint.Host(host), port: port, using: .tcp)
  }

  /// Opens the test connection and starts the timer for the maximum wait.
  ///
  /// No other object keeps a reference to the check. Instead, the closures
  /// below keep a strong reference to `self`, which keeps the check in memory
  /// until `sendResultOnce` stops the connection and all timers have ended.
  ///
  /// All code runs on the main queue, so the check needs no locks.
  private func startCheck(sendResult: @escaping (AccessResult) -> Void) {
    sendResultToFlutter = sendResult

    connection.stateUpdateHandler = { [self] state in
      handleConnectionStateChange(state)
    }
    connection.start(queue: .main)

    DispatchQueue.main.asyncAfter(deadline: .now() + Self.maximumWaitForConnectionResult) { [self] in
      handleMaximumWaitEnded()
    }
  }

  /// Examines each new state of the test connection.
  private func handleConnectionStateChange(_ state: NWConnection.State) {
    switch state {
    case .ready:
      // The connection is open, so iOS gives local network access.
      sendResultOnce(.granted)

    case .waiting, .failed:
      if connection.currentPath?.unsatisfiedReason == .localNetworkDenied {
        handleLocalNetworkDenied()
      } else if !didReceiveLocalNetworkDenied {
        // The connection failed for a different reason. The usual connection
        // test on the Dart side shows the applicable error.
        sendResultOnce(.unknown)
      }

    default:
      // The connection is not ready yet. Wait for the subsequent state.
      break
    }
  }

  /// Sends a result if no connection result is available in the maximum time.
  private func handleMaximumWaitEnded() {
    // The user can take a long time to answer the prompt. Do not stop the check.
    if isWaitingForPromptAnswer {
      return
    }

    if didReceiveLocalNetworkDenied {
      sendResultOnce(.denied)
    } else {
      sendResultOnce(.unknown)
    }
  }

  /// Starts the steps for a connection that iOS blocked with `localNetworkDenied`.
  ///
  /// iOS also blocks the connection while the permission prompt is on the
  /// screen, so do not send `denied` immediately. First wait for the prompt
  /// to show, then find out if it is on the screen.
  private func handleLocalNetworkDenied() {
    // iOS can send this state more than one time. Do these steps one time only.
    if didReceiveLocalNetworkDenied {
      return
    }
    didReceiveLocalNetworkDenied = true

    DispatchQueue.main.asyncAfter(deadline: .now() + Self.waitForPromptToShow) { [self] in
      sendDeniedOrWaitForPromptAnswer()
    }
  }

  /// Sends `denied`, or waits for the answer of the user if the prompt is on the screen.
  private func sendDeniedOrWaitForPromptAnswer() {
    // The check sent a result already. For example, the connection opened.
    if sendResultToFlutter == nil {
      return
    }

    // While a system prompt is on the screen, the app is not active. An active
    // app means that there is no prompt and local network access is off.
    if UIApplication.shared.applicationState == .active {
      sendResultOnce(.denied)
      return
    }

    // The prompt is on the screen. The app becomes active again when the user
    // answers the prompt.
    isWaitingForPromptAnswer = true
    appBecameActiveObserver = NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { [self] _ in
      retryConnectionAfterPromptAnswer()
    }
  }

  /// Opens the test connection again after the user answers the prompt.
  ///
  /// If the user selected "Allow", the connection opens and
  /// `handleConnectionStateChange` sends `granted`. If the connection does not
  /// open in the wait time, send `denied`.
  private func retryConnectionAfterPromptAnswer() {
    connection.restart()

    DispatchQueue.main.asyncAfter(deadline: .now() + Self.waitForRetryAfterPromptAnswer) { [self] in
      sendResultOnce(.denied)
    }
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

    if let appBecameActiveObserver {
      NotificationCenter.default.removeObserver(appBecameActiveObserver)
    }
    appBecameActiveObserver = nil

    // Remove the state handler before the connection stops. This removes the
    // strong reference from the connection to the check.
    connection.stateUpdateHandler = nil
    connection.cancel()

    sendResult(result)
  }
}
