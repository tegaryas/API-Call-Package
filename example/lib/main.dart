import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kd_api_call/kd_api_call.dart';

void main() {
  // Run app...
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Api response...
  http.Response? apiResponse;

  // Flag...
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch data from internet...
    fetchData();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          // App bar...
          appBar: AppBar(
            title: const Text('Kd Api Call Example'),
          ),
          // Body...
          body: _buildBody(),
        ),
      );

  // Body...
  Widget _buildBody() => Center(
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : apiResponse == null
                ? const Text('Something went wrong!')
                : Text(apiResponse!.body),
      );

  // Fetch data from internet...
  Future<void> fetchData() async {
    try {
      // Start loading...
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      // Api request info...
      APIRequestInfoObj requestInfo = APIRequestInfoObj(
        url: "https://jsonplaceholder.typicode.com/albums/1",
        requestType: HTTPRequestType.GET,
      );

      // Call api...
      // Await the http get response, then decode the json-formatted response.
      apiResponse = await ApiCall.callService(requestInfo: requestInfo);
    } catch (e) {
      // Show error in snack bar...
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      // Stop loading...
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
