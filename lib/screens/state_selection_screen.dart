import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Entry screen where the user selects a US state.
///
/// Each state item navigates to [CountyListScreen] via `/counties/:stateId`.
///
/// TODO(feature): Replace the hardcoded list with a real state service once
/// a StateService is available.
class StateSelectionScreen extends StatelessWidget {
  const StateSelectionScreen({super.key});

  /// Placeholder list of states. Each record holds an `id` (used as the URL
  /// path parameter) and a human-readable `name`.
  static const List<Map<String, String>> _states = [
    {'id': 'CA', 'name': 'California'},
    {'id': 'NY', 'name': 'New York'},
    {'id': 'TX', 'name': 'Texas'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a State')),
      body: ListView.builder(
        itemCount: _states.length,
        itemBuilder: (context, index) {
          final state = _states[index];
          return ListTile(
            title: Text(state['name']!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.go('/counties/${state['id']}'),
          );
        },
      ),
    );
  }
}
