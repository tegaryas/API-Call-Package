part of kd_api_call;

class ApiCallPlatInstance {
  ApiCallPlatInstance._();
  static ApiCallPlatInstance get apiInstance => ApiCallPlatInstance._();

  // Call API...
  Future<http.Response> callService({
    required APIRequestInfo requestInfo,
  }) async {
    try {
      // Check Internet...
      await checkConnectivity();

      // Print Request info...
      if (kDebugMode) {
        _printApiDetial(requestInfo);
      }

      // Get Response...
      return requestInfo.docList.isEmpty
          ? await _callAPI(requestInfo: requestInfo)
              .timeout(Duration(seconds: requestInfo.timeSecond))
          : await _callMultipartAPI(requestInfo: requestInfo)
              .timeout(Duration(seconds: requestInfo.timeSecond));

      // Exceptions...
    } on SocketException catch (e) {
      throw AppException(
        message: e.message,
        type: ExceptionType.NoInternet,
      );
    } on HttpException catch (e) {
      throw AppException(
        message: e.message,
        type: ExceptionType.HTTPException,
      );
    } on FormatException catch (e) {
      throw AppException(
        message: e.source?.toString(),
        type: ExceptionType.FormatException,
      );
    } on TimeoutException {
      throw AppException(
        title: APIErrorMsg.requestTimeOutTitle,
        message: APIErrorMsg.requestTimeOutMessage,
        type: ExceptionType.TimeOut,
      );
    } catch (error) {
      rethrow;
    }
  }

  //Check Internet connectivity...
  Future<bool> checkConnectivity() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw AppException(
        title: APIErrorMsg.noInternet,
        message: APIErrorMsg.noInternetMsg,
      );
    }
    return true;
  }

  //Call API...
  Future<http.Response> _callAPI({
    required APIRequestInfo requestInfo,
  }) async {
    // final URL...
    String _url = requestInfo.url;

    // Http Response...
    http.Response response;

    // Add header...
    Map<String, String>? apiHeader = requestInfo.headers;

    //Call API with respect to request type...
    switch (requestInfo.requestType) {
      case HTTPRequestType.POST:
        response = await http.post(
          Uri.parse(_url),
          body:
              (requestInfo.parameter is Map?) || (requestInfo.parameter is Map)
                  ? json.encode(requestInfo.parameter)
                  : requestInfo.parameter,
          headers: apiHeader,
        );
        break;
      case HTTPRequestType.GET:
        response = await http.get(
          Uri.parse(_url),
          headers: apiHeader,
        );
        break;
      case HTTPRequestType.DELETE:
        response = await http.delete(
          Uri.parse(_url),
          body:
              (requestInfo.parameter is Map?) || (requestInfo.parameter is Map)
                  ? json.encode(requestInfo.parameter)
                  : requestInfo.parameter,
          headers: apiHeader,
        );
        break;
      case HTTPRequestType.PUT:
        response = await http.put(
          Uri.parse(_url),
          body:
              (requestInfo.parameter is Map?) || (requestInfo.parameter is Map)
                  ? json.encode(requestInfo.parameter)
                  : requestInfo.parameter,
          headers: apiHeader,
        );
        break;
      case HTTPRequestType.PATCH:
        response = await http.patch(
          Uri.parse(_url),
          body:
              (requestInfo.parameter is Map?) || (requestInfo.parameter is Map)
                  ? json.encode(requestInfo.parameter)
                  : requestInfo.parameter,
          headers: apiHeader,
        );
        break;
    }

    // Print Request info...
    if (kDebugMode) {
      _printResponse(response, requestInfo.serviceName);
    }

    //Return Received Response...
    return response;
  }

  // Multipart request...
  Future<http.Response> _callMultipartAPI({
    required APIRequestInfo requestInfo,
  }) async {
    //Get URI...
    Uri uri = Uri.parse(requestInfo.url);
    http.MultipartRequest request = http.MultipartRequest(
      describeEnum(requestInfo.requestType),
      uri,
    );

    //Add Parameters...
    if ((requestInfo.parameter is Map?) || (requestInfo.parameter is Map)) {
      (requestInfo.parameter as Map<String, dynamic>?)
          ?.forEach((key, value) => request.fields[key] = value);
    } else {
      request.fields.addAll(jsonDecode(requestInfo.parameter as String));
    }

    //Add header...
    Map<String, String>? apiHeader = requestInfo.headers;
    apiHeader?.forEach((key, value) => request.headers[key] = value);

    //Set Documents
    List<Future<http.MultipartFile>> _files = requestInfo.docList
        .map(
          (docInfo) => docInfo.docPathList.map(
            (docPath) => http.MultipartFile.fromPath(
              docInfo.docKey,
              docPath,
              filename: basename(docPath),
            ).catchError(
              (error) {
                debugPrint(
                    "-----------------Error While uploading Image: $docPath, Error: $error -----------------");
              },
            ),
          ),
        )
        .expand((multipartFile) => multipartFile)
        .toList();

    // Upload all files...
    List<http.MultipartFile> _multiPartFiles =
        await Future.wait<http.MultipartFile>(_files);
    request.files.addAll(_multiPartFiles);

    //Send Request...
    http.Response response =
        await http.Response.fromStream(await request.send());

    // Print Request info...
    if (kDebugMode) {
      _printResponse(response, requestInfo.serviceName);
    }

    //Return Received Response...
    return response;
  }

  // API info...
  void _printApiDetial(APIRequestInfo info) {
    String apiLog = """

        ${info.serviceName} Service Parameters
        |-------------------------------------------------------------------------------------------------------------------------
        | ApiType :- ${describeEnum(info.requestType)}
        | URL     :- ${info.url}
        | Header  :- ${info.headers}
        | Params  :- ${info.parameter}
        |-------------------------------------------------------------------------------------------------------------------------
        """;
    debugPrint(apiLog);
  }

  // API resposne info...
  void _printResponse(http.Response response, String serviceName) {
    String apiLog = """

        $serviceName Service Response
        |--------------------------------------------------------------------------------------------------------------------------
        | API        :- $serviceName
        | StatusCode :- ${response.statusCode}
        | Message    :- ${response.body}
        |--------------------------------------------------------------------------------------------------------------------------
        """;
    debugPrint(apiLog);
  }
}

// API Request Obj...
class APIRequestInfo {
  HTTPRequestType requestType;
  String url;
  Object? parameter;
  Map<String, String>? headers;
  List<UploadDocument> docList;
  String serviceName;
  int timeSecond = 90;

  APIRequestInfo({
    this.requestType = HTTPRequestType.POST,
    this.parameter,
    this.headers,
    this.docList = const [],
    required this.url,
    this.serviceName = "",
    this.timeSecond = 90,
  });
}

//Uploading document Object...
class UploadDocument {
  String docKey;
  List<String> docPathList;

  UploadDocument({
    this.docKey = "",
    this.docPathList = const [],
  });
}
