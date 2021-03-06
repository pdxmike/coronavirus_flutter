import 'package:coronavirus/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  EndpointCardData(this.title, this.assetName, this.color);
  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/suspect.png', Color(0xFFFFF492)),
    Endpoint.casesConfirmed: EndpointCardData(
        'Confirmed Cases', 'assets/fever.png', Color(0xFFE99600)),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', Color(0xFFE40000)),
    Endpoint.recovered:
        EndpointCardData('Recoveries', 'assets/patient.png', Color(0xFF70A901)),
  };

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // left align
            children: <Widget>[
              Text(
                cardData.title,
                style: Theme.of(context).textTheme.headline.copyWith(
                      color: cardData.color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 5), // slight space between header and icon
              SizedBox(
                // wrapping the row in this SizedBox let's me set a standard height since icons are different heights
                // Rows height are normally defined by the largest height object in the row
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      cardData.assetName,
                      color: cardData.color,
                    ),
                    Text(
                      formattedValue,
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: cardData.color,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
