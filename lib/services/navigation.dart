import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/frame_growth_record.dart';
import '../widgets/page_home.dart';
import '../widgets/page_journey_add.dart';
import '../widgets/page_journey_continue.dart';
import '../widgets/page_journey_detail.dart';
import '../widgets/page_character.dart';
import '../widgets/page_setting.dart';
import '../widgets/page_journey_start.dart';

//測試router可以用chrome而不是用android模擬器來debug 這樣可以看到當下的path 顯示在網址

final routerConfig = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const Pagehome(),
        routes: [
          GoRoute(
              path: 'journey',
              builder: (context, state) => const PageJourneyStart(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const PageJourneyAdd(),
                ),
                GoRoute(
                    //我暫時沒找到如何避免每一層都要取id的做法
                    path: ':journeyId',
                    builder: (context, state) {
                      final id = state.pathParameters['journeyId']!;
                      return PageJourneyDetail(journeyId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'continue',
                        builder: (context, state) {
                          final id = state.pathParameters['journeyId']!;
                          return PageJourneyContinue(journeyId: id);
                        },
                      ),
                    ]),
              ]),
          GoRoute(
            path: 'character',
            builder: (context, state) => const PageCharacter(),
          ),
          // 點星星的話router應該會做在這一層 可以沿用journey的page
          // '/star' -> '/:journeyId' -> '/continue'
          //                          -> '/detail'
          GoRoute(
            path: 'setting',
            builder: (context, state) => const PageSetting(),
          ),
          // achievement evaluation list 會建立在 FrameGrowthRecord 這個frame上
          GoRoute(
            path: 'growth_record',
            builder: (context, state) =>
                const FrameGrowthRecord(selectedTab: FrameGrowthRecordTab.achievement),
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
