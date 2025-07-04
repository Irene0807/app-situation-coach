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
            left: 32,
            right: 32,
            top: 80,
            child: TextField(
              style: TextStyle(color: Colors.white),
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
              maxLines: 30,
            ),
          ),

          //letter for the traveler
          LetterAnimation(
            isKeyboard: isKeyboardVisible,
            child: WidgetLetter(),
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
