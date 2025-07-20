import 'package:flutter/material.dart';

class PageJourneyCover extends StatelessWidget {
  final String journeyName;
  final int journeyDay;
  const PageJourneyCover(
      {super.key, required this.journeyName, required this.journeyDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PageJourneyCover')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Journey Name: $journeyName'),
          Text('Journey Day Num: $journeyDay'),
        ],
      ),
    );
  }
}
