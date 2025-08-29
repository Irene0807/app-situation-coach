import 'package:app_situational_coach/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/journey_list_notifier.dart';
import 'package:provider/provider.dart';
import 'animations/twinkling_widget.dart';
import 'animations/planet_staggered_animation.dart';
import '../models/journey.dart';
import '../widgets/widget_star_showDialog.dart';

class PageJourneyStart extends StatelessWidget {
  const PageJourneyStart({super.key});

  //之後做database後應該可以直接做 isCompleted = false 的查詢 本function即可刪除
  List<Journey> getCompletedJourneys(List<Journey> journeys) {
    return journeys.where((journey) => !journey.status.isCompleted()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final journeys =
        getCompletedJourneys(context.watch<JourneyListNotifier>().journeys);

    return Scaffold(
        body: Stack(children: [
      // background
      Positioned.fill(
        child: Image.asset(
          'assets/images/journey_start_background.jpg',
          fit: BoxFit.cover,
        ),
      ),

      // contents on background
      Positioned.fill(
        child: Column(
          children: [
            // title
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 70, 8, 8),
              child: Center(
                child: TwinklingWidget(
                  enableSwing: true,
                  enableGlow: true,
                  glowWidth: 330,
                  glowHeight: 10,
                  child: Text(
                    AppLocalizations.of(context)!.start_your_journey,
                    style: TextStyle(
                      // GoogleFonts.pacifico
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                            blurRadius: 6,
                            offset: Offset(1, 1),
                            color: Colors.black45)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 16,
              thickness: 2,
              indent: 32,
              endIndent: 32,
              color: Colors.white70,
            ),

            // contents
            Expanded(
              child: ListView(children: [
                SizedBox(
                  height: 470,
                  child: Stack(
                    children: [
                      // horizontal divider
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 321,
                              child: Divider(
                                thickness: 2,
                                color: Colors.white24,
                              ),
                            ),
                            SizedBox(height: 150),
                            SizedBox(
                              width: 321,
                              child: Divider(
                                thickness: 2,
                                color: Colors.white24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // vertical divider
                      Center(
                        child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: const VerticalDivider(
                            thickness: 2,
                            color: Colors.white24,
                          ),
                        ),
                      ),

                      // planets
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              6,
                              (index) => PlanetStaggeredAnimation(
                                  index: index,
                                  child: Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Builder(builder: (context) {
                                        if (index < journeys.length) {
                                          final journey = journeys[index];
                                          return GestureDetector(
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
                                              duration:
                                                  Duration(seconds: 8 + index),
                                              enableSwing: true,
                                              enableGlow: true,
                                              glowWidth: 75,
                                              glowHeight: 75,
                                              child: Image.asset(
                                                'assets/images/home_star_${index + 1}.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () =>
                                                context.go('/journey/add'),
                                            child: Image.asset(
                                              'assets/images/add_planet.png',
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                      }),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            // add journey button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC0C0C0), Color(0xFF808080)], // 銀白到灰金屬漸層
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF808080), // 外框灰色
                    width: 2,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 透明，顯示Container漸層
                    shadowColor: Colors.transparent, // 不要ElevatedButton自己的陰影
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide.none,
                    ),
                    elevation: 0,
                    foregroundColor: const Color(0xFF0D1B2A), // 太空藍
                  ),
                  onPressed: () => context.go('/journey/add'),
                  child: Text(
                    AppLocalizations.of(context)!.create_new_journey,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A), // 太空藍
                      letterSpacing: 0.5,
                      shadows: [
                        const Shadow(
                          blurRadius: 6,
                          offset: Offset(1, 1),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // go back button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B2B50), Color(0xFF233A6C)], // 深藍漸層
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF233A6C), // 外框深藍
                    width: 2,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 透明，顯示Container漸層
                    shadowColor: Colors.transparent, // 不要ElevatedButton自己的陰影
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide.none,
                    ),
                    elevation: 0,
                    foregroundColor: const Color(0xFFDDE2F0), // 銀灰白字
                  ),
                  onPressed: () => context.go('/'),
                  child: Text(
                    AppLocalizations.of(context)!.go_back,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFDDE2F0), // 銀灰白字
                      letterSpacing: 0.5,
                      shadows: [
                        const Shadow(
                          blurRadius: 6,
                          offset: Offset(1, 1),
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]));
  }
}
