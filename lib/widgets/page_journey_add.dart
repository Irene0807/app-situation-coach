import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widget_letter.dart';
import '../widgets/animations/letter_animation.dart';

class PageJourneyAdd extends StatelessWidget {
  const PageJourneyAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: Stack(
        children: [
          // background
          Positioned.fill(
            child: Image.asset(
              'assets/images/add_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // text field for journey description
          Positioned(
            left: 16,
            right: 16,
            top: 80,
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: 'describe your journey here',
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
              maxLines: 20,
            ),
          ),

          //letter for the traveler
          LetterAnimation(
            isKeyboard: isKeyboardVisible,
            child: WidgetLetter(),
          ),

          //start button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, isKeyboardVisible ? 8 : 80),
              child: ElevatedButton(
                onPressed: () => (), // 待處理功能
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B296B), // 深紫色
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(
                      color: Color(0xFFE2C799), // 金色邊框
                      width: 2,
                    ),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Let\'s Go!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE2C799), // 金色文字
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
            bottom: 40,
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
