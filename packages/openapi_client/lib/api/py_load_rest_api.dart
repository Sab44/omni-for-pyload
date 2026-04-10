//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;


class PyLoadRESTApi {
  PyLoadRESTApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Adds files to specific package.
  ///
  /// Adds files to specific package.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiAddFilesPostRequest] apiAddFilesPostRequest:
  Future<Response> apiAddFilesPostWithHttpInfo({ ApiAddFilesPostRequest? apiAddFilesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/add_files';

    // ignore: prefer_final_locals
    Object? postBody = apiAddFilesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Adds files to specific package.
  ///
  /// Adds files to specific package.
  ///
  /// Parameters:
  ///
  /// * [ApiAddFilesPostRequest] apiAddFilesPostRequest:
  Future<void> apiAddFilesPost({ ApiAddFilesPostRequest? apiAddFilesPostRequest, }) async {
    final response = await apiAddFilesPostWithHttpInfo( apiAddFilesPostRequest: apiAddFilesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Adds a package, with links to desired destination.
  ///
  /// Adds a package, with links to desired destination.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiAddPackagePostRequest] apiAddPackagePostRequest:
  Future<Response> apiAddPackagePostWithHttpInfo({ ApiAddPackagePostRequest? apiAddPackagePostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/add_package';

    // ignore: prefer_final_locals
    Object? postBody = apiAddPackagePostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Adds a package, with links to desired destination.
  ///
  /// Adds a package, with links to desired destination.
  ///
  /// Parameters:
  ///
  /// * [ApiAddPackagePostRequest] apiAddPackagePostRequest:
  Future<int?> apiAddPackagePost({ ApiAddPackagePostRequest? apiAddPackagePostRequest, }) async {
    final response = await apiAddPackagePostWithHttpInfo( apiAddPackagePostRequest: apiAddPackagePostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'int',) as int;
    
    }
    return null;
  }

  /// creates new user login.
  ///
  /// creates new user login.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [String] newpw (required):
  ///
  /// * [int] role:
  ///
  /// * [int] perms:
  Future<Response> apiAddUserPostWithHttpInfo(String user, String newpw, { int? role, int? perms, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/add_user';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'user', user));
      queryParams.addAll(_queryParams('', 'newpw', newpw));
    if (role != null) {
      queryParams.addAll(_queryParams('', 'role', role));
    }
    if (perms != null) {
      queryParams.addAll(_queryParams('', 'perms', perms));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// creates new user login.
  ///
  /// creates new user login.
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [String] newpw (required):
  ///
  /// * [int] role:
  ///
  /// * [int] perms:
  Future<bool?> apiAddUserPost(String user, String newpw, { int? role, int? perms, }) async {
    final response = await apiAddUserPostWithHttpInfo(user, newpw,  role: role, perms: perms, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// changes password for specific user.
  ///
  /// changes password for specific user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [String] oldpw (required):
  ///
  /// * [String] newpw (required):
  Future<Response> apiChangePasswordPostWithHttpInfo(String user, String oldpw, String newpw,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/change_password';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'user', user));
      queryParams.addAll(_queryParams('', 'oldpw', oldpw));
      queryParams.addAll(_queryParams('', 'newpw', newpw));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// changes password for specific user.
  ///
  /// changes password for specific user.
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [String] oldpw (required):
  ///
  /// * [String] newpw (required):
  Future<bool?> apiChangePasswordPost(String user, String oldpw, String newpw,) async {
    final response = await apiChangePasswordPostWithHttpInfo(user, oldpw, newpw,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Checks online status, retrieves names, and will add packages. Because of these packages are not added immediately, only for internal use.
  ///
  /// Checks online status, retrieves names, and will add packages. Because of these packages are not added immediately, only for internal use.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiCheckAndAddPackagesPostRequest] apiCheckAndAddPackagesPostRequest:
  Future<Response> apiCheckAndAddPackagesPostWithHttpInfo({ ApiCheckAndAddPackagesPostRequest? apiCheckAndAddPackagesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/check_and_add_packages';

    // ignore: prefer_final_locals
    Object? postBody = apiCheckAndAddPackagesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks online status, retrieves names, and will add packages. Because of these packages are not added immediately, only for internal use.
  ///
  /// Checks online status, retrieves names, and will add packages. Because of these packages are not added immediately, only for internal use.
  ///
  /// Parameters:
  ///
  /// * [ApiCheckAndAddPackagesPostRequest] apiCheckAndAddPackagesPostRequest:
  Future<void> apiCheckAndAddPackagesPost({ ApiCheckAndAddPackagesPostRequest? apiCheckAndAddPackagesPostRequest, }) async {
    final response = await apiCheckAndAddPackagesPostWithHttpInfo( apiCheckAndAddPackagesPostRequest: apiCheckAndAddPackagesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Check authentication and returns details.
  ///
  /// Check authentication and returns details.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<Response> apiCheckAuthGetWithHttpInfo(String username, String password,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/check_auth';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));
      queryParams.addAll(_queryParams('', 'password', password));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Check authentication and returns details.
  ///
  /// Check authentication and returns details.
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<Map<String, Object>?> apiCheckAuthGet(String username, String password,) async {
    final response = await apiCheckAuthGetWithHttpInfo(username, password,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, Object>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, Object>'),);

    }
    return null;
  }

  /// checks online status of urls and a submitted container file.
  ///
  /// checks online status of urls and a submitted container file.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [List<String>] urls (required):
  ///   list of urls
  ///
  /// * [String] container (required):
  ///   container file name
  ///
  /// * [MultipartFile] data (required):
  ///   file content
  Future<Response> apiCheckOnlineStatusContainerPostWithHttpInfo(List<String> urls, String container, MultipartFile data,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/check_online_status_container';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (urls != null) {
      hasFields = true;
      mp.fields[r'urls'] = parameterToString(urls);
    }
    if (container != null) {
      hasFields = true;
      mp.fields[r'container'] = parameterToString(container);
    }
    if (data != null) {
      hasFields = true;
      mp.fields[r'data'] = data.field;
      mp.files.add(data);
    }
    if (hasFields) {
      postBody = mp;
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// checks online status of urls and a submitted container file.
  ///
  /// checks online status of urls and a submitted container file.
  ///
  /// Parameters:
  ///
  /// * [List<String>] urls (required):
  ///   list of urls
  ///
  /// * [String] container (required):
  ///   container file name
  ///
  /// * [MultipartFile] data (required):
  ///   file content
  Future<OnlineCheck?> apiCheckOnlineStatusContainerPost(List<String> urls, String container, MultipartFile data,) async {
    final response = await apiCheckOnlineStatusContainerPostWithHttpInfo(urls, container, data,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OnlineCheck',) as OnlineCheck;
    
    }
    return null;
  }

  /// Initiates online status check.
  ///
  /// Initiates online status check.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiCheckOnlineStatusPostRequest] apiCheckOnlineStatusPostRequest:
  Future<Response> apiCheckOnlineStatusPostWithHttpInfo({ ApiCheckOnlineStatusPostRequest? apiCheckOnlineStatusPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/check_online_status';

    // ignore: prefer_final_locals
    Object? postBody = apiCheckOnlineStatusPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Initiates online status check.
  ///
  /// Initiates online status check.
  ///
  /// Parameters:
  ///
  /// * [ApiCheckOnlineStatusPostRequest] apiCheckOnlineStatusPostRequest:
  Future<OnlineCheck?> apiCheckOnlineStatusPost({ ApiCheckOnlineStatusPostRequest? apiCheckOnlineStatusPostRequest, }) async {
    final response = await apiCheckOnlineStatusPostWithHttpInfo( apiCheckOnlineStatusPostRequest: apiCheckOnlineStatusPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OnlineCheck',) as OnlineCheck;
    
    }
    return null;
  }

  /// Gets urls and returns plugin name mapped to list of matched urls.
  ///
  /// Gets urls and returns plugin name mapped to list of matched urls.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiCheckUrlsPostRequest] apiCheckUrlsPostRequest:
  Future<Response> apiCheckUrlsPostWithHttpInfo({ ApiCheckUrlsPostRequest? apiCheckUrlsPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/check_urls';

    // ignore: prefer_final_locals
    Object? postBody = apiCheckUrlsPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Gets urls and returns plugin name mapped to list of matched urls.
  ///
  /// Gets urls and returns plugin name mapped to list of matched urls.
  ///
  /// Parameters:
  ///
  /// * [ApiCheckUrlsPostRequest] apiCheckUrlsPostRequest:
  Future<Map<String, List<String>>?> apiCheckUrlsPost({ ApiCheckUrlsPostRequest? apiCheckUrlsPostRequest, }) async {
    final response = await apiCheckUrlsPostWithHttpInfo( apiCheckUrlsPostRequest: apiCheckUrlsPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, List<String>>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, List<String>>'),);

    }
    return null;
  }

  /// Deletes several file entries from pyload.
  ///
  /// Deletes several file entries from pyload.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiDeleteFilesPostRequest] apiDeleteFilesPostRequest:
  Future<Response> apiDeleteFilesPostWithHttpInfo({ ApiDeleteFilesPostRequest? apiDeleteFilesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/delete_files';

    // ignore: prefer_final_locals
    Object? postBody = apiDeleteFilesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Deletes several file entries from pyload.
  ///
  /// Deletes several file entries from pyload.
  ///
  /// Parameters:
  ///
  /// * [ApiDeleteFilesPostRequest] apiDeleteFilesPostRequest:
  Future<void> apiDeleteFilesPost({ ApiDeleteFilesPostRequest? apiDeleteFilesPostRequest, }) async {
    final response = await apiDeleteFilesPostWithHttpInfo( apiDeleteFilesPostRequest: apiDeleteFilesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Deletes all finished files and completely finished packages.
  ///
  /// Deletes all finished files and completely finished packages.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiDeleteFinishedPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/delete_finished';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Deletes all finished files and completely finished packages.
  ///
  /// Deletes all finished files and completely finished packages.
  Future<List<int>?> apiDeleteFinishedPost() async {
    final response = await apiDeleteFinishedPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<int>') as List)
        .cast<int>()
        .toList(growable: false);

    }
    return null;
  }

  /// Deletes packages and containing links.
  ///
  /// Deletes packages and containing links.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiDeletePackagesPostRequest] apiDeletePackagesPostRequest:
  Future<Response> apiDeletePackagesPostWithHttpInfo({ ApiDeletePackagesPostRequest? apiDeletePackagesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/delete_packages';

    // ignore: prefer_final_locals
    Object? postBody = apiDeletePackagesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Deletes packages and containing links.
  ///
  /// Deletes packages and containing links.
  ///
  /// Parameters:
  ///
  /// * [ApiDeletePackagesPostRequest] apiDeletePackagesPostRequest:
  Future<void> apiDeletePackagesPost({ ApiDeletePackagesPostRequest? apiDeletePackagesPostRequest, }) async {
    final response = await apiDeletePackagesPostWithHttpInfo( apiDeletePackagesPostRequest: apiDeletePackagesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Available free space at download directory in bytes.
  ///
  /// Available free space at download directory in bytes.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiFreeSpaceGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/free_space';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Available free space at download directory in bytes.
  ///
  /// Available free space at download directory in bytes.
  Future<int?> apiFreeSpaceGet() async {
    final response = await apiFreeSpaceGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'int',) as int;
    
    }
    return null;
  }

  /// Generates and add packages.
  ///
  /// Generates and add packages.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiCheckAndAddPackagesPostRequest] apiCheckAndAddPackagesPostRequest:
  Future<Response> apiGenerateAndAddPackagesPostWithHttpInfo({ ApiCheckAndAddPackagesPostRequest? apiCheckAndAddPackagesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/generate_and_add_packages';

    // ignore: prefer_final_locals
    Object? postBody = apiCheckAndAddPackagesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Generates and add packages.
  ///
  /// Generates and add packages.
  ///
  /// Parameters:
  ///
  /// * [ApiCheckAndAddPackagesPostRequest] apiCheckAndAddPackagesPostRequest:
  Future<List<int>?> apiGenerateAndAddPackagesPost({ ApiCheckAndAddPackagesPostRequest? apiCheckAndAddPackagesPostRequest, }) async {
    final response = await apiGenerateAndAddPackagesPostWithHttpInfo( apiCheckAndAddPackagesPostRequest: apiCheckAndAddPackagesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<int>') as List)
        .cast<int>()
        .toList(growable: false);

    }
    return null;
  }

  /// Parses links, generates packages names from urls.
  ///
  /// Parses links, generates packages names from urls.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiGeneratePackagesPostRequest] apiGeneratePackagesPostRequest:
  Future<Response> apiGeneratePackagesPostWithHttpInfo({ ApiGeneratePackagesPostRequest? apiGeneratePackagesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/generate_packages';

    // ignore: prefer_final_locals
    Object? postBody = apiGeneratePackagesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parses links, generates packages names from urls.
  ///
  /// Parses links, generates packages names from urls.
  ///
  /// Parameters:
  ///
  /// * [ApiGeneratePackagesPostRequest] apiGeneratePackagesPostRequest:
  Future<Map<String, List<String>>?> apiGeneratePackagesPost({ ApiGeneratePackagesPostRequest? apiGeneratePackagesPostRequest, }) async {
    final response = await apiGeneratePackagesPostWithHttpInfo( apiGeneratePackagesPostRequest: apiGeneratePackagesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, List<String>>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, List<String>>'),);

    }
    return null;
  }

  /// All available account types.
  ///
  /// All available account types.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetAccountTypesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_account_types';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// All available account types.
  ///
  /// All available account types.
  Future<List<String>?> apiGetAccountTypesGet() async {
    final response = await apiGetAccountTypesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get information about all entered accounts.
  ///
  /// Get information about all entered accounts.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [bool] refresh (required):
  ///   reload account info
  Future<Response> apiGetAccountsGetWithHttpInfo(bool refresh,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_accounts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'refresh', refresh));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get information about all entered accounts.
  ///
  /// Get information about all entered accounts.
  ///
  /// Parameters:
  ///
  /// * [bool] refresh (required):
  ///   reload account info
  Future<List<AccountInfo>?> apiGetAccountsGet(bool refresh,) async {
    final response = await apiGetAccountsGetWithHttpInfo(refresh,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AccountInfo>') as List)
        .cast<AccountInfo>()
        .toList(growable: false);

    }
    return null;
  }

  /// Returns all information stored by addon plugins. Values are always strings.
  ///
  /// Returns all information stored by addon plugins. Values are always strings.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetAllInfoGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_all_info';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns all information stored by addon plugins. Values are always strings.
  ///
  /// Returns all information stored by addon plugins. Values are always strings.
  Future<Map<String, Map<String, String>>?> apiGetAllInfoGet() async {
    final response = await apiGetAllInfoGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, Map<String, String>>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, Map<String, String>>'),);

    }
    return null;
  }

  /// returns all known user and info.
  ///
  /// returns all known user and info.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetAllUserDataGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/getAllUserData';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// returns all known user and info.
  ///
  /// returns all known user and info.
  Future<Map<String, OldUserData>?> apiGetAllUserDataGet() async {
    final response = await apiGetAllUserDataGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, OldUserData>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, OldUserData>'),);

    }
    return null;
  }

  /// returns all known user and info.
  ///
  /// returns all known user and info.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetAllUserdataGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_all_userdata';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// returns all known user and info.
  ///
  /// returns all known user and info.
  Future<Map<String, UserData>?> apiGetAllUserdataGet() async {
    final response = await apiGetAllUserdataGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, UserData>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, UserData>'),);

    }
    return null;
  }

  /// No documentation available
  ///
  /// No documentation available
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetCachedirGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_cachedir';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// No documentation available
  ///
  /// No documentation available
  Future<String?> apiGetCachedirGet() async {
    final response = await apiGetCachedirGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Returns a captcha task.
  ///
  /// Returns a captcha task.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [bool] exclusive:
  ///   unused
  Future<Response> apiGetCaptchaTaskGetWithHttpInfo({ bool? exclusive, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_captcha_task';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (exclusive != null) {
      queryParams.addAll(_queryParams('', 'exclusive', exclusive));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns a captcha task.
  ///
  /// Returns a captcha task.
  ///
  /// Parameters:
  ///
  /// * [bool] exclusive:
  ///   unused
  Future<CaptchaTask?> apiGetCaptchaTaskGet({ bool? exclusive, }) async {
    final response = await apiGetCaptchaTaskGetWithHttpInfo( exclusive: exclusive, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CaptchaTask',) as CaptchaTask;
    
    }
    return null;
  }

  /// Get information about captcha task.
  ///
  /// Get information about captcha task.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] tid (required):
  ///   task id
  Future<Response> apiGetCaptchaTaskStatusGetWithHttpInfo(int tid,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_captcha_task_status';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'tid', tid));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get information about captcha task.
  ///
  /// Get information about captcha task.
  ///
  /// Parameters:
  ///
  /// * [int] tid (required):
  ///   task id
  Future<String?> apiGetCaptchaTaskStatusGet(int tid,) async {
    final response = await apiGetCaptchaTaskStatusGetWithHttpInfo(tid,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// same as `get_queue_data` for collector.
  ///
  /// same as `get_queue_data` for collector.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetCollectorDataGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_collector_data';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// same as `get_queue_data` for collector.
  ///
  /// same as `get_queue_data` for collector.
  Future<List<PackageData>?> apiGetCollectorDataGet() async {
    final response = await apiGetCollectorDataGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PackageData>') as List)
        .cast<PackageData>()
        .toList(growable: false);

    }
    return null;
  }

  /// same as `get_queue` for collector.
  ///
  /// same as `get_queue` for collector.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetCollectorGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_collector';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// same as `get_queue` for collector.
  ///
  /// same as `get_queue` for collector.
  Future<List<PackageData>?> apiGetCollectorGet() async {
    final response = await apiGetCollectorGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PackageData>') as List)
        .cast<PackageData>()
        .toList(growable: false);

    }
    return null;
  }

  /// Retrieves complete config in dict format, not for RPC.
  ///
  /// Retrieves complete config in dict format, not for RPC.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetConfigDictGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_config_dict';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Retrieves complete config in dict format, not for RPC.
  ///
  /// Retrieves complete config in dict format, not for RPC.
  Future<Map<String, Object>?> apiGetConfigDictGet() async {
    final response = await apiGetConfigDictGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, Object>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, Object>'),);

    }
    return null;
  }

  /// Retrieves complete config of core.
  ///
  /// Retrieves complete config of core.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetConfigGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_config';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Retrieves complete config of core.
  ///
  /// Retrieves complete config of core.
  Future<Map<String, ConfigSection>?> apiGetConfigGet() async {
    final response = await apiGetConfigGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, ConfigSection>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, ConfigSection>'),);

    }
    return null;
  }

  /// Retrieve config value.
  ///
  /// Retrieve config value.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] category (required):
  ///   name of category, or plugin
  ///
  /// * [String] option (required):
  ///   config option
  ///
  /// * [String] section:
  ///   'plugin' or 'core'
  Future<Response> apiGetConfigValueGetWithHttpInfo(String category, String option, { String? section, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_config_value';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'category', category));
      queryParams.addAll(_queryParams('', 'option', option));
    if (section != null) {
      queryParams.addAll(_queryParams('', 'section', section));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Retrieve config value.
  ///
  /// Retrieve config value.
  ///
  /// Parameters:
  ///
  /// * [String] category (required):
  ///   name of category, or plugin
  ///
  /// * [String] option (required):
  ///   config option
  ///
  /// * [String] section:
  ///   'plugin' or 'core'
  Future<Object?> apiGetConfigValueGet(String category, String option, { String? section, }) async {
    final response = await apiGetConfigValueGetWithHttpInfo(category, option,  section: section, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Lists occurred events, may be affected to changes in the future.
  ///
  /// Lists occurred events, may be affected to changes in the future.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  Future<Response> apiGetEventsGetWithHttpInfo(String uuid,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_events';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'uuid', uuid));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Lists occurred events, may be affected to changes in the future.
  ///
  /// Lists occurred events, may be affected to changes in the future.
  ///
  /// Parameters:
  ///
  /// * [String] uuid (required):
  Future<List<EventInfo>?> apiGetEventsGet(String uuid,) async {
    final response = await apiGetEventsGetWithHttpInfo(uuid,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EventInfo>') as List)
        .cast<EventInfo>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get complete information about a specific file.
  ///
  /// Get complete information about a specific file.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///   file id
  Future<Response> apiGetFileDataGetWithHttpInfo(int fileId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_file_data';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'file_id', fileId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get complete information about a specific file.
  ///
  /// Get complete information about a specific file.
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///   file id
  Future<FileData?> apiGetFileDataGet(int fileId,) async {
    final response = await apiGetFileDataGetWithHttpInfo(fileId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FileData',) as FileData;
    
    }
    return null;
  }

  /// Information about file order within package.
  ///
  /// Information about file order within package.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  Future<Response> apiGetFileOrderGetWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_file_order';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Information about file order within package.
  ///
  /// Information about file order within package.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  Future<Map<String, int>?> apiGetFileOrderGet(int packageId,) async {
    final response = await apiGetFileOrderGetWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, int>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, int>'),);

    }
    return null;
  }

  /// Returns information stored by a specific plugin.
  ///
  /// Returns information stored by a specific plugin.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///   pluginname
  Future<Response> apiGetInfoByPluginGetWithHttpInfo(String plugin,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_info_by_plugin';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'plugin', plugin));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns information stored by a specific plugin.
  ///
  /// Returns information stored by a specific plugin.
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///   pluginname
  Future<Map<String, String>?> apiGetInfoByPluginGet(String plugin,) async {
    final response = await apiGetInfoByPluginGetWithHttpInfo(plugin,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, String>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, String>'),);

    }
    return null;
  }

  /// Returns most recent log entries.
  ///
  /// Returns most recent log entries.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] offset:
  ///   line offset
  Future<Response> apiGetLogGetWithHttpInfo({ int? offset, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_log';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (offset != null) {
      queryParams.addAll(_queryParams('', 'offset', offset));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns most recent log entries.
  ///
  /// Returns most recent log entries.
  ///
  /// Parameters:
  ///
  /// * [int] offset:
  ///   line offset
  Future<List<String>?> apiGetLogGet({ int? offset, }) async {
    final response = await apiGetLogGetWithHttpInfo( offset: offset, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<String>') as List)
        .cast<String>()
        .toList(growable: false);

    }
    return null;
  }

  /// Returns complete information about package, and included files.
  ///
  /// Returns complete information about package, and included files.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiGetPackageDataGetWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_package_data';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns complete information about package, and included files.
  ///
  /// Returns complete information about package, and included files.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<PackageData?> apiGetPackageDataGet(int packageId,) async {
    final response = await apiGetPackageDataGetWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PackageData',) as PackageData;
    
    }
    return null;
  }

  /// Returns information about package, without detailed information about containing files.
  ///
  /// Returns information about package, without detailed information about containing files.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiGetPackageInfoGetWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_package_info';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns information about package, without detailed information about containing files.
  ///
  /// Returns information about package, without detailed information about containing files.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<PackageData?> apiGetPackageInfoGet(int packageId,) async {
    final response = await apiGetPackageInfoGetWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PackageData',) as PackageData;
    
    }
    return null;
  }

  /// Returns information about package order.
  ///
  /// Returns information about package order.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Destination] destination (required):
  ///   `Destination`
  Future<Response> apiGetPackageOrderGetWithHttpInfo(Destination destination,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_package_order';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'destination', destination));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns information about package order.
  ///
  /// Returns information about package order.
  ///
  /// Parameters:
  ///
  /// * [Destination] destination (required):
  ///   `Destination`
  Future<Map<String, int>?> apiGetPackageOrderGet(Destination destination,) async {
    final response = await apiGetPackageOrderGetWithHttpInfo(destination,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, int>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, int>'),);

    }
    return null;
  }

  /// Plugin config as dict, not for RPC.
  ///
  /// Plugin config as dict, not for RPC.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetPluginConfigDictGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_plugin_config_dict';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Plugin config as dict, not for RPC.
  ///
  /// Plugin config as dict, not for RPC.
  Future<Map<String, Object>?> apiGetPluginConfigDictGet() async {
    final response = await apiGetPluginConfigDictGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, Object>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, Object>'),);

    }
    return null;
  }

  /// Retrieves complete config for all plugins.
  ///
  /// Retrieves complete config for all plugins.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetPluginConfigGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_plugin_config';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Retrieves complete config for all plugins.
  ///
  /// Retrieves complete config for all plugins.
  Future<Map<String, ConfigSection>?> apiGetPluginConfigGet() async {
    final response = await apiGetPluginConfigGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, ConfigSection>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, ConfigSection>'),);

    }
    return null;
  }

  /// Return complete data about everything in queue, this is very expensive use it sparely. See `get_queue` for alternative.
  ///
  /// Return complete data about everything in queue, this is very expensive use it sparely. See `get_queue` for alternative.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetQueueDataGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_queue_data';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Return complete data about everything in queue, this is very expensive use it sparely. See `get_queue` for alternative.
  ///
  /// Return complete data about everything in queue, this is very expensive use it sparely. See `get_queue` for alternative.
  Future<List<PackageData>?> apiGetQueueDataGet() async {
    final response = await apiGetQueueDataGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PackageData>') as List)
        .cast<PackageData>()
        .toList(growable: false);

    }
    return null;
  }

  /// Returns info about queue and packages, **not** about files, see `get_queue_data` or `get_package_data` instead.
  ///
  /// Returns info about queue and packages, **not** about files, see `get_queue_data` or `get_package_data` instead.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetQueueGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_queue';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns info about queue and packages, **not** about files, see `get_queue_data` or `get_package_data` instead.
  ///
  /// Returns info about queue and packages, **not** about files, see `get_queue_data` or `get_package_data` instead.
  Future<List<PackageData>?> apiGetQueueGet() async {
    final response = await apiGetQueueGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PackageData>') as List)
        .cast<PackageData>()
        .toList(growable: false);

    }
    return null;
  }

  /// pyLoad Core version.
  ///
  /// pyLoad Core version.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetServerVersionGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_server_version';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// pyLoad Core version.
  ///
  /// pyLoad Core version.
  Future<String?> apiGetServerVersionGet() async {
    final response = await apiGetServerVersionGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// A dict of available services, these can be defined by addon plugins.
  ///
  /// A dict of available services, these can be defined by addon plugins.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetServicesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_services';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// A dict of available services, these can be defined by addon plugins.
  ///
  /// A dict of available services, these can be defined by addon plugins.
  Future<Map<String, Map<String, String>>?> apiGetServicesGet() async {
    final response = await apiGetServicesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, Map<String, String>>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, Map<String, String>>'),);

    }
    return null;
  }

  /// similar to `check_auth` but returns UserData type.
  ///
  /// similar to `check_auth` but returns UserData type.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<Response> apiGetUserDataGetWithHttpInfo(String username, String password,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/getUserData';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));
      queryParams.addAll(_queryParams('', 'password', password));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// similar to `check_auth` but returns UserData type.
  ///
  /// similar to `check_auth` but returns UserData type.
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<OldUserData?> apiGetUserDataGet(String username, String password,) async {
    final response = await apiGetUserDataGetWithHttpInfo(username, password,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OldUserData',) as OldUserData;
    
    }
    return null;
  }

  /// similar to `check_auth` but returns UserData pe.
  ///
  /// similar to `check_auth` but returns UserData pe.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<Response> apiGetUserdataGetWithHttpInfo(String username, String password,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_userdata';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));
      queryParams.addAll(_queryParams('', 'password', password));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// similar to `check_auth` but returns UserData pe.
  ///
  /// similar to `check_auth` but returns UserData pe.
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  ///
  /// * [String] password (required):
  Future<UserData?> apiGetUserdataGet(String username, String password,) async {
    final response = await apiGetUserdataGetWithHttpInfo(username, password,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserData',) as UserData;
    
    }
    return null;
  }

  /// No documentation available
  ///
  /// No documentation available
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiGetUserdirGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/get_userdir';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// No documentation available
  ///
  /// No documentation available
  Future<String?> apiGetUserdirGet() async {
    final response = await apiGetUserdirGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Checks whether a service is available.
  ///
  /// Checks whether a service is available.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///
  /// * [String] funcName (required):
  Future<Response> apiHasServiceGetWithHttpInfo(String plugin, String funcName,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/has_service';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'plugin', plugin));
      queryParams.addAll(_queryParams('', 'func_name', funcName));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks whether a service is available.
  ///
  /// Checks whether a service is available.
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///
  /// * [String] funcName (required):
  Future<bool?> apiHasServiceGet(String plugin, String funcName,) async {
    final response = await apiHasServiceGetWithHttpInfo(plugin, funcName,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// checks if the user is authorized for specific method.
  ///
  /// checks if the user is authorized for specific method.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiIsAuthorizedPostRequest] apiIsAuthorizedPostRequest:
  Future<Response> apiIsAuthorizedPostWithHttpInfo({ ApiIsAuthorizedPostRequest? apiIsAuthorizedPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/is_authorized';

    // ignore: prefer_final_locals
    Object? postBody = apiIsAuthorizedPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// checks if the user is authorized for specific method.
  ///
  /// checks if the user is authorized for specific method.
  ///
  /// Parameters:
  ///
  /// * [ApiIsAuthorizedPostRequest] apiIsAuthorizedPostRequest:
  Future<bool?> apiIsAuthorizedPost({ ApiIsAuthorizedPostRequest? apiIsAuthorizedPostRequest, }) async {
    final response = await apiIsAuthorizedPostWithHttpInfo( apiIsAuthorizedPostRequest: apiIsAuthorizedPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Indicates whether a captcha task is available.
  ///
  /// Indicates whether a captcha task is available.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiIsCaptchaWaitingGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/is_captcha_waiting';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Indicates whether a captcha task is available.
  ///
  /// Indicates whether a captcha task is available.
  Future<bool?> apiIsCaptchaWaitingGet() async {
    final response = await apiIsCaptchaWaitingGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Checks if pyload will start new downloads according to time in config.
  ///
  /// Checks if pyload will start new downloads according to time in config.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiIsTimeDownloadGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/is_time_download';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks if pyload will start new downloads according to time in config.
  ///
  /// Checks if pyload will start new downloads according to time in config.
  Future<bool?> apiIsTimeDownloadGet() async {
    final response = await apiIsTimeDownloadGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Checks if pyload will try to make a reconnect.
  ///
  /// Checks if pyload will try to make a reconnect.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiIsTimeReconnectGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/is_time_reconnect';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Checks if pyload will try to make a reconnect.
  ///
  /// Checks if pyload will try to make a reconnect.
  Future<bool?> apiIsTimeReconnectGet() async {
    final response = await apiIsTimeReconnectGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Clean way to quit pyLoad.
  ///
  /// Clean way to quit pyLoad.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiKillPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/kill';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Clean way to quit pyLoad.
  ///
  /// Clean way to quit pyLoad.
  Future<void> apiKillPost() async {
    final response = await apiKillPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Move multiple files to another package.
  ///
  /// Move multiple files to another package.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiMoveFilesPostRequest] apiMoveFilesPostRequest:
  Future<Response> apiMoveFilesPostWithHttpInfo({ ApiMoveFilesPostRequest? apiMoveFilesPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/move_files';

    // ignore: prefer_final_locals
    Object? postBody = apiMoveFilesPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Move multiple files to another package.
  ///
  /// Move multiple files to another package.
  ///
  /// Parameters:
  ///
  /// * [ApiMoveFilesPostRequest] apiMoveFilesPostRequest:
  Future<void> apiMoveFilesPost({ ApiMoveFilesPostRequest? apiMoveFilesPostRequest, }) async {
    final response = await apiMoveFilesPostWithHttpInfo( apiMoveFilesPostRequest: apiMoveFilesPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Set a new package location.
  ///
  /// Set a new package location.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Destination] destination (required):
  ///   `Destination`
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiMovePackagePostWithHttpInfo(Destination destination, int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/move_package';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'destination', destination));
      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set a new package location.
  ///
  /// Set a new package location.
  ///
  /// Parameters:
  ///
  /// * [Destination] destination (required):
  ///   `Destination`
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<void> apiMovePackagePost(Destination destination, int packageId,) async {
    final response = await apiMovePackagePostWithHttpInfo(destination, packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Gives a new position to a file within its package.
  ///
  /// Gives a new position to a file within its package.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///   file id
  ///
  /// * [int] position (required):
  Future<Response> apiOrderFilePostWithHttpInfo(int fileId, int position,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/order_file';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'file_id', fileId));
      queryParams.addAll(_queryParams('', 'position', position));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Gives a new position to a file within its package.
  ///
  /// Gives a new position to a file within its package.
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///   file id
  ///
  /// * [int] position (required):
  Future<void> apiOrderFilePost(int fileId, int position,) async {
    final response = await apiOrderFilePostWithHttpInfo(fileId, position,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Gives a package a new position.
  ///
  /// Gives a package a new position.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  ///
  /// * [int] position (required):
  Future<Response> apiOrderPackagePostWithHttpInfo(int packageId, int position,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/order_package';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));
      queryParams.addAll(_queryParams('', 'position', position));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Gives a package a new position.
  ///
  /// Gives a package a new position.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  ///
  /// * [int] position (required):
  Future<void> apiOrderPackagePost(int packageId, int position,) async {
    final response = await apiOrderPackagePostWithHttpInfo(packageId, position,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Parses html content or any arbitrary text for links and returns result of `check_urls`
  ///
  /// Parses html content or any arbitrary text for links and returns result of `check_urls`
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiParseUrlsPostRequest] apiParseUrlsPostRequest:
  Future<Response> apiParseUrlsPostWithHttpInfo({ ApiParseUrlsPostRequest? apiParseUrlsPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/parse_urls';

    // ignore: prefer_final_locals
    Object? postBody = apiParseUrlsPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parses html content or any arbitrary text for links and returns result of `check_urls`
  ///
  /// Parses html content or any arbitrary text for links and returns result of `check_urls`
  ///
  /// Parameters:
  ///
  /// * [ApiParseUrlsPostRequest] apiParseUrlsPostRequest:
  Future<Map<String, List<String>>?> apiParseUrlsPost({ ApiParseUrlsPostRequest? apiParseUrlsPostRequest, }) async {
    final response = await apiParseUrlsPostWithHttpInfo( apiParseUrlsPostRequest: apiParseUrlsPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, List<String>>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, List<String>>'),);

    }
    return null;
  }

  /// Pause server: It won't start any new downloads, but nothing gets aborted.
  ///
  /// Pause server: It won't start any new downloads, but nothing gets aborted.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiPauseServerPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/pause_server';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Pause server: It won't start any new downloads, but nothing gets aborted.
  ///
  /// Pause server: It won't start any new downloads, but nothing gets aborted.
  Future<void> apiPauseServerPost() async {
    final response = await apiPauseServerPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Polls the result available for ResultID.
  ///
  /// Polls the result available for ResultID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] rid (required):
  ///   `ResultID`
  Future<Response> apiPollResultsGetWithHttpInfo(int rid,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/poll_results';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'rid', rid));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Polls the result available for ResultID.
  ///
  /// Polls the result available for ResultID.
  ///
  /// Parameters:
  ///
  /// * [int] rid (required):
  ///   `ResultID`
  Future<OnlineCheck?> apiPollResultsGet(int rid,) async {
    final response = await apiPollResultsGetWithHttpInfo(rid,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OnlineCheck',) as OnlineCheck;
    
    }
    return null;
  }

  /// Moves package from Queue to Collector.
  ///
  /// Moves package from Queue to Collector.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiPullFromQueuePostWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pull_from_queue';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Moves package from Queue to Collector.
  ///
  /// Moves package from Queue to Collector.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<void> apiPullFromQueuePost(int packageId,) async {
    final response = await apiPullFromQueuePostWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Moves package from Collector to Queue.
  ///
  /// Moves package from Collector to Queue.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiPushToQueuePostWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/push_to_queue';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Moves package from Collector to Queue.
  ///
  /// Moves package from Collector to Queue.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<void> apiPushToQueuePost(int packageId,) async {
    final response = await apiPushToQueuePostWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Probes online status of all files in a package, also a default action when package is added.
  ///
  /// Probes online status of all files in a package, also a default action when package is added.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  Future<Response> apiRecheckPackagePostWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/recheck_package';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Probes online status of all files in a package, also a default action when package is added.
  ///
  /// Probes online status of all files in a package, also a default action when package is added.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  Future<void> apiRecheckPackagePost(int packageId,) async {
    final response = await apiRecheckPackagePostWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Remove account from pyload.
  ///
  /// Remove account from pyload.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///   pluginname
  ///
  /// * [String] account (required):
  ///   accountname
  Future<Response> apiRemoveAccountPostWithHttpInfo(String plugin, String account,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/remove_account';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'plugin', plugin));
      queryParams.addAll(_queryParams('', 'account', account));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Remove account from pyload.
  ///
  /// Remove account from pyload.
  ///
  /// Parameters:
  ///
  /// * [String] plugin (required):
  ///   pluginname
  ///
  /// * [String] account (required):
  ///   accountname
  Future<void> apiRemoveAccountPost(String plugin, String account,) async {
    final response = await apiRemoveAccountPostWithHttpInfo(plugin, account,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// deletes a user login.
  ///
  /// deletes a user login.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  Future<Response> apiRemoveUserPostWithHttpInfo(String user,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/remove_user';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'user', user));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// deletes a user login.
  ///
  /// deletes a user login.
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  Future<bool?> apiRemoveUserPost(String user,) async {
    final response = await apiRemoveUserPostWithHttpInfo(user,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Restarts all failed failes.
  ///
  /// Restarts all failed failes.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiRestartFailedPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/restart_failed';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Restarts all failed failes.
  ///
  /// Restarts all failed failes.
  Future<void> apiRestartFailedPost() async {
    final response = await apiRestartFailedPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Resets file status, so it will be downloaded again.
  ///
  /// Resets file status, so it will be downloaded again.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///    file id
  Future<Response> apiRestartFilePostWithHttpInfo(int fileId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/restart_file';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'file_id', fileId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Resets file status, so it will be downloaded again.
  ///
  /// Resets file status, so it will be downloaded again.
  ///
  /// Parameters:
  ///
  /// * [int] fileId (required):
  ///    file id
  Future<void> apiRestartFilePost(int fileId,) async {
    final response = await apiRestartFilePostWithHttpInfo(fileId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Restarts a package, resets every containing files.
  ///
  /// Restarts a package, resets every containing files.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<Response> apiRestartPackagePostWithHttpInfo(int packageId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/restart_package';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Restarts a package, resets every containing files.
  ///
  /// Restarts a package, resets every containing files.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  Future<void> apiRestartPackagePost(int packageId,) async {
    final response = await apiRestartPackagePostWithHttpInfo(packageId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Restart pyload core.
  ///
  /// Restart pyload core.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiRestartPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/restart';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Restart pyload core.
  ///
  /// Restart pyload core.
  Future<void> apiRestartPost() async {
    final response = await apiRestartPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Calls a service (a method in addon plugin).
  ///
  /// Calls a service (a method in addon plugin).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiServiceCallPostRequest] apiServiceCallPostRequest:
  Future<Response> apiServiceCallPostWithHttpInfo({ ApiServiceCallPostRequest? apiServiceCallPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/service_call';

    // ignore: prefer_final_locals
    Object? postBody = apiServiceCallPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Calls a service (a method in addon plugin).
  ///
  /// Calls a service (a method in addon plugin).
  ///
  /// Parameters:
  ///
  /// * [ApiServiceCallPostRequest] apiServiceCallPostRequest:
  Future<String?> apiServiceCallPost({ ApiServiceCallPostRequest? apiServiceCallPostRequest, }) async {
    final response = await apiServiceCallPostWithHttpInfo( apiServiceCallPostRequest: apiServiceCallPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Set result for a captcha task.
  ///
  /// Set result for a captcha task.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] tid (required):
  ///   task id
  ///
  /// * [String] result (required):
  ///   captcha result
  Future<Response> apiSetCaptchaResultPostWithHttpInfo(int tid, String result,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/set_captcha_result';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'tid', tid));
      queryParams.addAll(_queryParams('', 'result', result));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set result for a captcha task.
  ///
  /// Set result for a captcha task.
  ///
  /// Parameters:
  ///
  /// * [int] tid (required):
  ///   task id
  ///
  /// * [String] result (required):
  ///   captcha result
  Future<void> apiSetCaptchaResultPost(int tid, String result,) async {
    final response = await apiSetCaptchaResultPostWithHttpInfo(tid, result,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Set new config value.
  ///
  /// Set new config value.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiSetConfigValuePostRequest] apiSetConfigValuePostRequest:
  Future<Response> apiSetConfigValuePostWithHttpInfo({ ApiSetConfigValuePostRequest? apiSetConfigValuePostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/set_config_value';

    // ignore: prefer_final_locals
    Object? postBody = apiSetConfigValuePostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set new config value.
  ///
  /// Set new config value.
  ///
  /// Parameters:
  ///
  /// * [ApiSetConfigValuePostRequest] apiSetConfigValuePostRequest:
  Future<void> apiSetConfigValuePost({ ApiSetConfigValuePostRequest? apiSetConfigValuePostRequest, }) async {
    final response = await apiSetConfigValuePostWithHttpInfo( apiSetConfigValuePostRequest: apiSetConfigValuePostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Allows to modify several package attributes.
  ///
  /// Allows to modify several package attributes.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiSetPackageDataPostRequest] apiSetPackageDataPostRequest:
  Future<Response> apiSetPackageDataPostWithHttpInfo({ ApiSetPackageDataPostRequest? apiSetPackageDataPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/set_package_data';

    // ignore: prefer_final_locals
    Object? postBody = apiSetPackageDataPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Allows to modify several package attributes.
  ///
  /// Allows to modify several package attributes.
  ///
  /// Parameters:
  ///
  /// * [ApiSetPackageDataPostRequest] apiSetPackageDataPostRequest:
  Future<void> apiSetPackageDataPost({ ApiSetPackageDataPostRequest? apiSetPackageDataPostRequest, }) async {
    final response = await apiSetPackageDataPostWithHttpInfo( apiSetPackageDataPostRequest: apiSetPackageDataPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Renames a package.
  ///
  /// Renames a package.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  ///
  /// * [String] name (required):
  ///   new package name
  Future<Response> apiSetPackageNamePostWithHttpInfo(int packageId, String name,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/set_package_name';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'package_id', packageId));
      queryParams.addAll(_queryParams('', 'name', name));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Renames a package.
  ///
  /// Renames a package.
  ///
  /// Parameters:
  ///
  /// * [int] packageId (required):
  ///   package id
  ///
  /// * [String] name (required):
  ///   new package name
  Future<void> apiSetPackageNamePost(int packageId, String name,) async {
    final response = await apiSetPackageNamePostWithHttpInfo(packageId, name,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// No documentation available
  ///
  /// No documentation available
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [int] permission (required):
  ///
  /// * [int] role (required):
  Future<Response> apiSetUserPermissionPostWithHttpInfo(String user, int permission, int role,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/set_user_permission';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'user', user));
      queryParams.addAll(_queryParams('', 'permission', permission));
      queryParams.addAll(_queryParams('', 'role', role));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// No documentation available
  ///
  /// No documentation available
  ///
  /// Parameters:
  ///
  /// * [String] user (required):
  ///
  /// * [int] permission (required):
  ///
  /// * [int] role (required):
  Future<void> apiSetUserPermissionPost(String user, int permission, int role,) async {
    final response = await apiSetUserPermissionPostWithHttpInfo(user, permission, role,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Status of all currently running downloads.
  ///
  /// Status of all currently running downloads.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiStatusDownloadsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/status_downloads';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Status of all currently running downloads.
  ///
  /// Status of all currently running downloads.
  Future<List<DownloadInfo>?> apiStatusDownloadsGet() async {
    final response = await apiStatusDownloadsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DownloadInfo>') as List)
        .cast<DownloadInfo>()
        .toList(growable: false);

    }
    return null;
  }

  /// Some general information about the current status of pyLoad.
  ///
  /// Some general information about the current status of pyLoad.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiStatusServerGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/status_server';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Some general information about the current status of pyLoad.
  ///
  /// Some general information about the current status of pyLoad.
  Future<ServerStatus?> apiStatusServerGet() async {
    final response = await apiStatusServerGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ServerStatus',) as ServerStatus;
    
    }
    return null;
  }

  /// Aborts all running downloads.
  ///
  /// Aborts all running downloads.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiStopAllDownloadsPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/stop_all_downloads';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Aborts all running downloads.
  ///
  /// Aborts all running downloads.
  Future<void> apiStopAllDownloadsPost() async {
    final response = await apiStopAllDownloadsPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Aborts specific downloads.
  ///
  /// Aborts specific downloads.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiStopDownloadsPostRequest] apiStopDownloadsPostRequest:
  Future<Response> apiStopDownloadsPostWithHttpInfo({ ApiStopDownloadsPostRequest? apiStopDownloadsPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/stop_downloads';

    // ignore: prefer_final_locals
    Object? postBody = apiStopDownloadsPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Aborts specific downloads.
  ///
  /// Aborts specific downloads.
  ///
  /// Parameters:
  ///
  /// * [ApiStopDownloadsPostRequest] apiStopDownloadsPostRequest:
  Future<void> apiStopDownloadsPost({ ApiStopDownloadsPostRequest? apiStopDownloadsPostRequest, }) async {
    final response = await apiStopDownloadsPostWithHttpInfo( apiStopDownloadsPostRequest: apiStopDownloadsPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Toggle pause state.
  ///
  /// Toggle pause state.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiTogglePausePostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/toggle_pause';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Toggle pause state.
  ///
  /// Toggle pause state.
  Future<bool?> apiTogglePausePost() async {
    final response = await apiTogglePausePostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Toggle proxy activation.
  ///
  /// Toggle proxy activation.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiToggleProxyPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/toggle_proxy';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Toggle proxy activation.
  ///
  /// Toggle proxy activation.
  Future<bool?> apiToggleProxyPost() async {
    final response = await apiToggleProxyPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Toggle reconnect activation.
  ///
  /// Toggle reconnect activation.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiToggleReconnectPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/toggle_reconnect';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Toggle reconnect activation.
  ///
  /// Toggle reconnect activation.
  Future<bool?> apiToggleReconnectPost() async {
    final response = await apiToggleReconnectPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Unpause server: New Downloads will be started.
  ///
  /// Unpause server: New Downloads will be started.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> apiUnpauseServerPostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/unpause_server';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Unpause server: New Downloads will be started.
  ///
  /// Unpause server: New Downloads will be started.
  Future<void> apiUnpauseServerPost() async {
    final response = await apiUnpauseServerPostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Changes pw/options for specific account.
  ///
  /// Changes pw/options for specific account.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ApiUpdateAccountPostRequest] apiUpdateAccountPostRequest:
  Future<Response> apiUpdateAccountPostWithHttpInfo({ ApiUpdateAccountPostRequest? apiUpdateAccountPostRequest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/update_account';

    // ignore: prefer_final_locals
    Object? postBody = apiUpdateAccountPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Changes pw/options for specific account.
  ///
  /// Changes pw/options for specific account.
  ///
  /// Parameters:
  ///
  /// * [ApiUpdateAccountPostRequest] apiUpdateAccountPostRequest:
  Future<void> apiUpdateAccountPost({ ApiUpdateAccountPostRequest? apiUpdateAccountPostRequest, }) async {
    final response = await apiUpdateAccountPostWithHttpInfo( apiUpdateAccountPostRequest: apiUpdateAccountPostRequest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Uploads and adds a container file to pyLoad.
  ///
  /// Uploads and adds a container file to pyLoad.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] filename (required):
  ///   file name - extension is important, so it can correctly decrypt
  ///
  /// * [MultipartFile] data (required):
  ///   file content
  ///
  /// * [Destination] dest:
  ///   `Destination`
  Future<Response> apiUploadContainerPostWithHttpInfo(String filename, MultipartFile data, { Destination? dest, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/upload_container';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('POST', Uri.parse(path));
    if (filename != null) {
      hasFields = true;
      mp.fields[r'filename'] = parameterToString(filename);
    }
    if (data != null) {
      hasFields = true;
      mp.files.add(data);
    }
    if (dest != null) {
      hasFields = true;
      mp.fields[r'dest'] = parameterToString(dest);
    }
    if (hasFields) {
      postBody = mp;
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Uploads and adds a container file to pyLoad.
  ///
  /// Uploads and adds a container file to pyLoad.
  ///
  /// Parameters:
  ///
  /// * [String] filename (required):
  ///   file name - extension is important, so it can correctly decrypt
  ///
  /// * [MultipartFile] data (required):
  ///   file content
  ///
  /// * [Destination] dest:
  ///   `Destination`
  Future<void> apiUploadContainerPost(String filename, MultipartFile data, { Destination? dest, }) async {
    final response = await apiUploadContainerPostWithHttpInfo(filename, data,  dest: dest, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Check if a user actually exists in the database.
  ///
  /// Check if a user actually exists in the database.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  Future<Response> apiUserExistsGetWithHttpInfo(String username,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/user_exists';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'username', username));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Check if a user actually exists in the database.
  ///
  /// Check if a user actually exists in the database.
  ///
  /// Parameters:
  ///
  /// * [String] username (required):
  Future<bool?> apiUserExistsGet(String username,) async {
    final response = await apiUserExistsGetWithHttpInfo(username,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }
}
