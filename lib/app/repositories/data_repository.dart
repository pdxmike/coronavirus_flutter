import 'package:coronavirus/app/repositories/enpoints_data.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/services/api_service.dart';
import 'package:coronavirus/app/services/data_cache_service.dart';
import 'package:coronavirus/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({ @required this.apiService, @required this.dataCacheService });
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
    await _getDataRefreshingToken<EndpointData>(
      onGetData: () => apiService.getEndpointData(
          accessToken: _accessToken, endpoint: endpoint),
    );

  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointsData,
    );
    // save to cache
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    // throw 'error'; fake an error if testing errors
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      // if unauthorized, get generate new access token
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
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
    return EndpointsData(
      values: {
        Endpoint.cases: values[0],
        Endpoint.casesConfirmed: values[1],
        Endpoint.deaths: values[2],
        Endpoint.recovered: values[3],
      },
    );
  }
}
