import 'package:coronavirus/app/repositories/data_repository.dart';
import 'package:coronavirus/app/services/api.dart';
import 'package:coronavirus/app/services/api_service.dart';
import 'package:coronavirus/app/ui/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Coronavirus Tracker',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF101010),
            cardColor: Color(0xFF222222),
          ),
          home: Dashboard(),
        ),
    );
  }
}