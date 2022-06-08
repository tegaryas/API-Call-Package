A Future-based library that allows you to make simple HTTP requests.

[![pub package](https://img.shields.io/pub/v/logger.svg?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/kd_api_call)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Code size](https://img.shields.io/github/languages/code-size/leisim/logger?logo=github&logoColor=white)](https://gitlab.com/kdsutariya3022/api-call-package)
[![License](https://img.shields.io/github/license/leisim/logger?logo=open-source-initiative&logoColor=green)](https://gitlab.com/kdsutariya3022/api-call-package/blob/master/LICENSE)


This package contains a set of high-level functions and classes that make it
easy to consume HTTP resources. It's multi-platform, and supports mobile, desktop,
and the browser.

  - [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Initialization](#initialization)
  - [Usage](#Usage)
  - [Parameters and Response Logs](#parameters-and-response-logs)
  - [Examples](https://pub.dev/packages/kd_api_call/example)
  - [License](https://pub.dev/packages/kd_api_call/license)
  - [Features and bugs](#features-and-bugs)

### Getting Started
First and foremost, welcome to the easy-to-use service method.

### Installation

Add dependency

```yaml
dependencies:
  kd_api_call: ^0.1.0
```

### Initialization

First, import dependeny:
```dart
import 'package:kd_api_call/kd_api_call.dart';
```

### Usage

The top-level functions are the simplest method to utilise this module. They let
you make individual HTTP queries with a minimum of fuss:

```dart
import 'package:kd_api_call/kd_api_call.dart';

APIRequestInfo requestInfo = APIRequestInfo(
        url: "https://jsonplaceholder.typicode.com/albums/1",
        requestType: HTTPRequestType.GET,
      );

Response apiResponse =
          await ApiCall.instance.callService(requestInfo: requestInfo);

```
You can find a complete example [here](./example/lib/main.dart)

### Parameters and Response Logs

```text
 Service Parameters
|-------------------------------------------------------------------------------------------------------------------------
| ApiType :- GET
| URL     :- https://jsonplaceholder.typicode.com/albums/1
| Header  :- {Content-Type: application/json}
| Params  :- null
|-------------------------------------------------------------------------------------------------------------------------
```

```text
 Service Response
|--------------------------------------------------------------------------------------------------------------------------
| API        :- https://jsonplaceholder.typicode.com/albums/1
| StatusCode :- 200
| Message    :- {"userId": 1, "id": 1, "title": "quidem molestiae enim"
|--------------------------------------------------------------------------------------------------------------------------
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://gitlab.com/kdsutariya3022/api-call-package/-/issues).