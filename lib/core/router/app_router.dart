import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:residence_app/providers/auth_provider.dart';
import 'package:residence_app/screens/welcome/welcome_screen.dart';
import 'package:residence_app/screens/login/login_screen.dart';
import 'package:residence_app/screens/admin_shell.dart';
import 'package:residence_app/screens/user_shell.dart';
import 'package:residence_app/screens/profile/condo_profile_screen.dart';
import 'package:residence_app/screens/profile/visitor_preregister_screen.dart';
import 'route_names.dart';

/// A [ChangeNotifier] that wraps the auth state so GoRouter can listen to it.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen<AuthStateData>(authStateProvider, (prev, next) {
      notifyListeners();
    });
  }

  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthChangeNotifier(ref);

  return GoRouter(
    refreshListenable: authNotifier,
    initialLocation: RouteNames.welcome,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final location = state.matchedLocation;

      final isAuthRoute =
          location.startsWith('/admin') || location.startsWith('/user');

      if (!auth.isAuthenticated && isAuthRoute) {
        return RouteNames.login;
      }

      // If authenticated and on public routes, redirect to the correct shell
      final isPublicRoute = location == RouteNames.welcome ||
          location == RouteNames.login;
      if (auth.isAuthenticated && isPublicRoute) {
        return auth.role == 'admin' ? '/admin' : '/user';
      }

      return null;
    },
    routes: [
      // ── Public routes ──
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.condoProfile,
        builder: (context, state) {
          final condo = state.extra as Map<String, dynamic>? ?? {'name': '', 'location': '', 'image': 'assets/images/condo1.png'};
          return CondoProfileScreen(condo: condo);
        },
      ),
      GoRoute(
        path: RouteNames.visitorPreregister,
        builder: (context, state) {
          final condoName = state.extra as String? ?? 'Conjunto Residencial';
          return VisitorPreregisterScreen(condoName: condoName);
        },
      ),

      // ── Admin shell ──
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminShell(),
      ),

      // ── User shell ──
      GoRoute(
        path: '/user',
        builder: (context, state) => const UserShell(),
      ),

      // Reservation and Confirmation screens are navigated via Navigator.push
      // with required parameters (amenity, booking), not via GoRouter.
    ],
  );
});
