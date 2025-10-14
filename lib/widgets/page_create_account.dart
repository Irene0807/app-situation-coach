import 'package:app_situational_coach/models/account_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../states/user_notifier.dart';
import 'animations/character_animation.dart';

// exam score的輸入方式要改 最好是表格 哪個項目有分數就填 沒分數就留白

// 看step1要不要加name這項 database我先開了
// 我現在是預設他們登入時的帳號名 = account = userID = google表單會填的東西 需要的話再改

// 文字還沒照新的方法寫

class PageCreateAccount extends StatefulWidget {
  const PageCreateAccount({super.key});

  @override
  State<PageCreateAccount> createState() => _PageCreateAccountState();
}

class _PageCreateAccountState extends State<PageCreateAccount> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  AccountData accountData = AccountData(
    age: -1,
    englishLevel: EnglishLevel.beginner,
    examScore: ExamScore(),
    dailyStudyTime: DailyStudyTime.lessThan30Min,
    studyPlace: StudyPlace.school,
    englishAppExperience: false,
    appFeedback: '',
  );

  bool _agreeRules = false;

  void _nextPage() {
    if (_currentIndex < 3) {
      // 繼續下一頁
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 最後一頁 => UserNotifier 改成已註冊，開始主畫面
      final user = Provider.of<UserNotifier>(context, listen: false);
      user.submitAccountData(accountData);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // 標題
      appBar: AppBar(
        backgroundColor: const Color(0xFF5970AF),
        title:
            const Text('Create Account', style: TextStyle(color: Colors.white)),
      ),

      body: Stack(
        children: [
          // 星空背景
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/journey_start_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 內容
          Column(
            children: [
              _buildProgressBar(), //進度條
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  children: [
                    _buildInfo1(),
                    _buildInfo2(),
                    _buildTutorial3(),
                    _buildTutorial4(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Bottom 按鈕
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                _buildButton(
                  text: "Back",
                  onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              const Spacer(),
              _buildButton(
                text: _currentIndex < 3 ? "Next" : "Start",
                onPressed:
                    (_currentIndex == 2 && !_agreeRules) ? null : _nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

// button (next/back)
  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xFF9EE9FF), Color(0xFFD8B4FE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // 進度條
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final progress = (_currentIndex + 1) / 3;
              final barWidth = constraints.maxWidth;

              return Stack(
                children: [
                  Container(
                    //沒跑過的 灰色
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  AnimatedContainer(
                    //跑過的 藍紫漸層
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: 20,
                    width: barWidth * progress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9EE9FF),
                          Color(0xFFD8B4FE),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          if (_currentIndex < 3)
            Text(
              "Step ${_currentIndex + 1} of 3",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required Widget child,
  }) {
    return Stack(
      children: [
        // 星空背景
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/journey_start_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 中央漂浮框
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // step 1 - Personal Info
  Widget _buildInfo1() {
    return _buildPage(
      title: "Step 1: Personal Info",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
            onChanged: (val) => accountData.age = int.tryParse(val) ?? 0,
          ),
          const SizedBox(height: 16),
          const Text(
            "English Level (leave blank if not applicable):",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: Colors.grey.shade400),
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(3),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildExamRow("TOEIC (0–990)", accountData.examScore.toeic,
                  (val) {
                accountData.examScore.toeic =
                    val.isEmpty ? -1 : int.tryParse(val) ?? -1;
              }),
              _buildExamRow("TOEFL iBT (0–120)", accountData.examScore.toefl,
                  (val) {
                accountData.examScore.toefl =
                    val.isEmpty ? -1 : int.tryParse(val) ?? -1;
              }),
              _buildExamRow("IELTS (0–9)", accountData.examScore.ielts, (val) {
                accountData.examScore.ielts =
                    val.isEmpty ? -1 : int.tryParse(val) ?? -1;
              }),

              // GEPT 改成 Dropdown
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("GEPT", style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButtonFormField<int>(
                      value: accountData.examScore.gept,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(value: -1, child: Text("None")), // 無
                        DropdownMenuItem(value: 1, child: Text("初級")),
                        DropdownMenuItem(value: 2, child: Text("中級")),
                        DropdownMenuItem(value: 3, child: Text("中高級")),
                        DropdownMenuItem(value: 4, child: Text("高級")),
                      ],
                      onChanged: (val) {
                        setState(() {
                          accountData.examScore.gept = val ?? -1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildExamRow(
    String examName,
    int currentValue,
    Function(String) onChanged,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(examName, style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            controller: TextEditingController(
              text: currentValue == -1 ? '' : currentValue.toString(),
            ),
            decoration: const InputDecoration(
              hintText: "Score",
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // step 2 - 英語Study Habits
  Widget _buildInfo2() {
    return _buildPage(
      title: "Step 2: Study Habits",
      child: Column(
        children: [
          DropdownButtonFormField(
            value: accountData.dailyStudyTime,
            decoration: const InputDecoration(labelText: "Daily Study Time"),
            items: DailyStudyTime.values.map((time) {
              return DropdownMenuItem(
                value: time,
                child: Text(() {
                  // 無名函式回傳顯示文字
                  switch (time) {
                    case DailyStudyTime.lessThan30Min:
                      return "0–30 min";
                    case DailyStudyTime.between30MinAnd1Hour:
                      return "30–60 min";
                    case DailyStudyTime.between1HourAnd3Hours:
                      return "1–3 hours";
                    case DailyStudyTime.moreThan3Hours:
                      return "3+ hours";
                  }
                }()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                accountData.dailyStudyTime = val; // 更新 enum 值
              }
            },
          ),
          DropdownButtonFormField(
            value: accountData.studyPlace,
            decoration: const InputDecoration(labelText: "Study Place"),
            items: StudyPlace.values.map((place) {
              return DropdownMenuItem(
                value: place,
                child: Text(() {
                  // 無名函式：根據 enum 決定顯示字串
                  switch (place) {
                    case StudyPlace.school:
                      return "School";
                    case StudyPlace.coffeeShop:
                      return "Coffee shop";
                    case StudyPlace.home:
                      return "Home";
                    case StudyPlace.online:
                      return "Online";
                  }
                }()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                accountData.studyPlace = val; // 更新 enum
              }
            },
          ),
          DropdownButtonFormField(
            value: accountData.englishAppExperience,
            decoration: const InputDecoration(labelText: "Used English Apps?"),
            items: const [
              DropdownMenuItem(value: true, child: Text("Yes")),
              DropdownMenuItem(value: false, child: Text("No")),
            ],
            onChanged: (val) {
              if (val != null) {
                accountData.englishAppExperience = val;
              }
            },
          ),
          TextField(
            decoration:
                const InputDecoration(labelText: 'Feedback about English Apps'),
            onChanged: (val) => accountData.appFeedback = val,
          ),
        ],
      ),
    );
  }

  // step 3 - tutorial：角色
  // Widget _buildTutorial1() {
  //   final characters = [
  //     "Trump",
  //     "Harry Potter",
  //     "English Girl",
  //     "American Boy",
  //     "Teacher",
  //   ];

  //   return _buildPage(
  //     title: "Step 3: Tutorial",
  //     child: Column(
  //       children: [
  //         const Text.rich(
  //           TextSpan(
  //             children: [
  //               TextSpan(
  //                 text: "You can choose ONE character\nin your journey.\nAnd ",
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               TextSpan(
  //                 text: "Tap",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               TextSpan(
  //                 text: " to see them wave!",
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //             ],
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 20),

  //         // 角色
  //         SizedBox(
  //           height: 200,
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: characters.map((name) {
  //                 return Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       SizedBox(
  //                         width: 120,
  //                         height: 120,
  //                         child: CharacterWidget(characterName: name),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         name,
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ),

  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             Icon(Icons.arrow_right_alt,
  //                 color: Color.fromARGB(179, 0, 0, 0), size: 22),
  //             SizedBox(width: 8),
  //             Text(
  //               "Swipe to see more characters",
  //               style: TextStyle(
  //                 color: Color.fromARGB(179, 0, 0, 0),
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // step 4 - tutorial：主題
  // Widget _buildTutorial2() {
  //   final roles = ["Teacher", "Trump", "Harry Potter"];
  //   final places = ["English classroom", "White House", "American landfill"];
  //   final topics = ["Food", "Food", "Food"];

  //   return _buildPage(
  //     title: "Step 4: Tutorial",
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         const Text(
  //           "You can create different\nlearning situations in your journey.\nHere are some examples:",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         const SizedBox(height: 16),

  //         // 三個類別
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildCategory("Role", roles),
  //             _buildCategory("Place", places),
  //             _buildCategory("Topic", topics),
  //           ],
  //         ),

  //         const SizedBox(height: 24),

  //         // 提示語
  //         const Text(
  //           "Try different combinations!\nSome feel normal, some feel surprising.",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.black54,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // 小分類
  // Widget _buildCategory(String title, List<String> options) {
  //   const double cardWidth = 80;
  //   const double cardHeight = 50;

  //   return Expanded(
  //     child: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 14,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         GridView.count(
  //           crossAxisCount: 1,
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           childAspectRatio: cardWidth / cardHeight,
  //           mainAxisSpacing: 10, // 上下間距
  //           crossAxisSpacing: 10, // 左右間距
  //           children: options.map((opt) {
  //             return Container(
  //               width: cardWidth,
  //               height: cardHeight,
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.9),
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(color: Colors.grey.shade300),
  //               ),
  //               child: Text(
  //                 opt,
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // step 5 - tutorial：提醒事項
  Widget _buildTutorial3() {
    return _buildPage(
      title: "Step 3: Tutorial",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "\nReminder:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "• Only speak in English.\n"
              "• Try to speak in \"full\" sentences.\n"
              "• Don’t worry about mistakes.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _agreeRules,
              onChanged: (val) => setState(() => _agreeRules = val ?? false),
              activeColor: const Color(0xFF5970AF),
              title: const Text(
                "I understand the rules",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // step final - tutorial：開始旅程
  Widget _buildTutorial4() {
    return _buildPage(
      title: "All Set!",
      child: Column(
        children: const [
          Icon(Icons.check_circle, color: Color(0xFF5970AF), size: 64),
          SizedBox(height: 20),
          Text(
            "You’ve completed your registration!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Welcome to Language Planet.\n"
            "From now on, \nyou can explore journeys,\n"
            "and practice freely.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 24),
          Text(
            "Tip: The more you interact,\n"
            "the faster your English improves!!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
