import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/journey_list_notifier.dart';
import '../state/character_notifier.dart';
import '../models/journey.dart';
import 'animations/home_action_sign.dart';  
import 'animations/twinkling_star.dart';
import 'painters/home_ground.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class Pagehome extends StatelessWidget {
  const Pagehome({super.key});

  @override
  Widget build(BuildContext context) {
    final journeys = context.watch<JourneyListNotifier>().journeys;
    final character = context.watch<CharacterNotifier>().selectedCharacter;
    final scrollController = ScrollController();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Situation Coach'),
      //   actions: [
      //     IconButton(
      //       //icon要放什麼我也不知道 反正之後做成一顆星? 倒是取名要想一下 Info完全不行。。。
      //       //改名後 同時更改frame_achievement的檔名 + router 
      //       icon: const Icon(Icons.menu),
      //       onPressed: () => context.go('/f-achievement'),
      //       tooltip: 'Info',
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.settings),
      //       onPressed: () => context.go('/setting'),
      //       tooltip: 'Settings',
      //     ),
      //   ],
      // ),
      body: Stack(

        children: [

          // 1. background
          Positioned.fill(
            child: Image.asset('assets/images/home_background.jpg',fit: BoxFit.cover,),
          ),

          // 2. title
          Positioned(
            top: 72,
            left: 20,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: 28), // 小icon點綴
                const SizedBox(width: 8),
                const Text(
                  'Situation Coach',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(blurRadius: 6, offset: Offset(1, 1), color: Colors.black45,)
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: CustomPaint(painter: GroundPainter(),),
            ),
          ),

          // 4. person
          Align(
            alignment: const Alignment(0, 0.65),
            child: Image.asset('assets/images/home_person.png', height: 250,),
          ),
          
          // 5. 星星
          Positioned(
            top: 140,
            left: 20,
            right: 0,
            height: 500,
            child: NotificationListener<ScrollNotification>(
              onNotification: (_) => true,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: journeys.length * 140,
                  child: Stack(
                    children: journeys.asMap().entries.map((entry) {
                      final index = entry.key;
                      final journey = entry.value;
                      final random = Random(index);
                      final imageIdx = index % 5 + 1;

                      // 星星大小
                      final starSizes = [96.0, 108.0, 120.0];
                      final size = starSizes[random.nextInt(starSizes.length)];

                      // 星星位置
                      double baseTop = 100 + (index % 3) * 60 + random.nextDouble() * 20;
                      final baseLeft = index * 140 + random.nextDouble() * 5;

                      // 視差因子
                      final parallaxX = 1 - (baseTop / 400);
                      final parallaxY = (size - 84) / 24;

                      return AnimatedBuilder(
                        animation: scrollController,
                        builder: (context, child) {
                          final offset = scrollController.hasClients ? scrollController.offset : 0.0;

                          return Positioned(
                            top: baseTop,
                            left: baseLeft,
                            child: Transform.translate(
                              offset: Offset(-offset * parallaxX, offset * 0.04 * parallaxY),
                              child: Transform.rotate(
                                angle: sin(index * 1.4) * 0.2,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(

                                        title: Text('暫時隨便寫的而已 待改 \n 旅程：${journey.name}'),
                                        content: Text('角色：${journey.character}\n狀態：${journey.isCompleted ? "已完成" : "尚未完成"}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('關閉'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.go('/journey/${journey.id}');
                                            },
                                            child: const Text('進入旅程'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: TwinklingStar(
                                    child: Image.asset(
                                      'assets/images/home_star_$imageIdx.png', width: size, height: size,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // 6. character 按鈕
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.10,
            child: HomeActionSign(
              tiltLeft: true,
              content: Transform.translate(
                offset: const Offset(0, -6),
                child: Image.asset(
                  'assets/images/home_character_button_0.png',
                  width: 40,
                ),
              ),
              onTap: () {},
            ),
          ),

          // 7. start 按鈕
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            right: MediaQuery.of(context).size.width * 0.10,
            child: HomeActionSign(
              content: const SizedBox(
                height: 48,
                  child: Text(
                    'START',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
              ),
              onTap: () {},
            ),
          ),

          

          // 8. 其他文字
          Positioned.fill(
            child: Column(  

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                    padding: const EdgeInsets.all(150.0),
                    child: Text(
                      '星星的route我還沒做 可以直接把journey的頁面包成彈出視窗來用',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 9. achievement & setting 按鈕
          Positioned(
            top: 64,
            right: 20,
            child: Column(
              children: [
                // 成就按鈕
                FloatingActionButton(
                  heroTag: 'achievement',
                  onPressed: () => context.go('/f-achievement'),
                  backgroundColor: Colors.white,
                  elevation: 4,
                  child: Icon(Icons.emoji_events, color: const Color.fromARGB(255, 82, 189, 255), size: 26),
                ),
                const SizedBox(height: 16),
                // 設定按鈕
                FloatingActionButton(
                  heroTag: 'setting',
                  onPressed: () => context.go('/setting'),
                  backgroundColor: Colors.white,
                  elevation: 4,
                  child: Icon(Icons.settings, color: Colors.indigo, size: 26),
                ),
              ],
            ),
          ),

        ],    
      ),
    );
  }
}
