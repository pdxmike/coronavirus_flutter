import 'package:coronavirus/app/repositories/enpoints_data.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({@required this.apiService});
  final APIService apiService;

  String _accessToken;

  Future<int> getEndpointData(Endpoint endpoint) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await apiService.getEndpointData(
          accessToken: _accessToken, endpoint: endpoint);
    } on Response catch (response) {
      // if unauthorized, get generate new access token
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint);
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait(
      [
        apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.cases),
        apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
        apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
        apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.deaths),
        apiService.getEndpointData(
            accessToken: _accessToken, endpoint: Endpoint.recovered),
      ],
    );
    // Future.wait takes list of Futures, executes in parallel and returns single Future w/ a List of responses vs doing await on each
    // call one at a time sequentially.  Much more performant.
    // All endpoints data I make here can be represented as Map<Endpoint, int>
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    },);
  }
}
