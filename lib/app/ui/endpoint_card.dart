import 'package:coronavirus/app/services/api.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Cases',
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              value != null ? value.toString() : '',
              style: Theme.of(context).textTheme.display1,
            )
          ],
        ),
      ),
    );
  }
}
