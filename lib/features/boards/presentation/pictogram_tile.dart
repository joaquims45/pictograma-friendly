import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/app_theme.dart';

Color colorFromHex(String? hex, Color fallback) {
  if (hex == null || hex.length < 7) return fallback;
  return Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

/// Tarjeta grande de un pictograma. Feedback: cambio leve de tono, sin animación.
class PictogramTile extends StatefulWidget {
  const PictogramTile({
    super.key,
    required this.pictogram,
    required this.onTap,
  });

  final Pictogram pictogram;
  final VoidCallback onTap;

  @override
  State<PictogramTile> createState() => _PictogramTileState();
}

class _PictogramTileState extends State<PictogramTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pictogram;
    final base = colorFromHex(p.colorHex, AppColors.surface);
    final photo = p.photoPath;
    final image = photo != null && File(photo).existsSync()
        ? Image.file(File(photo), fit: BoxFit.cover)
        : p.assetPath != null
        ? Image.asset(p.assetPath!, fit: BoxFit.contain)
        : const SizedBox.shrink();

    return Semantics(
      button: true,
      label: p.labelEs,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _down ? Color.lerp(base, AppColors.ink, 0.12) : base,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: AppColors.surface,
                    child: SizedBox.expand(child: image),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    p.labelEs,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
