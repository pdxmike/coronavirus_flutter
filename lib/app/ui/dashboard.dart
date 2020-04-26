import 'package:coronavirus/app/repositories/data_repository.dart';
import 'package:coronavirus/app/repositories/enpoints_data.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/ui/endpoint_card.dart';
import 'package:coronavirus/app/ui/last_updated_status_text.dart';
import 'package:coronavirus/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData(); // get cached data before calling updateData
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final cases = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = cases);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrive data.\nPlease try again later.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
      lastUpdated: _endpointsData != null
          ? _endpointsData.values[Endpoint.cases]?.date
          : null,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Coronavirus Tracker'),
        ),
        body: RefreshIndicator(
          onRefresh: _updateData,
          child: ListView(
            children: <Widget>[
              LastUpdatedStatusText(
                text: formatter.lastUpdatedStatusText(),
              ),
              for (var endpoint in Endpoint.values)
                EndpointCard(
                  endpoint: endpoint,
                  value: _endpointsData != null
                      ? _endpointsData.values[endpoint]?.value
                      : null,
                ),
            ],
          ),
        ));
  }
}
