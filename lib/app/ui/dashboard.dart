import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/ui/endpoint_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Coronavirus Tracker'),
        ),
        body: ListView(
          children: <Widget>[
            EndpointCard(
              endpoint: Endpoint.cases,
              value: 222,
            ),
          ],
        ));
  }
}
