import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../states/user_notifier.dart';
import 'animations/character_animation.dart';

// exam score的輸入方式要改 最好是表格 哪個項目有分數就填 沒分數就留白
// pretest的部分沒有推上database

// 文字還沒照新的方法寫

class PageCreateAccount extends StatefulWidget {
  const PageCreateAccount({super.key});

  @override
  State<PageCreateAccount> createState() => _PageCreateAccountState();
}

class _PageCreateAccountState extends State<PageCreateAccount> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  String _age = '';
  String _level = 'Beginner';
  String _exam = 'None';
  String _studyTime = '0–30 min';
  String _studyPlace = 'School';
  String _usedApp = 'No';
  String _appFeedback = '';
  bool _agreeRules = false;

  void _nextPage() {
    if (_currentIndex < 8) {
      // 繼續下一頁
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 最後一頁 => UserNotifier 改成已註冊，開始主畫面
      final user = Provider.of<UserNotifier>(context, listen: false);
      // user.completeProfile();
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _buildPretest1(),
                    _buildPretest2(),
                    _buildPretest3(),
                    _buildTutorial1(),
                    _buildTutorial2(),
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
                text: _currentIndex < 8 ? "Next" : "Start",
                onPressed:
                    (_currentIndex == 7 && !_agreeRules) ? null : _nextPage,
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
              final progress = (_currentIndex + 1) / 8;
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
          if (_currentIndex < 8)
            Text(
              "Step ${_currentIndex + 1} of 8",
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
      ],
    );
  }

  // step 1 - Personal Info
  Widget _buildInfo1() {
    return _buildPage(
      title: "Step 1: Personal Info",
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Age'),
            onChanged: (val) => _age = val,
          ),
          DropdownButtonFormField(
            value: _level,
            decoration: const InputDecoration(labelText: "English Level"),
            items: const [
              DropdownMenuItem(value: 'Beginner', child: Text("Beginner")),
              DropdownMenuItem(
                  value: 'Intermediate', child: Text("Intermediate")),
              DropdownMenuItem(value: 'Advanced', child: Text("Advanced")),
            ],
            onChanged: (val) => _level = val!,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField(
                  value: _exam,
                  decoration: const InputDecoration(labelText: "Exam"),
                  items: const [
                    DropdownMenuItem(value: 'TOEIC', child: Text("TOEIC")),
                    DropdownMenuItem(value: 'TOEFL', child: Text("TOEFL")),
                    DropdownMenuItem(value: 'IELTS', child: Text("IELTS")),
                    DropdownMenuItem(value: 'GEPT', child: Text("GEPT")),
                    DropdownMenuItem(value: 'None', child: Text("None")),
                  ],
                  onChanged: (val) => setState(() => _exam = val!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Score"),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    // 這裡可以用一個變數 _examScore 儲存
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // step 1 - 英語Study Habits
  Widget _buildInfo2() {
    return _buildPage(
      title: "Step 1: Study Habits",
      child: Column(
        children: [
          DropdownButtonFormField(
            value: _studyTime,
            decoration: const InputDecoration(labelText: "Daily Study Time"),
            items: const [
              DropdownMenuItem(value: '0–30 min', child: Text("0–30 min")),
              DropdownMenuItem(value: '30–60 min', child: Text("30–60 min")),
              DropdownMenuItem(value: '1–3 hours', child: Text("1–3 hours")),
              DropdownMenuItem(value: '3+ hours', child: Text("3+ hours")),
            ],
            onChanged: (val) => _studyTime = val!,
          ),
          DropdownButtonFormField(
            value: _studyPlace,
            decoration: const InputDecoration(labelText: "Study Place"),
            items: const [
              DropdownMenuItem(value: 'School', child: Text("School")),
              DropdownMenuItem(
                  value: 'Coffee shop', child: Text("Coffee shop")),
              DropdownMenuItem(value: 'Home', child: Text("Home")),
              DropdownMenuItem(value: 'Online', child: Text("Online")),
            ],
            onChanged: (val) => _studyPlace = val!,
          ),
          DropdownButtonFormField(
            value: _usedApp,
            decoration: const InputDecoration(labelText: "Used English Apps?"),
            items: const [
              DropdownMenuItem(value: 'Yes', child: Text("Yes")),
              DropdownMenuItem(value: 'No', child: Text("No")),
            ],
            onChanged: (val) => _usedApp = val!,
          ),
          TextField(
            decoration:
                const InputDecoration(labelText: 'Feedback about English Apps'),
            onChanged: (val) => _appFeedback = val,
          ),
        ],
      ),
    );
  }

  // step 2 - 前測 Q1（範例）
  Widget _buildPretest1() {
    return _buildConversationPage(
      botText: "Q1: What do you usually do on weekends?",
      exampleAnswer:
          "A1 (Example): I usually play basketball with my friends. We had a lot of fun and I really enjoy it.",
      showInput: false,
    );
  }

  // step 2 - 前測 Q2
  Widget _buildPretest2() {
    return _buildConversationPage(
      botText: "Q2: We are in a coffee shop. How would you order your meal?",
      showInput: true,
    );
  }

  // step 2-3 - 前測 Q3
  Widget _buildPretest3() {
    return _buildConversationPage(
      botText: "Q3: Tell me about your favorite subject at school.",
      showInput: true,
    );
  }

  Widget _buildConversationPage({
    required String botText,
    String? exampleAnswer,
    bool showInput = false,
  }) {
    return Stack(
      children: [
        // 星空背景 + 浮動方塊
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/journey_start_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 對話框
        Align(
          alignment: const Alignment(0.0, -0.47),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            margin: const EdgeInsets.only(bottom: 20),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 252, 250, 228).withOpacity(0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 242, 128),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 233, 203, 30).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(botText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                if (exampleAnswer != null) ...[
                  const SizedBox(height: 12),
                  Text(exampleAnswer,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54)),
                ],
              ],
            ),
          ),
        ),

        // 使用者輸入
        if (showInput)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write your answer here...",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // step 3 - tutorial：角色
  Widget _buildTutorial1() {
    final characters = [
      "Trump",
      "Harry Potter",
      "England Kid",
      "American Kid",
      "TOEFL Interviewer",
    ];

    return _buildPage(
      title: "Step 3: Tutorial",
      child: Column(
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Choose ONE character in a journey.\n And ",
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: "Tap",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " to see them wave!",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // 角色
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: characters.map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CharacterWidget(characterName: name),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_right_alt,
                  color: Color.fromARGB(179, 0, 0, 0), size: 22),
              SizedBox(width: 8),
              Text(
                "Swipe to see more characters",
                style: TextStyle(
                  color: Color.fromARGB(179, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // step 3 - tutorial：主題
  Widget _buildTutorial2() {
    final roles = ["Teacher", "Trump", "Harry Potter"];
    final places = ["English classroom", "White House", "American landfill"];
    final topics = ["English", "TOEFL", "Tariffs"];

    return _buildPage(
      title: "Step 3: Tutorial",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You can create different learning situations\nby combining:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          // 三個類別
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategory("Role", roles),
              _buildCategory("Place", places),
              _buildCategory("Topic", topics),
            ],
          ),

          const SizedBox(height: 24),

          // 提示語
          const Text(
            "Try different combinations!\nSome feel normal, some feel surprising.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

// 小分類
  Widget _buildCategory(String title, List<String> options) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...options.map((opt) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(opt, textAlign: TextAlign.center),
              )),
        ],
      ),
    );
  }

  // step 3 - tutorial：提醒事項
  Widget _buildTutorial3() {
    return _buildPage(
      title: "Step 3: Tutorial",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reminder:",
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
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // step 3 - tutorial：開始旅程
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
