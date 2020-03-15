import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:coronavirus/app/services/api.dart';

class APIService {
  APIService(this.api);
  final API api;

  // add async before method because we're using await within it
  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri().toString(),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );

    if (response.statusCode == 200) {
      // taking response body (string) and pass to json.decode, parse it and return a map of key/value pairs
      // send request from ncov_2019_api.http to see
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print('Request ${api.tokenUri()} failed.\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}