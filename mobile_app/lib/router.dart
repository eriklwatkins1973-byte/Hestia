import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/resource_list_screen.dart';
import 'screens/resource_detail_screen.dart';
import 'models/resource.dart';

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/resources',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>? ?? {};
          return ResourceListScreen(
            stateCode: extra['stateCode'] ?? '',
            countyId: extra['countyId'],
            category: extra['category'],
          );
        },
      ),
      GoRoute(
        path: '/resources/:id',
        builder: (context, state) {
          final resource = state.extra as Resource?;
          final id = state.pathParameters['id'] ?? '';
          return ResourceDetailScreen(resource: resource, resourceId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
