import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen that lists the counties belonging to [stateId].
///
/// Navigating to a county pushes `/resources/:countyId`.
///
/// TODO(feature): Replace the hardcoded placeholder with a real county service
/// once a CountyService is available.
class CountyListScreen extends StatelessWidget {
  final String stateId;

  const CountyListScreen({super.key, required this.stateId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counties – $stateId')),
      body: Center(
        child: Text(
          'Select a county in $stateId',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
