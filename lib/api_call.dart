part of kd_api_call;

class ApiCall {
  // Call API...
  static Future<http.Response> callService({
    required APIRequestInfoObj requestInfo,
  }) async {
    try {
      // Check Internet...
      await checkConnectivity();

      // Print Request info...
      _printApiDetial(requestInfo);

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
      throw error;
    }
  }

  //Check Internet connectivity...
  static Future<void> checkConnectivity() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw AppException(
        title: APIErrorMsg.noInternet,
        message: APIErrorMsg.noInternetMsg,
      );
    }
  }

  //Call API...
  static Future<http.Response> _callAPI({
    required APIRequestInfoObj requestInfo,
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
          // Uri(),
          body: json.encode(requestInfo.parameter),
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
          headers: apiHeader,
        );
        break;
      case HTTPRequestType.PUT:
        response = await http.put(
          Uri.parse(_url),
          body: json.encode(requestInfo.parameter),
          headers: apiHeader,
        );
        break;
    }

    // Print Request info...
    _printResponse(response, requestInfo.serviceName);

    //Return Received Response...
    return response;
  }

  // Multipart request...
  static Future<http.Response> _callMultipartAPI({
    required APIRequestInfoObj requestInfo,
  }) async {
    //Get URI...
    Uri uri = Uri.parse(requestInfo.url);
    http.MultipartRequest request = http.MultipartRequest(
        requestInfo.requestType.toString().split(".").last, uri);

    //Add Parameters...
    requestInfo.parameter?.forEach((key, value) => request.fields[key] = value);

    //Add header...
    Map<String, dynamic>? apiHeader = requestInfo.headers;
    apiHeader?.forEach((key, value) => request.headers[key] = value);

    //Add Attached File...
    List<UploadDocumentObj> docList = requestInfo.docList;
    if (docList.isNotEmpty) {
      for (int i = 0; i < docList.length; i++) {
        if (docList[i].docKey.isNotEmpty && docList[i].docPathList.isNotEmpty) {
          for (int j = 0; j < docList[i].docPathList.length; j++) {
            request.files.add(
              await http.MultipartFile.fromPath(
                  docList[i].docKey, docList[i].docPathList[j],
                  filename: basename(docList[i].docPathList[j])),
            );
          }
        }
      }
    }

    //Send Request...
    http.Response response =
        await http.Response.fromStream(await request.send());

    // Print Request info...
    _printResponse(response, requestInfo.serviceName);

    //Return Received Response...
    return response;
  }

  // API info...
  static void _printApiDetial(APIRequestInfoObj info) {
    if (kReleaseMode) return;
    String apiLog = """

        ${info.serviceName} Service Parameters
        |-------------------------------------------------------------------------------------------------------------------------
        | ApiType :- ${info.requestType.toString().split(".").last}
        | URL     :- ${info.url}
        | Params  :- ${info.parameter}
        |-------------------------------------------------------------------------------------------------------------------------
        """;
    print(apiLog);
  }

  // API resposne info...
  static void _printResponse(http.Response response, String serviceName) {
    if (kReleaseMode) return;
    if (response.statusCode < 300) return;
    String apiLog = """

        $serviceName Service Response
        |--------------------------------------------------------------------------------------------------------------------------
        | API        :- $serviceName
        | StatusCode :- ${response.statusCode}
        | Message    :- ${response.body}
        |--------------------------------------------------------------------------------------------------------------------------
        """;
    print(apiLog);
  }
}

// API Request Obj...
class APIRequestInfoObj {
  HTTPRequestType requestType;
  String url;
  Map<String, dynamic>? parameter;
  Map<String, String>? headers;
  List<UploadDocumentObj> docList;
  String serviceName;
  int timeSecond = 30;

  APIRequestInfoObj({
    this.requestType = HTTPRequestType.POST,
    this.parameter,
    this.headers,
    this.docList = const [],
    required this.url,
    this.serviceName = "",
    this.timeSecond = 30,
  });
}

//Uploading document Object...
class UploadDocumentObj {
  String docKey;
  List<String> docPathList;

  UploadDocumentObj({
    this.docKey = "",
    this.docPathList = const [],
  });
}
