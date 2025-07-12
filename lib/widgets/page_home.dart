import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/journey_list_notifier.dart';
import '../state/character_notifier.dart';
import '../models/journey.dart';
import 'animations/home_action_sign.dart';
import 'animations/twinkling_widget.dart';
import 'painters/home_ground.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../widgets/widget_star_showDialog.dart';

class Pagehome extends StatelessWidget {
  const Pagehome({super.key});

  @override
  Widget build(BuildContext context) {
    final journeys = context.watch<JourneyListNotifier>().journeys;
    final character = context.watch<CharacterNotifier>().selectedCharacter;
    final scrollController = ScrollController();

    return Scaffold(
      body: Stack(
        children: [
          // 1. background
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. title
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amberAccent, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Situation Coach',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          offset: Offset(1, 1),
                          color: Colors.black45,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. ground
          Positioned(
            bottom: -3,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: CustomPaint(
                painter: GroundPainter(),
              ),
            ),
          ),

          // 4. person
          Align(
            alignment: const Alignment(0, 0.70),
            child: Image.asset(
              'assets/images/home_person.png',
              height: MediaQuery.of(context).size.height * 0.30,
            ),
          ),

          // 5. 星星
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 500,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (_) => true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: SizedBox(
                        width: journeys.length * 140,
                        child: Stack(
                          children: journeys.asMap().entries.map((entry) {
                            final index = entry.key;
                            final journey = entry.value;
                            final random = Random(index);
                            final imageIdx = index % 5 + 1;

                            // 星星大小
                            final starSizes = [84.0, 96.0, 108.0];
                            final size =
                                starSizes[random.nextInt(starSizes.length)];

                            // 星星位置
                            double baseTop = 100 +
                                (index % 3) * 60 +
                                random.nextDouble() * 20;
                            final baseLeft =
                                index * 140 + random.nextDouble() * 5;

                            // 視差因子
                            final parallaxX = 1 - (baseTop / 400);
                            final parallaxY = (size - 84) / 24;

                            return AnimatedBuilder(
                              animation: scrollController,
                              builder: (context, child) {
                                final offset = scrollController.hasClients
                                    ? scrollController.offset
                                    : 0.0;

                                return Positioned(
                                  top: baseTop,
                                  left: baseLeft,
                                  child: Transform.translate(
                                    offset: Offset(-offset * parallaxX,
                                        offset * 0.04 * parallaxY),
                                    child: Transform.rotate(
                                      angle: sin(index * 1.4) * 0.2,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                WidgetStarShowDialog(
                                              journey: journey,
                                            ),
                                          );
                                        },
                                        child: TwinklingWidget(
                                          enableSwing: true,
                                          enableGlow: true,
                                          verticalOffset: 5.0,
                                          glowSpreadRadius: 2.0,
                                          glowWidth: size - 15,
                                          glowHeight: size - 15,
                                          child: Image.asset(
                                            'assets/images/home_star_$imageIdx.png',
                                            width: size,
                                            height: size,
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
              ),
            ),
          ),

          // 6. character 按鈕
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 64),
              child: GestureDetector(
                onTap: () => context.go('/character'),
                child: HomeActionSign(
                  tiltLeft: true,
                  content: Transform.translate(
                    offset: const Offset(0, -6),
                    child: Image.asset(
                      'assets/images/home_character_button_0.png',
                      width: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 7. start 按鈕
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 32, bottom: 64),
              child: GestureDetector(
                onTap: () => context.go('/journey'),
                child: HomeActionSign(
                  content: const SizedBox(
                    height: 48,
                    child: Text(
                      'START',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 8. 其他文字
          // 我也還沒做 但先註解掉暫時避免出現在畫面上而已
          // Positioned.fill(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(150.0),
          //           child: Text(
          //             '星星的route我還沒做 可以直接把journey的頁面包成彈出視窗來用',
          //             style: const TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // 9. achievement & setting 按鈕
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // achievement 按鈕
                    FloatingActionButton(
                      heroTag: 'growth record',
                      onPressed: () => context.go('/growth_record'),
                      backgroundColor: Colors.white,
                      elevation: 4,
                      child: Icon(Icons.emoji_events,
                          color: Color(0xFF52BDFF), size: 26),
                    ),
                    const SizedBox(height: 16),
                    // setting 按鈕
                    FloatingActionButton(
                      heroTag: 'setting',
                      onPressed: () => context.go('/setting'),
                      backgroundColor: Colors.white,
                      elevation: 4,
                      child:
                          Icon(Icons.settings, color: Colors.indigo, size: 26),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
