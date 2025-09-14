import 'package:app_situational_coach/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app_situational_coach/models/character.dart';
import 'package:app_situational_coach/data/dummy_data.dart';
import 'animations/twinkling_widget.dart';
import 'animations/character_animation.dart';
import 'dart:math';

class PageCharacter extends StatefulWidget {
  const PageCharacter({super.key});

  @override
  State<PageCharacter> createState() => _PageCharacterState();
}

class _PageCharacterState extends State<PageCharacter> {
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var char in characters) {
      precacheImage(AssetImage(char.imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/add_background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), // 透明度
                  BlendMode.multiply,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 85),

                // 2. Title
                Text(
                  AppLocalizations.of(context)!.your_travel_companion,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 0),

                // 3. Character Card
                Expanded(
                  child: PageView.builder(
                    itemCount: characters.length,
                    controller: PageController(viewportFraction: 0.8),
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      final isCurrent = index == currentIndex;
                      return CharacterCard(
                          character: character, highlight: isCurrent);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!
                          .tap_the_card_to_view_the_back,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),

          // 4. Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black87, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------

class CharacterCard extends StatefulWidget {
  final Character character;
  final bool highlight;

  const CharacterCard(
      {super.key, required this.character, required this.highlight});

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  bool isFlipped = false;

  @override
  void didUpdateWidget(covariant CharacterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlight && !widget.highlight && isFlipped) {
      setState(() => isFlipped = false); // 非選定 & 在反面 -> 自動翻回正面
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.8;
    final cardHeight = cardWidth * 1.7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedScale(
        scale: widget.highlight ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () {
            setState(() => isFlipped = !isFlipped);
          },
          child: TwinklingWidget(
            enableGlow: widget.highlight,
            enableSwing: false,
            glowWidth: cardWidth * 0.8,
            glowHeight: cardHeight * 0.8,
            glowMaxOpacity: 0.01,
            glowBlurRadius: 50,
            child: Opacity(
              opacity: widget.highlight ? 1.0 : 0.5,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                    animation: rotate,
                    child: child,
                    builder: (context, child) {
                      final isUnder = (ValueKey(isFlipped) != child!.key);
                      final tilt = (isUnder ? pi : 0.0) + rotate.value;
                      return Transform(
                        transform: Matrix4.rotationY(tilt),
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                child: isFlipped
                    ? _buildBack(cardHeight)
                    : _buildFront(cardHeight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFront(double cardHeight) {
    final character = widget.character;
    return Container(
      key: const ValueKey(false),
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 245),
        borderRadius: BorderRadius.circular(24),
        border: widget.highlight
            ? Border.all(
                color: const Color.fromARGB(255, 162, 136, 205), width: 3)
            : null,
        boxShadow: widget.highlight
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 109, 85, 170).withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: cardHeight * 0.40,
            child: CharacterWidget(
              characterName: character.name.of(context),
              changeHand: widget.highlight,
            ),
          ),
          const SizedBox(height: 12),
          Text(character.name.of(context),
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
              '${character.gender.of(context)} / ${character.age} ${AppLocalizations.of(context)!.years_old}',
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildBack(double cardHeight) {
    final character = widget.character;
    return Container(
      key: const ValueKey(true),
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(24),
        border: widget.highlight
            ? Border.all(
                color: const Color.fromARGB(255, 162, 136, 205), width: 3)
            : null,
        boxShadow: widget.highlight
            ? [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 234, 226, 254).withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // 1. Character Name
          Center(
            child: Text(
              character.name.of(context),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 21, 64, 128),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 2. 背景介紹
          Text('${AppLocalizations.of(context)!.background}：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(character.background.of(context),
              style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 20),

          // 3. 個性特質
          Text('${AppLocalizations.of(context)!.personality_traits}：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(character.personality.of(context),
              style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 20),

          // 4. 語氣風格
          Text('${AppLocalizations.of(context)!.tone_and_style}：',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(character.tone.of(context),
              style: const TextStyle(fontSize: 15, height: 1.4)),
  
          // 5. Slogan
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 45.0, left: 12, right: 12),
                child: Text(
                  character.slogan,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: cardHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(221, 21, 64, 128),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
