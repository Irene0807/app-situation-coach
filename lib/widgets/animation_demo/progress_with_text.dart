import 'package:flutter/material.dart';

class ProgressWithText extends StatelessWidget {
  const ProgressWithText({
    super.key,
    required double progress,
  }) : _progress = progress;

  final double _progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          width: 240,
          height: 240,
          child: CircularProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[300],
          ),
        ),
        Text(
          '${(_progress * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.headlineLarge!,
        )
      ],
    );
  }
}
