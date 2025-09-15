import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/journey.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/animations/character_animation.dart';

class PageSceneIntro extends StatefulWidget {
  final IntroContent introContent;
  final Journey journey;

  const PageSceneIntro(
      {required this.introContent, required this.journey, super.key});

  @override
  State<PageSceneIntro> createState() => _PageSceneIntroState();
}

class _PageSceneIntroState extends State<PageSceneIntro> {
  late final PageController _pageController;
  late final List<String> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      widget.introContent.description,
      ...widget.introContent.vocabulary
    ];
    _pageController = PageController();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

      // 若換到最後一頁 設定該頁為已完成
      // if (_currentIndex == _pages.length - 2) {
      //   Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
      // }
    }
  }

  // void _previousPage() {
  //   if (_currentIndex > 0) {
  //     _pageController.previousPage(
  //         duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          // 黑板 + 川普
          alignment: Alignment.center,
          children: [
            // title
            Transform.translate(
                offset: Offset(0, -screenHeight * 0.39),
                child: Text(
                  'Mini Classroom',
                  style: TextStyle(
                    // GoogleFonts.pacifico
                    fontSize: screenWidth * 0.08,
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
                )),
            // 黑板
            Transform.translate(
              offset: Offset(0, -32),
              child: SizedBox(
                width: screenWidth * 0.95,
                height: screenHeight * 0.7,
                child: Stack(
                  // 黑板內的細節操作
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/billboard.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.5),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final isDescription = index == 0;
                          final textWidget = Text(
                            _pages[index],
                            textAlign: isDescription
                                ? TextAlign.left
                                : TextAlign.center,
                            style: GoogleFonts.caveat(
                              fontSize: isDescription
                                  ? screenWidth * 0.07
                                  : screenWidth * 0.13,
                              fontWeight: isDescription
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                    color: Colors.black45)
                              ],
                            ),
                          );

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.12,
                              vertical: screenHeight * 0.12,
                            ),
                            child: Align(
                              alignment: isDescription
                                  ? Alignment.topLeft
                                  : Alignment.center,
                              child: isDescription
                                  ? SingleChildScrollView(
                                      child: textWidget,
                                    ) // ✅ 加了滾動
                                  : textWidget,
                            ),
                          );
                        },
                      ),
                    ),

                    // Intro 頁：右上角「下一頁」按鈕
                    if (_currentIndex == 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenHeight * 0.05, screenWidth * 0.08, 0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: _nextPage,
                          ),
                        ),
                      ),

                    // Vocabulary 頁：O / X 按鈕
                    if (_currentIndex > 0)
                      Positioned(
                        bottom: screenHeight * 0.18,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_currentIndex == _pages.length - 1)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 100.0),
                                child: Text(
                                  "Let's start!\nGo on to the next page!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        offset: Offset(1, 1),
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildChoiceButton("O", Colors.green),
                                const SizedBox(width: 24),
                                _buildChoiceButton("X", Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.03, 
                  screenWidth * 0.03, 
                  screenWidth * 0.03, 
                  screenHeight * 0.05,),
                child: SizedBox(
                  height: screenHeight * 0.3,
                  child: CharacterWidget(
                    characterName: widget.journey.character,
                    changeHand: true,
                    loopHandWave: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (label == "O") {
          Provider.of<JourneyStatusNotifier>(context, listen: false)
              .appendResponses(true);
        } else {
          Provider.of<JourneyStatusNotifier>(context, listen: false)
              .appendResponses(false);
        }
        if (_currentIndex == _pages.length - 1) {
          Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
        } else {
          _nextPage();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
