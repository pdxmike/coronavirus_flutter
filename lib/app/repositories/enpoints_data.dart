import 'package:coronavirus/app/services/api.dart';
import 'package:flutter/foundation.dart';

class EndpointsData {
  EndpointsData({ @required this.values });
  final Map<Endpoint, int> values;

}