import 'package:busy_status_bar/first_pair/page/first_pair_page.dart';
import 'package:busy_status_bar/navigation/route.dart';
import 'package:busy_status_bar/tos/page/tos_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../main/main_screen.dart';

GoRouter navigationFlow(String startRoute) {
  return GoRouter(
    initialLocation: startRoute,
    routes: <GoRoute>[
      GoRoute(
        path: NavigationRoute.firstPairScreen,
        builder: (BuildContext context, GoRouterState state) =>
            const FirstPairPage(),
      ),
      GoRoute(
        path: NavigationRoute.tosScreen,
        builder: (BuildContext context, GoRouterState state) => const TosPage(),
      ),
      GoRoute(
        path: NavigationRoute.mainScreen,
        builder: (BuildContext context, GoRouterState state) =>
            const MainPage(),
      ),
    ],
  );
}

String firstScreenRoute(bool isDeviceExist) {
  if (isDeviceExist) {
    return NavigationRoute.tosScreen;
  } else {
    return NavigationRoute.tosScreen;
  }
}
