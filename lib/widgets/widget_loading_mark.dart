import 'package:flutter/material.dart';

// 跑 loading 時會顯示這個通用的 loading mark widget

// 之後要認真設計這邊

class WidgetLoadingMark extends StatelessWidget {
  const WidgetLoadingMark();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
