import 'package:flutter/material.dart';

class PageDayCover extends StatelessWidget {
  final List<String> dayTitles;
  const PageDayCover({super.key, required this.dayTitles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('PageDayCover')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...dayTitles.map((title) => Text(title))
          ],
        ));
  }
}
