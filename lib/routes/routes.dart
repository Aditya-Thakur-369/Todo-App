import 'package:go_router/go_router.dart';
import 'package:todo/screens/forgetpassword_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/reset_password.dart';
import 'package:todo/screens/signin_screen.dart';
import 'package:todo/screens/signup_screen.dart';

final  GoRouter  router = GoRouter(
  initialLocation: '/',
  routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const home_screen();
    },
  ),
   GoRoute(
    path: '/signin_screen',
    builder: (context, state) {
      return const  signin_screen();
    },
  ),
   GoRoute(
    path: '/signup_screen',
    builder: (context, state) {
      return const  signup_screen();
    },
  ),
   GoRoute(
    path: '/reset_password_screen',
    builder: (context, state) {
      return const  reset_password_screen();
    },
  ),
   GoRoute(
    path: '/forgetpassword_screen',
    builder: (context, state) {
      return const  forgetpassword_screen();
    },
  ),
]);
