import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/security/pin_service.dart';
import '../../../core/theme/app_theme.dart';
import 'adult_home_screen.dart';

enum _Step { loading, verify, create, confirm }

/// Puerta del modo adulto: pide el PIN, o lo crea la primera vez.
/// Con [changePin] pide el PIN actual y luego define uno nuevo.
class PinGateScreen extends ConsumerStatefulWidget {
  const PinGateScreen({super.key, this.changePin = false});
  final bool changePin;

  @override
  ConsumerState<PinGateScreen> createState() => _PinGateScreenState();
}

class _PinGateScreenState extends ConsumerState<PinGateScreen> {
  _Step _step = _Step.loading;
  String _entered = '';
  String _firstPin = '';
  String? _message;
  bool _verifiedForChange = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final has = await ref.read(pinServiceProvider).hasPin();
    if (!mounted) return;
    setState(() => _step = has ? _Step.verify : _Step.create);
  }

  String get _title => switch (_step) {
    _Step.loading => '',
    _Step.verify =>
      widget.changePin && _verifiedForChange ? 'Nuevo PIN' : 'Ingresá el PIN',
    _Step.create => 'Creá un PIN de 4 dígitos',
    _Step.confirm => 'Repetí el PIN',
  };

  void _digit(String d) {
    if (_entered.length >= PinService.length) return;
    setState(() {
      _entered += d;
      _message = null;
    });
    if (_entered.length == PinService.length) _submit();
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _submit() async {
    final pin = _entered;
    final service = ref.read(pinServiceProvider);
    switch (_step) {
      case _Step.verify:
        if (!await service.verify(pin)) return _fail('PIN incorrecto');
        if (widget.changePin) {
          setState(() {
            _verifiedForChange = true;
            _step = _Step.create;
            _entered = '';
          });
          return;
        }
        _enter();
      case _Step.create:
        setState(() {
          _firstPin = pin;
          _step = _Step.confirm;
          _entered = '';
        });
      case _Step.confirm:
        if (pin != _firstPin) {
          setState(() => _step = _Step.create);
          return _fail('Los PIN no coinciden. Probá de nuevo');
        }
        await service.setPin(pin);
        if (widget.changePin) {
          if (mounted) Navigator.of(context).pop();
        } else {
          _enter();
        }
      case _Step.loading:
        break;
    }
  }

  void _fail(String message) => setState(() {
    _entered = '';
    _message = message;
  });

  void _enter() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AdultHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo adulto'),
        backgroundColor: Colors.transparent,
      ),
      body: _step == _Step.loading
          ? const SizedBox.shrink()
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Dots(filled: _entered.length),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          _message ?? '',
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    ),
                    _Keypad(onDigit: _digit, onBackspace: _backspace),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.filled});
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < PinService.length; i++)
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? AppColors.ink : Colors.transparent,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
          ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onDigit, required this.onBackspace});
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    Widget key(String label, VoidCallback? onTap, {IconData? icon}) => Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 84,
        height: 64,
        child: onTap == null
            ? null
            : FilledButton.tonal(
                onPressed: onTap,
                child: icon != null
                    ? Icon(icon)
                    : Text(label, style: const TextStyle(fontSize: 24)),
              ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [for (final d in row) key(d, () => onDigit(d))],
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            key('', null),
            key('0', () => onDigit('0')),
            key('', onBackspace, icon: Icons.backspace_outlined),
          ],
        ),
      ],
    );
  }
}
