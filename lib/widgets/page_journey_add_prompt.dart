import 'package:app_situational_coach/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widget_letter.dart';
import 'animations/letter_animation.dart';

// lets go 的 button如果連續點擊會有bug 之後再說吧

class PageJourneyAddPrompt extends StatelessWidget {
  PageJourneyAddPrompt({super.key, required this.onLetsGo});

  final void Function(String) onLetsGo;

  // controller放在這 否則放在build裡重建widget時已經輸入的內容會消失
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.transparent, // 讓 Scaffold 透明
      body: Stack(
        children: [
          // background
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/add_background.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // text field for journey description
          Positioned(
            left: 16,
            right: 16,
            top: 80,
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.describe_your_journey_here,
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              cursorColor: Colors.white,
              maxLines: 22,
            ),
          ),

          //letter for the traveler
          LetterAnimation(
            isKeyboard: isKeyboardVisible,
            child: WidgetLetter(),
          ),

          //let's go button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, isKeyboardVisible ? 8 : 73),
              child: ElevatedButton(
                onPressed: () {
                  onLetsGo(controller.text); // 傳入 TextField 內容
                  // 點下這個button後需要進入loading狀態 之後再處理
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C54),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(
                      color: Color(0xFFB5B5B5),
                      width: 2,
                    ),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  AppLocalizations.of(context)!.lets_go,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEAEAEA),
                    letterSpacing: 0.8,
                    shadows: const [
                      Shadow(
                        blurRadius: 6,
                        offset: Offset(1, 1),
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //go back button
          Positioned(
            bottom: 70,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
