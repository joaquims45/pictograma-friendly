import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      builder: (context, child) {
        // En celulares la pantalla queda siempre vertical: girar el teléfono
        // cambiaría de lugar los pictogramas. Las tablets pueden girar.
        final phone = MediaQuery.sizeOf(context).shortestSide < 600;
        SystemChrome.setPreferredOrientations(
          phone
              ? const [DeviceOrientation.portraitUp]
              : DeviceOrientation.values,
        );
        return child ?? const SizedBox.shrink();
      },
      home: boot.when(
        loading: () => const Scaffold(),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
        data: (_) => const ProfilePickerScreen(),
      ),
    );
  }
}
