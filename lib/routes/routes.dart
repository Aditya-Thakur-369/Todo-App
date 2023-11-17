import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/routes/router_name.dart';
import 'package:todo/screens/forgetpassword_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/reset_password.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/screens/signup_screen.dart';

class AppRouter {
  GoRouter router = GoRouter( routes: [
    GoRoute(
      name: RouterName.home,
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(child: home_screen());
      },
    ),
    GoRoute(
      name: RouterName.signin,
      path: '/signin_screen',
      pageBuilder: (context, state) {
        return MaterialPage(child: signin_screen());
      },
    ),
    GoRoute(
      name: RouterName.signup,
      path: '/signup_screen',
      pageBuilder: (context, state) {
        return MaterialPage(child: signup_screen());
      },
    ),
    GoRoute(
      name: 'reset_password',
      path: '/reset_password_screen',
      pageBuilder: (context, state) {
        return MaterialPage(child: reset_password_screen());
      },
    ),
    GoRoute(
      name: 'forgetpassword_screen',
      path: '/forgetpassword_screen',
      pageBuilder: (context, state) {
        return MaterialPage(child: forgetpassword_screen());
      },
    ),
  ]);
}
