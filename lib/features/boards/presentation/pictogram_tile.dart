import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/forgiving_tap.dart';
import 'pictogram_image.dart';

Color colorFromHex(String? hex, Color fallback) {
  if (hex == null || hex.length < 7) return fallback;
  return Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

/// Tarjeta grande de un pictograma. Feedback: cambio leve de tono, sin animación.
/// Usa [ForgivingTap]: cuenta aunque el chico apoye con dos dedos o arrastre un poco.
class PictogramTile extends StatelessWidget {
  const PictogramTile({
    super.key,
    required this.pictogram,
    required this.onTap,
  });

  final Pictogram pictogram;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = pictogram;
    final base = colorFromHex(p.colorHex, AppColors.surface);
    final image = PictogramImage(p);

    return ForgivingTap(
      semanticLabel: p.labelEs,
      onTap: onTap,
      builder: (context, down) => LayoutBuilder(
        builder: (context, box) {
          // Todo escala con el ancho: en grillas densas el dibujo sigue mandando.
          final w = box.maxWidth;
          final pad = (w * 0.06).clamp(6.0, 12.0);
          final font = (w * 0.115).clamp(11.0, 30.0);
          final labelHeight = font * 1.15 * 2;
          return Container(
            decoration: BoxDecoration(
              color: down ? Color.lerp(base, AppColors.ink, 0.12) : base,
              borderRadius: BorderRadius.circular((w * 0.12).clamp(14, 24)),
            ),
            padding: EdgeInsets.all(pad),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(pad * 1.4),
                    child: ColoredBox(
                      color: AppColors.surface,
                      child: SizedBox.expand(child: image),
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.6),
                SizedBox(
                  height: labelHeight,
                  child: Center(
                    child: Text(
                      p.labelEs,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: font,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
