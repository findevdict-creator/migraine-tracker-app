import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/theme/app_motion.dart';

enum _Phase { idle, breatheIn, breatheOut, done }

/// Paced breathing: a circle grows for the in-breath and shrinks for the
/// out-breath, with the words to match. With reduce motion the circle
/// stays still and only the words change.
class BreathingPacer extends ConsumerStatefulWidget {
  const BreathingPacer({super.key});

  @override
  ConsumerState<BreathingPacer> createState() => _BreathingPacerState();
}

class _BreathingPacerState extends ConsumerState<BreathingPacer> {
  _Phase _phase = _Phase.idle;
  int _round = 0;
  Timer? _timer;

  void _start() {
    _round = 1;
    _enter(_Phase.breatheIn);
  }

  void _enter(_Phase phase) {
    _timer?.cancel();
    setState(() => _phase = phase);
    switch (phase) {
      case _Phase.breatheIn:
        _timer = Timer(
          AppThresholds.breathingIn,
          () => _enter(_Phase.breatheOut),
        );
      case _Phase.breatheOut:
        _timer = Timer(AppThresholds.breathingOut, () {
          if (_round >= AppThresholds.breathingRounds) {
            _enter(_Phase.done);
          } else {
            _round++;
            _enter(_Phase.breatheIn);
          }
        });
      case _Phase.idle:
      case _Phase.done:
        break;
    }
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _phase = _Phase.idle);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reduced = AppMotion.reduced(
      context,
      preference: ref.watch(reduceMotionPreferenceProvider),
    );
    final running = _phase == _Phase.breatheIn || _phase == _Phase.breatheOut;
    final grown = _phase == _Phase.breatheIn;
    final scheme = Theme.of(context).colorScheme;
    final size = reduced ? 140.0 : (grown ? 160.0 : 90.0);
    final label = switch (_phase) {
      _Phase.breatheIn => l10n.breathingIn,
      _Phase.breatheOut => l10n.breathingOut,
      _Phase.done => l10n.breathingDone,
      _Phase.idle => '',
    };
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: Center(
            child: AnimatedContainer(
              duration: reduced
                  ? Duration.zero
                  : (grown
                        ? AppThresholds.breathingIn
                        : AppThresholds.breathingOut),
              curve: Curves.easeInOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer,
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(AppThemeTokens.space2),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    label,
                    key: const ValueKey('breathing-phase'),
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (running)
          Text(
            l10n.breathingRound(_round, AppThresholds.breathingRounds),
            key: const ValueKey('breathing-round'),
          ),
        const SizedBox(height: AppThemeTokens.space2),
        if (running)
          OutlinedButton(
            key: const ValueKey('breathing-stop'),
            onPressed: _stop,
            child: Text(l10n.breathingStop),
          )
        else
          FilledButton(
            key: const ValueKey('breathing-start'),
            onPressed: _start,
            child: Text(l10n.breathingStart),
          ),
      ],
    );
  }
}
