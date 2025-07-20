import 'package:app_situational_coach/state/journey_list_notifier.dart';
import 'package:app_situational_coach/state/journey_status_notifier.dart';
import 'package:app_situational_coach/widgets/frame_journey_add.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/frame_growth_record.dart';
import 'package:provider/provider.dart';
import '../widgets/page_home.dart';
import '../widgets/page_scene_conversation.dart';
import '../widgets/page_journey_detail.dart';
import '../widgets/page_character.dart';
import '../widgets/page_setting.dart';
import '../widgets/page_journey_start.dart';
import '../widgets/frame_journey_continue.dart';

// 讀journeyId的小bug 約45行左右 找不到原因 只能先把":"刪除再傳journeyId

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
                // 很有趣的bug 取journeyId出來時 會莫名其妙多一個":"
                // 舉例來說 定義的是journeyId="1" 傳到page裡面卻讀到":1"
                final id =
                    state.pathParameters['journeyId']!.replaceFirst(":", "");
                final journey =
                    Provider.of<JourneyListNotifier>(context, listen: false)
                        .getById(id);
                if (journey == null) {
                  throw Exception('journeyId doesn\'t match journey\n');
                }
                return ChangeNotifierProvider(
                  create: (_) => JourneyStatusNotifier(status: journey.status),
                  child: FrameJourneyContinue(journey: journey),
                );
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
          final id = state.pathParameters['journeyId']!.replaceFirst(":", "");
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
