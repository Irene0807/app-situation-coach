import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../states/user_notifier.dart';
import 'package:marquee/marquee.dart';

// 文字還沒照新的方法寫
class PageAuthentication extends StatefulWidget {
  const PageAuthentication({super.key});

  @override
  State<PageAuthentication> createState() => _PageAuthenticationState();
}

class _PageAuthenticationState extends State<PageAuthentication>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  String _account = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      if (_tabController.index == 0) {
        // Log in
        await userNotifier.login(_account, _password);
        if (mounted) context.go('/home');
      } else {
        // Sign up
        await userNotifier.signUp(_account, _password);
        if (mounted) context.go('/auth/create_account');
      }
    } catch (e) {
      debugPrint("Auth error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication failed: $e")),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          //背景
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/journey_start_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 標題
          Align(
            alignment: const Alignment(0, -0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 底線
                    Positioned(
                      bottom: -20,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 23,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    // 字
                    Text(
                      "Situation Coach",
                      style: TextStyle(
                        fontSize: screenWidth * 0.105,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 172, 236, 255), // 淺藍
                              const Color.fromARGB(255, 230, 207, 255), // 淺紫
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(
                            Rect.fromLTWH(0, 0, screenWidth, screenWidth * 0.1),
                          ),
                        shadows: [
                          Shadow(
                            color: const Color.fromARGB(255, 70, 90, 129)
                                .withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.06),
                SizedBox(
                  height: screenWidth * 0.08,
                  width: screenWidth * 0.7,
                  child: Marquee(
                    text: "Welcome to our world!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontStyle: FontStyle.italic,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            const Color(0xFF9EE9FF), // 淺藍
                            const Color(0xFFD8B4FE), // 淺紫
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, screenWidth, screenWidth * 0.1),
                        ),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        )
                      ],
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 50.0, // 文字間隔
                    velocity: 70.0, // 跑馬燈速度
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    decelerationDuration: const Duration(milliseconds: 500),
                  ),
                ),
              ],
            ),
          ),

          // 中央框
          Align(
            alignment: const Alignment(0, 0.3),
            child: Container(
              width: screenWidth * 0.85,
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.6,
              ),
              margin: EdgeInsets.all(screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.92),
                    const Color(0xFFEAF6FF).withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  width: 2,
                  color: Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8AB6FF).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TabBar
                  TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: const Color(0xFF5970AF),
                      ),
                      insets: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    labelColor: const Color(0xFF2C3E50),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Log in"),
                      Tab(text: "Sign up"),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // 表單
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const ValueKey('account'),
                          decoration: InputDecoration(
                            labelText: 'account',
                            labelStyle: TextStyle(
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Account must be at least 6 characters';
                            }
                            final reg = RegExp(r'^[a-zA-Z0-9]+$');
                            if (!reg.hasMatch(value)) {
                              return 'Account can only contain letters and numbers';
                            }
                            return null;
                          },
                          onSaved: (value) => _account = value!,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        TextFormField(
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor: const Color(0xFF9EE9FF),
                                foregroundColor: Colors.white,
                                shadowColor:
                                    const Color(0xFF9EE9FF).withOpacity(0.5),
                                elevation: 6,
                              ),
                              onPressed: _submit,
                              child: Text(
                                _tabController.index == 0
                                    ? "Log in"
                                    : "Sign up",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
