import 'package:flutter/material.dart';
import 'package:migraine_tracker_wear/src/watch_controller.dart';
import 'package:watch_protocol/watch_protocol.dart';

class WearApp extends StatelessWidget {
  const WearApp({required this.controller, super.key});

  final WatchController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final view = controller.view;
      final accent = view.state?.accentColor;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: accent == null ? null : Color(accent),
          scaffoldBackgroundColor: Colors.black,
        ),
        home: WearHome(controller: controller, view: view),
      );
    },
  );
}

/// One scrolling column sized for a round screen: the level, then either
/// the start button or the running attack with intensity and end.
class WearHome extends StatelessWidget {
  const WearHome({required this.controller, required this.view, super.key});

  final WatchController controller;
  final WatchView view;

  @override
  Widget build(BuildContext context) {
    final state = view.state;
    final attack = view.attack;
    final theme = Theme.of(context);
    final levelColor = state?.levelColor;
    return Scaffold(
      body: ListView(
        // Round screens clip the corners; this keeps text inside.
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        children: [
          if (!view.hasPhone)
            _Note(
              key: const ValueKey('wear-no-phone'),
              view.label(WatchLabels.noPhone),
            )
          else ...[
            Text(
              state!.levelLabel,
              key: const ValueKey('wear-level'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: levelColor == null ? null : Color(levelColor),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (attack == null) ...[
              Text(
                state.headline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                state.pressure,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
          const SizedBox(height: 8),
          if (attack == null)
            FilledButton(
              key: const ValueKey('wear-start'),
              onPressed: controller.startAttack,
              child: Text(view.label(WatchLabels.start)),
            )
          else ...[
            Text(
              view
                  .label(WatchLabels.since)
                  .replaceAll('{time}', _time(context, attack.startedAt)),
              key: const ValueKey('wear-since'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            _IntensityPicker(
              label: view.label(WatchLabels.intensity),
              value: attack.intensity,
              onChanged: controller.setIntensity,
            ),
            const SizedBox(height: 4),
            FilledButton.tonal(
              key: const ValueKey('wear-stop'),
              onPressed: controller.endAttack,
              child: Text(view.label(WatchLabels.stop)),
            ),
          ],
          if (view.pendingCount > 0)
            _Note(
              key: const ValueKey('wear-pending'),
              view.label(WatchLabels.pending),
            ),
        ],
      ),
    );
  }

  static String _time(BuildContext context, DateTime at) =>
      MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(at.toLocal()),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );
}

class _IntensityPicker extends StatelessWidget {
  const _IntensityPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = value;
    return Semantics(
      label: label,
      value: current?.toString() ?? '',
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                key: const ValueKey('wear-intensity-down'),
                onPressed: current == 0
                    ? null
                    : () => onChanged((current ?? 1) - 1),
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  current?.toString() ?? '–',
                  key: const ValueKey('wear-intensity'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton.filledTonal(
                key: const ValueKey('wear-intensity-up'),
                onPressed: current == 10
                    ? null
                    : () => onChanged((current ?? 0) + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall,
    ),
  );
}
