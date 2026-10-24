import 'package:flutter/widgets.dart';

DateTime _systemNow() => DateTime.now();

/// Toque tolerante para manos chicas.
///
/// El `onTap` estándar de Flutter se descarta si el dedo se desliza más de
/// ~18 px, si hay un segundo dedo apoyado o si compite con un scroll, y los
/// chicos suelen apoyar con dos dedos o arrastrar un poco. Acá cada dedo se
/// sigue por separado (sin pasar por el sistema de gestos): cuenta como toque
/// si se levanta cerca de donde apoyó, sin importar cuánto tiempo estuvo ni
/// cuántos dedos hay. Si el dedo recorre más de [maxTravel] se lo considera
/// un arrastre (scroll) y no dispara nada.
class ForgivingTap extends StatefulWidget {
  const ForgivingTap({
    super.key,
    required this.onTap,
    required this.builder,
    this.semanticLabel,
    this.maxTravel = 48,
    this.minInterval = const Duration(milliseconds: 350),
    @visibleForTesting this.clock = _systemNow,
  });

  final VoidCallback onTap;

  /// Texto para lectores de pantalla (TalkBack).
  final String? semanticLabel;

  /// Recibe si hay algún dedo apoyado, para mostrar el feedback de "presionado".
  final Widget Function(BuildContext context, bool pressed) builder;

  /// Distancia máxima (px lógicos) entre apoyar y levantar para contar el toque.
  final double maxTravel;

  /// Dos dedos sobre lo mismo dicen una sola vez, no dos.
  final Duration minInterval;

  /// Reloj (se reemplaza solo en los tests).
  final DateTime Function() clock;

  @override
  State<ForgivingTap> createState() => _ForgivingTapState();
}

class _ForgivingTapState extends State<ForgivingTap> {
  final Map<int, Offset> _downAt = {};
  DateTime? _lastFired;

  bool get _pressed => _downAt.isNotEmpty;

  void _down(PointerDownEvent e) =>
      setState(() => _downAt[e.pointer] = e.position);

  void _up(PointerUpEvent e) {
    final start = _downAt.remove(e.pointer);
    setState(() {});
    if (start == null || (e.position - start).distance > widget.maxTravel) {
      return;
    }
    final now = widget.clock();
    final last = _lastFired;
    if (last != null && now.difference(last) < widget.minInterval) return;
    _lastFired = now;
    widget.onTap();
  }

  void _cancel(PointerCancelEvent e) {
    _downAt.remove(e.pointer);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _down,
      onPointerUp: _up,
      onPointerCancel: _cancel,
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        onTap: widget.onTap,
        child: widget.builder(context, _pressed),
      ),
    );
  }
}
