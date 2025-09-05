import 'package:app_situational_coach/states/journey_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/scene.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// 看有沒有辦法讓川普動起來? 或是在換頁時動個手之類?

class PageSceneIntro extends StatefulWidget {
  final IntroContent introContent;

  const PageSceneIntro({required this.introContent, super.key});

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
      if (_currentIndex == _pages.length - 2) {
        Provider.of<JourneyStatusNotifier>(context, listen: false).setIsPass();
      }
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          // 黑板 + 川普
          alignment: Alignment.center,
          children: [
            // title
            Transform.translate(
                offset: Offset(0, -360),
                child: Text(
                  'Mini Classroom',
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
                )),
            // 黑板
            Transform.translate(
              offset: Offset(0, -32),
              child: SizedBox(
                width: 400,
                height: 600,
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
                        itemCount: _pages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });

                          // 若換到最後一頁 設定該頁為已完成
                          if (_currentIndex == _pages.length - 1) {
                            Provider.of<JourneyStatusNotifier>(context,
                                    listen: false)
                                .setIsPass();
                          }
                        },
                        itemBuilder: (context, index) {
                          final isDescription = index == 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 96),
                            child: Align(
                              alignment: isDescription
                                  ? Alignment.topLeft
                                  : Alignment.center,
                              child: Text(
                                _pages[index],
                                textAlign: isDescription
                                    ? TextAlign.left
                                    : TextAlign.center,
                                style: GoogleFonts.caveat(
                                  fontSize: isDescription ? 24 : 64,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 48, 0, 0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: _currentIndex > 0 ? _previousPage : null,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 48, 32, 0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          color: Colors.white,
                          onPressed: _currentIndex < _pages.length - 1
                              ? _nextPage
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(64, 256),
              child: SizedBox(
                height: 400,
                child: Image.asset(
                  'assets/images/ai_trump.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
