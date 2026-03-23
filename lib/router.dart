import 'package:go_router/go_router.dart';

import 'screens/county_list_screen.dart';
import 'screens/resource_list_screen.dart';
import 'screens/state_selection_screen.dart';

/// The application-level [GoRouter] that maps URL paths to screens.
///
/// Routes:
/// - `/`                   → [StateSelectionScreen]
/// - `/counties/:stateId`  → [CountyListScreen]
/// - `/resources/:countyId`→ [ResourceListScreen]
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const StateSelectionScreen(),
    ),
    GoRoute(
      path: '/counties/:stateId',
      builder: (context, state) => CountyListScreen(
        stateId: state.pathParameters['stateId']!,
      ),
    ),
    GoRoute(
      path: '/resources/:countyId',
      builder: (context, state) => ResourceListScreen(
        countyId: state.pathParameters['countyId']!,
      ),
    ),
  ],
);
