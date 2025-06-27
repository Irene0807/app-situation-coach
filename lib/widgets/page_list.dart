import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageList extends StatelessWidget {
  const PageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageList')),
          const Center(child: Text('這頁用list的方式呈現使用者的各個旅行 可以沿用journey的page')),
          const Center(child: Text('後來想想這頁應該可以不用 看還有什麼要顯示的資料可以放這頁')),
        ],
      ),
    );
  }
}
