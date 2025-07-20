import 'package:flutter/material.dart';
import '../widgets/widget_loading_mark.dart';

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
