import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetLetter extends StatelessWidget {
  const WidgetLetter({super.key});

  final String letterContent = '''
Dear Traveler,

    Imagine your ideal journey.
    Where would you go?
    How long would you stay?
    What would you experience?
    What’s the purpose of your adventure?

    Describe it freely.










                                              Your Best
''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 380,
        height: 570, // 如需調整 須一並調整letter animation 的 _letterHeight
        child: Stack(
          children: [
            //background letter paper
            Positioned.fill(
              left: 8,
              right: 8,
              top: 8,
              bottom: 8,
              child: Image.asset(
                'assets/images/letter_paper.png',
                fit: BoxFit.contain,
              ),
            ),

            //letter text
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                letterContent,
                style: GoogleFonts.mysteryQuest(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
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

            //letter badge
            Align(
              alignment: Alignment(0, 0.3),
              child: Image.asset(
                'assets/images/letter_badge.png',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ));
  }
}
