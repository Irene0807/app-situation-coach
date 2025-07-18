import 'package:app_situational_coach/widgets/frame_journey_add.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/frame_growth_record.dart';
import '../widgets/page_home.dart';
import '../widgets/page_journey_add_prompt.dart';
import '../widgets/page_journey_continue.dart';
import '../widgets/page_journey_detail.dart';
import '../widgets/page_character.dart';
import '../widgets/page_setting.dart';
import '../widgets/page_journey_start.dart';

// 也不知道算不算bug 從home點星球進入旅行後 離開會跳到journey_start
// 有需要再調整 我個人認為沒毛病 都可? (調起來很快 有需要直接說
// I: 問題不大 要說就說他想退出的時候 跑到journey_start 促進他進下一段旅程

final routerConfig = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Pagehome(), routes: [
      GoRoute(
          path: 'journey',
          pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PageJourneyStart(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // 從右方
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: Curves.ease));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) =>
                  const FrameJourneyAdd(selectedTab: FrameJourneyAddTab.prompt),
            ),
            GoRoute(
              path: 'continue:journeyId',
              builder: (context, state) {
                final id = state.pathParameters['journeyId']!;
                return PageJourneyContinue(journeyId: id);
              },
            ),
          ]),
      GoRoute(
        path: 'character',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PageCharacter(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0); // 從左方
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.ease));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: 'detail:journeyId',
        builder: (context, state) {
          final id = state.pathParameters['journeyId']!;
          return PageJourneyDetail(journeyId: id);
        },
      ),
      GoRoute(
        path: 'setting',
        builder: (context, state) => const PageSetting(),
      ),
      GoRoute(
        path: 'growth_record',
        builder: (context, state) => const FrameGrowthRecord(
            selectedTab: FrameGrowthRecordTab.achievement),
      ),
    ]),
  ],
  initialLocation: '/',
  debugLogDiagnostics: true, // 幫助debug的東西
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);
