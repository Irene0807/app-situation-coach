import 'package:flutter/material.dart';

class PageCharacter extends StatelessWidget {
  const PageCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('PageCharacter')),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Center(child: Text('看要做到多3D? 可能一樣做一個frame 然後可以用滑的看6個角色 每個角色的頁面可以放 性別 年齡 2.5D照片 之類的')),
          ),
        ],
      ),
    );
  }
}
