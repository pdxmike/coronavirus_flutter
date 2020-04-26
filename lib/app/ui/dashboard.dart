import 'package:coronavirus/app/repositories/data_repository.dart';
import 'package:coronavirus/app/repositories/enpoints_data.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/ui/endpoint_card.dart';
import 'package:coronavirus/app/ui/last_updated_status_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final cases = await dataRepository.getAllEndpointsData();
    setState(() => _endpointsData = cases);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Coronavirus Tracker'),
        ),
        body: RefreshIndicator(
          onRefresh: _updateData,
          child: ListView(
            children: <Widget>[
              LastUpdatedStatusText(
                text: _endpointsData != null
                    ? _endpointsData.values[Endpoint.cases].date?.toString() ??
                        ''
                    : '',
              ),
              for (var endpoint in Endpoint.values)
                EndpointCard(
                  endpoint: endpoint,
                  value: _endpointsData != null
                      ? _endpointsData.values[endpoint].value
                      : null,
                ),
            ],
          ),
        ));
  }
}
