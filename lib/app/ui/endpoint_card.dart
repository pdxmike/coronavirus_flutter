import 'package:coronavirus/app/services/api.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, String> _cardTitles = {
    Endpoint.cases: 'Cases',
    Endpoint.casesSuspected: 'Suspected Cases',
    Endpoint.casesConfirmed: 'Confirmed Cases',
    Endpoint.deaths: 'Deaths',
    Endpoint.recovered: 'Recoveries',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _cardTitles[endpoint],
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                value != null ? value.toString() : '',
                style: Theme.of(context).textTheme.display1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
