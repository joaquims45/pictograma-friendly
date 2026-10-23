import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'features/profiles/presentation/profile_picker_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootstrapProvider);
    return MaterialApp(
      title: 'Pictogramas',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: boot.when(
        loading: () => const Scaffold(),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
        data: (_) => const ProfilePickerScreen(),
      ),
    );
  }
}
