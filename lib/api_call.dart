part of kd_api_call;

class ApiCall {
  // Instance...
  static ApiCallPlatInstance get instance => ApiCallPlatInstance.apiInstance;

  @Deprecated(
    'Switch to using instance instead '
    'This feature was deprecated after v0.0.9.',
  )
  // Call API...
  static Future<http.Response> callService({
    required APIRequestInfoObj requestInfo,
  }) =>
      instance.callService(requestInfo: _convertObjToModal(requestInfo));

  @Deprecated(
    'Switch to using instance instead '
    'This feature was deprecated after v0.0.9.',
  )
  //Check Internet connectivity...
  static Future<bool> checkConnectivity() => instance.checkConnectivity();

  // ignore: deprecated_member_use_from_same_package
  static APIRequestInfo _convertObjToModal(APIRequestInfoObj doc) =>
      // ignore: deprecated_member_use_from_same_package
      APIRequestInfo(
          url: doc.url,
          docList: doc.docList
              .map((e) =>
                  // ignore: deprecated_member_use_from_same_package
                  UploadDocument(docKey: e.docKey, docPathList: e.docPathList))
              .toList(),
          headers: doc.headers,
          parameter: doc.parameter,
          requestType: doc.requestType,
          serviceName: doc.serviceName,
          timeSecond: doc.timeSecond);
}

// API Request Obj...
@Deprecated(
  'Use APIRequestInfo instead. '
  'This feature was deprecated after v0.0.9.',
)
class APIRequestInfoObj {
  HTTPRequestType requestType;
  String url;
  Object? parameter;
  Map<String, String>? headers;
  List<UploadDocumentObj> docList;
  String serviceName;
  int timeSecond = 90;

  APIRequestInfoObj({
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
@Deprecated(
  'Use UploadDocument instead. '
  'This feature was deprecated after v0.0.9.',
)
class UploadDocumentObj {
  String docKey;
  List<String> docPathList;

  UploadDocumentObj({
    this.docKey = "",
    this.docPathList = const [],
  });
}
