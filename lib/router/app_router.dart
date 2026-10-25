import 'dart:async';

import 'package:fast_track_flutter_fpt/auth/bloc/auth_bloc.dart';
import 'package:fast_track_flutter_fpt/auth/bloc/auth_state.dart';
import 'package:fast_track_flutter_fpt/screens/edit_product_screen.dart';
import 'package:fast_track_flutter_fpt/screens/login_screen.dart';
import 'package:fast_track_flutter_fpt/screens/product_detail_screen.dart';
import 'package:fast_track_flutter_fpt/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthBloc authBloc})
      : _authBloc = authBloc {
    _refreshListenable = _GoRouterRefreshStream(_authBloc.stream);

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _refreshListenable,
      redirect: (context, state) {
        final isLoggedIn = _authBloc.state is AuthSuccess;
        final isGoingToLogin = state.matchedLocation == '/login';

        if (!isLoggedIn && !isGoingToLogin) {
          return '/login';
        }

        if (isLoggedIn && isGoingToLogin) {
          return '/products';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                return ProductDetailScreen(
                  productId: state.pathParameters['id']!,
                );
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    return EditProductScreen(
                      productId: state.pathParameters['id']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  final AuthBloc _authBloc;

  late final GoRouter router;
  late final _GoRouterRefreshStream _refreshListenable;

  void dispose() {
    router.dispose();
    _refreshListenable.dispose();
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
