import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/home/home_screen.dart';
import 'package:mood_tracker/home/write_screen.dart';
import 'package:mood_tracker/repo/authentification_repository.dart';
import 'package:mood_tracker/screens/login_form_screen.dart';
import 'package:mood_tracker/screens/main_navigation_screen.dart';
import 'package:mood_tracker/screens/onboarding_screen.dart';
import 'package:mood_tracker/home/search_screen.dart';

final routerProvider = Provider((ref) {
  ref.read(authRepo);
  return GoRouter(
    initialLocation: "/",
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;

      if (!isLoggedIn &&
          state.matchedLocation != "/SignUp" &&
          state.matchedLocation != "/LogIn") {
        return "/";
      } else if (isLoggedIn &&
          (state.matchedLocation == "/" ||
              state.matchedLocation == "/SignUp")) {
        return "/home";
      }
      return null;
    },
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: "/SignUp",
        builder: (context, state) => const LoginFormScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return const MainNavigationScreen();
        },
        routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: "/search",
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: "/write",
            builder: (context, state) => WriteScreen(
              onUploadComplete: () {},
            ),
          ),
        ],
      ),
    ],
  );
});
