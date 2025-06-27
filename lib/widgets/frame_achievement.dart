import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lab08_example/widgets/page_achievement.dart';
import 'package:lab08_example/widgets/page_evaluation.dart';
import 'package:lab08_example/widgets/page_list.dart';

enum FrameInformTab {
  //由最左頁至最右頁
  achievement,
  evaluation,
  list,
}

class FrameAchievement extends StatelessWidget {
  const FrameAchievement({super.key, required this.selectedTab});

  //目前預設進來就在achievement頁面 沒有記憶問題
  final FrameInformTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const PageAchievement(),
      const PageEvaluation(),
      const PageList(),
    ];

    return Scaffold(
      appBar: AppBar(title: (){
        switch (selectedTab) {
          case FrameInformTab.achievement:
            return const Text('Achievement');
          case FrameInformTab.evaluation:
            return const Text('Evaluation');
          case FrameInformTab.list:
            return const Text('List');
        }
      }()),
      body: Column(
        children: [
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Text('這是一個可以左右滑動的頁面 之後上面做一個bar支援直接用點的換頁(做在information_frame上)'),
          )),
          const Center(
              child: Text('目前的滑動有bug 由於page沒有先建好 滑過去會卡一下才出現')),
          Flexible (
            child: PageView(
              controller: PageController(initialPage: selectedTab.index),
              onPageChanged: (index) {
                switch (index) {
                  case 0:
                    context.go('/f-achievement');
                    break;
                  case 1:
                    context.go('/f-evaluation');
                    break;
                  case 2:
                    context.go('/f-list');
                    break;
                }
              },
              children: pages,
            ),
          ),
        ],
      ),
    );
  }
}
