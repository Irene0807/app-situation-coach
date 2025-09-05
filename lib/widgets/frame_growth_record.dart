import 'package:flutter/material.dart';
import 'page_achievement.dart';
import 'page_evaluation.dart';
import 'page_list.dart';

enum FrameGrowthRecordTab {
  //由最左頁至最右頁
  achievement,
  evaluation,
  list,
}

// 狀態會動 所以用StatefulWidget
class FrameGrowthRecord extends StatefulWidget {
  const FrameGrowthRecord({super.key, required this.selectedTab});

  final FrameGrowthRecordTab selectedTab;

  @override
  State<FrameGrowthRecord> createState() => _FrameGrowthRecordState();
}

class _FrameGrowthRecordState extends State<FrameGrowthRecord>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  late int _currentIndex; //現在頁數


  final List<Widget> pages = const [
    PageAchievement(),
    PageEvaluation(),
    PageList(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedTab.index;
    _pageController = PageController(initialPage: _currentIndex);
    _tabController = TabController(length: pages.length, vsync: this);
    _tabController.index = _currentIndex;
  }

// (1)點擊切換頁面
  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  // (2)滑動切換頁面
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _tabController.index = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 249, 253),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 118, 173, 240),
        title: Text("Growth Record", style: const TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          onTap: _onTabTapped,
          tabs: const [
            Tab(text: 'Achievement'),
            Tab(text: 'Evaluation'),
            Tab(text: 'List'),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages,
      ),
    );
  }
}

// class FrameAchievement extends StatelessWidget {
//   const FrameAchievement({super.key, required this.selectedTab});

//   //目前預設進來就在achievement頁面 沒有記憶問題
//   final FrameInformTab selectedTab;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       const PageAchievement(),
//       const PageEvaluation(),
//       const PageList(),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: (){
//         switch (selectedTab) {
//           case FrameInformTab.achievement:
//             return const Text('Achievement');
//           case FrameInformTab.evaluation:
//             return const Text('Evaluation');
//           case FrameInformTab.list:
//             return const Text('List');
//         }
//       }()),
//       body: Column(
//         children: [
//           const Center(
//               child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child:
//                 Text('這是一個可以左右滑動的頁面 之後上面做一個bar支援直接用點的換頁(做在information_frame上)'),
//           )),
//           const Center(
//               child: Text('目前的滑動有bug 由於page沒有先建好 滑過去會卡一下才出現')),
//           Flexible (
//             child: PageView(
//               controller: PageController(initialPage: selectedTab.index),
//               onPageChanged: (index) {
//                 switch (index) {
//                   case 0:
//                     context.go('/f-achievement');
//                     break;
//                   case 1:
//                     context.go('/f-evaluation');
//                     break;
//                   case 2:
//                     context.go('/f-list');
//                     break;
//                 }
//               },
//               children: pages,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
