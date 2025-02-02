import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swifty_companion/src/presentation/views/homepage_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:swifty_companion/src/presentation/views/login_view.dart';
import 'package:swifty_companion/src/presentation/views/student_view.dart';
part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {

    @override
    List<AutoRoute> get routes => [
        CustomRoute(page: HomepageRoute.page, transitionsBuilder: TransitionsBuilders.noTransition, barrierColor: Colors.transparent),
        AutoRoute(page: StudentRoute.page),
        AutoRoute(page: LoginRoute.page, initial: true),
    ];
}

final appRouter = AppRouter();