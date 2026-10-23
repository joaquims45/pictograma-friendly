import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import 'backup_screen.dart';
import 'pin_gate_screen.dart';
import 'profile_admin_screen.dart';
import 'usage_log_screen.dart';

class AdultHomeScreen extends ConsumerWidget {
  const AdultHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo adulto'),
        actions: [
          IconButton(
            tooltip: 'Cambiar PIN',
            icon: const Icon(Icons.password),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PinGateScreen(changePin: true),
              ),
            ),
          ),
        ],
      ),
      body: profiles.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Elegí un perfil para editarlo'),
            ),
            for (final p in list)
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Grilla ${p.gridSize}x${p.gridSize}'
                    '${p.phraseBarEnabled ? ' · con barra de frases' : ''}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileAdminScreen(profileId: p.id),
                    ),
                  ),
                ),
              ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 12),
              child: Text('Datos'),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: const Text('Copia de seguridad'),
                subtitle: const Text('Guardar o restaurar todo en un archivo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const BackupScreen())),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.insights_outlined),
                title: const Text('Registro de uso'),
                subtitle: const Text('Opcional, para el adulto o el terapeuta'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UsageLogScreen()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
