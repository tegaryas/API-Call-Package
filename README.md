A composable, Future-based library for making HTTP requests.

[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)


This package contains a set of high-level functions and classes that make it
easy to consume HTTP resources. It's multi-platform, and supports mobile, desktop,
and the browser.

## Using

The easiest way to use this library is via the top-level functions. They allow
you to make individual HTTP requests with minimal hassle:

```dart
import 'package:kd_api_call/kd_api_call.dart';

 APIRequestInfoObj requestInfo = APIRequestInfoObj(
        url: "https://jsonplaceholder.typicode.com/albums/1",
        requestType: HTTPRequestType.GET,
      );

Response apiResponse =
          await ApiCall.callService(requestInfo: requestInfo);

```