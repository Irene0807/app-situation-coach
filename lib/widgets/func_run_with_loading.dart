import 'package:flutter/material.dart';

// 跑 loading 時會顯示這個通用的載入畫面

// 之後要認真設計這個 loading mark widget

/*
使用方式:
  await runWithLoading(context, () async {
    await function(a, b, c);
  });
*/

/// 執行一段 async function，期間顯示 loading 畫面
Future<T> runWithLoading<T>(
  BuildContext context,
  Future<T> Function() asyncFunction, {
  Widget? loadingWidget,
}) async {
  // 顯示 loading 畫面
  showDialog(
    context: context,
    barrierDismissible: false, // 禁止點擊背景關閉
    builder: (_) => loadingWidget ?? const WidgetLoadingMark(),
  );

  try {
    // 執行傳入的 async function
    return await asyncFunction();
  } finally {
    // 關閉 loading 畫面
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class WidgetLoadingMark extends StatelessWidget {
  const WidgetLoadingMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
