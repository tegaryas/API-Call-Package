part of kd_api_call;

class AppException implements Exception {
  final String? message;
  final String? title;
  final ExceptionType type;
  final int statusCode;

  AppException({
    this.title,
    this.message,
    this.type = ExceptionType.None,
    this.statusCode = 200,
  });

  AlertInfo get getAlertInfo {
    String alertTitle = "";
    String msg = "";
    switch (type) {
      // No Internet...
      case ExceptionType.NoInternet:
        alertTitle = APIErrorMsg.noInternet;
        msg = APIErrorMsg.noInternetMsg;
        break;

      // Un-Authorised...
      case ExceptionType.UnAuthorised:
        alertTitle = title ?? APIErrorMsg.unAuthorisedTitle;
        msg = message ?? APIErrorMsg.unAuthorisedMsg;
        break;

      // HTTP Exception...
      case ExceptionType.HTTPException:
        alertTitle = title ?? APIErrorMsg.defaultErrorTitle;
        msg = message ?? APIErrorMsg.somethingWentWrong;
        break;

      // Format Exception...(Backend side have an invalid value set in the 'Request Format' property of a REST API method, or don't have any value set at all.)
      case ExceptionType.FormatException:
        alertTitle = title ?? APIErrorMsg.defaultErrorTitle;
        msg = message ?? APIErrorMsg.somethingWentWrong;
        break;

      // General Error...
      case ExceptionType.None:
        alertTitle = title ?? APIErrorMsg.defaultErrorTitle;
        msg = message ?? APIErrorMsg.somethingWentWrong;
        break;

      // Under Maintainance...
      case ExceptionType.UnderMaintainance:
        alertTitle = title ?? APIErrorMsg.underMaintainanceTitle;
        msg = message ?? APIErrorMsg.underMaintainanceMsg;
        break;

      // Timeout...
      case ExceptionType.TimeOut:
        alertTitle = title ?? APIErrorMsg.requestTimeOutTitle;
        msg = message ?? APIErrorMsg.requestTimeOutMessage;
        break;
    }
    return AlertInfo(title: alertTitle, message: msg);
  }

  String get getTitle => getAlertInfo.title;
  String get getMessage => getAlertInfo.message;
}

enum ExceptionType {
  NoInternet,
  HTTPException,
  FormatException,
  UnAuthorised,
  UnderMaintainance,
  TimeOut,
  None,
}

class AlertInfo {
  final String title;
  final String message;
  AlertInfo({
    required this.title,
    required this.message,
  });
}

// Http request type...
enum HTTPRequestType {
  POST,
  GET,
  DELETE,
  PUT,
  PATCH,

}
