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

  late final int _qCount;
  late List<bool> _hasAnswered; // 每題是否已作答
  late List<int?> _selectedIndex; // 每題點了哪個選項

  @override
  void initState() {
    super.initState();
    _pages = [
      widget.introContent.description,
      ...widget.introContent.questions.map((q) => q.questionText),
    ];
    _qCount = widget.introContent.questions.length;
    _hasAnswered = List<bool>.filled(_qCount, false, growable: false);
    _selectedIndex = List<int?>.filled(_qCount, null, growable: false);
    _pageController = PageController();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

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
                  'Before our trip!',
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
                                  : screenWidth * 0,
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
                                    )
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

                    // Question 頁：選擇題按鈕
                    if (_currentIndex > 0)
                      Positioned(
                        bottom: screenHeight * 0.15,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: Builder(builder: (context) {
                          final questionIndex = _currentIndex - 1;
                          final question =
                              widget.introContent.questions[questionIndex];

                          Color getButtonColor(int i) {
                            if (!_hasAnswered[questionIndex])
                              return Colors.white.withOpacity(0.15);
                            if (i == question.answerId) {
                              if (_selectedIndex[questionIndex] ==
                                  question.answerId) {
                                return Colors.greenAccent.withOpacity(0.7);
                              } else {
                                return Colors.redAccent.withOpacity(0.7);
                              }
                            }
                            return Colors.white.withOpacity(0.06);
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 題目
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.03),
                                child: Text(
                                  question.questionText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.4,
                                    shadows: const [
                                      Shadow(
                                          blurRadius: 4,
                                          offset: Offset(1, 1),
                                          color: Colors.black45),
                                    ],
                                  ),
                                ),
                              ),

                              // 選項
                              ...List.generate(question.options.length, (i) {
                                final disabled = _hasAnswered[questionIndex];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.008),
                                  child: SizedBox(
                                    width: screenWidth * 0.75,
                                    height: screenHeight * 0.07,
                                    child: ElevatedButton(
                                      onPressed: disabled
                                          ? null
                                          : () async {
                                              final isCorrect =
                                                  (i == question.answerId);

                                              setState(() {
                                                _hasAnswered[questionIndex] =
                                                    true;
                                                _selectedIndex[questionIndex] =
                                                    i;
                                              });

                                              // 紀錄作答正誤
                                              Provider.of<JourneyStatusNotifier>(
                                                      context,
                                                      listen: false)
                                                  .appendResponses(
                                                      isCorrect);

                                              final isLastQuestion =
                                                  questionIndex == _qCount - 1;

                                              if (isLastQuestion) {
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200));
                                                Provider.of<JourneyStatusNotifier>(
                                                        context,
                                                        listen: false)
                                                    .setIsPass();
                                              } else {
                                                await Future.delayed(
                                                    const Duration(seconds: 1));
                                                _nextPage();
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: getButtonColor(i),
                                        disabledBackgroundColor:
                                            getButtonColor(i),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          side: const BorderSide(
                                              color: Colors.white30),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.01,
                                          horizontal: screenWidth * 0.04,
                                        ),
                                      ),
                                      child: Text(
                                        question.options[i],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
            // 角色
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.03,
                  screenWidth * 0.03,
                  screenWidth * 0.03,
                  screenHeight * 0.05,
                ),
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
            // 左下角文字
            if (_currentIndex == _pages.length - 1 && _hasAnswered[_qCount - 1])
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.15,
                    bottom: screenHeight * 0.13,
                  ),
                  child: Text(
                    "Let's GO!",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
