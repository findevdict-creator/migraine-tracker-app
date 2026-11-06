import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_controller.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_screen.dart';

/// Daily check-in: three mandatory taps, an optional second row, and a
/// date strip for back-filling the last week.
class CheckinScreen extends ConsumerWidget {
  const CheckinScreen({required this.date, super.key});

  /// `yyyy-MM-dd` of the day being edited.
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final editor = ref.watch(checkinEditorProvider(date));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkinTitle),
        actions: const [_ReminderAction()],
      ),
      body: editor.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.checkinLoadError)),
        data: (checkin) => _CheckinBody(checkin: checkin),
      ),
    );
  }
}

class _CheckinBody extends ConsumerStatefulWidget {
  const _CheckinBody({required this.checkin});

  final CheckinEntity checkin;

  @override
  ConsumerState<_CheckinBody> createState() => _CheckinBodyState();
}

class _CheckinBodyState extends ConsumerState<_CheckinBody> {
  late bool _showOptional = widget.checkin.hasOptional;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final checkin = widget.checkin;
    final editor = ref.read(checkinEditorProvider(checkin.date).notifier);
    return ListView(
      padding: const EdgeInsets.all(AppThemeTokens.space4),
      children: [
        _DateStrip(selected: checkin.date),
        const SizedBox(height: AppThemeTokens.space4),
        if (checkin.isComplete)
          Row(
            children: [
              Icon(Icons.check_circle, color: context.appColors.success),
              const SizedBox(width: AppThemeTokens.space2),
              Expanded(
                child: Text(
                  l10n.checkinComplete,
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ],
          )
        else
          Text(l10n.checkinIntro, style: context.textStyles.bodyLarge),
        for (final field in CheckinField.mandatoryFields)
          _ScaleRow(
            field: field,
            value: checkin[field],
            onTap: (v) => editor.toggleValue(field, v),
          ),
        CheckinCycleRow(date: checkin.date),
        const SizedBox(height: AppThemeTokens.space4),
        if (!_showOptional)
          AppButton(
            key: const ValueKey('checkin-more'),
            label: l10n.checkinAddMore,
            icon: Icons.expand_more,
            variant: AppButtonVariant.text,
            onPressed: () => setState(() => _showOptional = true),
          )
        else ...[
          SectionHeader(title: l10n.checkinOptionalTitle),
          for (final field in CheckinField.optionalFields)
            _ScaleRow(
              field: field,
              value: checkin[field],
              onTap: (v) => editor.toggleValue(field, v),
            ),
        ],
        const SizedBox(height: AppThemeTokens.space6),
        AppButton(
          key: const ValueKey('checkin-done'),
          label: l10n.checkinDone,
          expand: true,
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ],
    );
  }
}

/// One field: label plus a row of number chips. One tap per field.
class _ScaleRow extends StatelessWidget {
  const _ScaleRow({
    required this.field,
    required this.value,
    required this.onTap,
  });

  final CheckinField field;
  final int? value;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppThemeTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              checkinFieldLabel(l10n, field),
              style: context.textStyles.titleMedium,
            ),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Row(
            children: [
              for (var v = field.min; v <= field.max; v++) ...[
                Expanded(
                  child: Semantics(
                    label: checkinValueLabel(l10n, field, v),
                    child: AppChoiceChip(
                      key: ValueKey('checkin-${field.name}-$v'),
                      label: v.toString(),
                      selected: value == v,
                      onSelected: (_) => onTap(v),
                    ),
                  ),
                ),
                if (v < field.max) const SizedBox(width: AppThemeTokens.space1),
              ],
            ],
          ),
          const SizedBox(height: AppThemeTokens.space1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                checkinLowLabel(l10n, field),
                style: context.textStyles.bodySmall,
              ),
              Text(
                checkinHighLabel(l10n, field),
                style: context.textStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Today and the back-fill window as chips; filled days get a check.
class _DateStrip extends ConsumerWidget {
  const _DateStrip({required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dates = ref.watch(backfillDatesProvider);
    final filled = ref.watch(backfillCheckinsProvider).value ?? const {};
    final today = ref.watch(todayKeyProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final date in dates) ...[
            AppChoiceChip(
              key: ValueKey('checkin-date-$date'),
              label: date == today
                  ? l10n.checkinToday
                  : DateFormat.MMMd(Localizations.localeOf(context).toString())
                        .format(parseDateKey(date)),
              icon: (filled[date]?.isComplete ?? false) ? Icons.check : null,
              selected: date == selected,
              onSelected: (_) => context.pushReplacement('/checkin/$date'),
            ),
            const SizedBox(width: AppThemeTokens.space2),
          ],
        ],
      ),
    );
  }
}

/// App-bar action that opens a time picker for the daily reminder.
class _ReminderAction extends ConsumerWidget {
  const _ReminderAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final time = ref.watch(checkinReminderProvider).value;
    return IconButton(
      key: const ValueKey('checkin-reminder'),
      icon: const Icon(Icons.alarm),
      tooltip: time == null
          ? l10n.checkinReminderTooltip
          : l10n.checkinReminderAt(time.format(context)),
      onPressed: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? AppThresholds.defaultCheckinReminder,
          helpText: l10n.checkinReminderPickerTitle,
        );
        if (picked != null) {
          await ref.read(checkinReminderProvider.notifier).set(picked);
        }
      },
    );
  }
}

String checkinFieldLabel(AppLocalizations l10n, CheckinField f) => switch (f) {
  CheckinField.sleepQuality => l10n.checkinSleepQuality,
  CheckinField.stress => l10n.checkinStress,
  CheckinField.neckTension => l10n.checkinNeckTension,
  CheckinField.caffeine => l10n.checkinCaffeine,
  CheckinField.hydration => l10n.checkinHydration,
  CheckinField.alcohol => l10n.checkinAlcohol,
  CheckinField.lightExposure => l10n.checkinLightExposure,
  CheckinField.screenExposure => l10n.checkinScreenExposure,
};

String checkinLowLabel(AppLocalizations l10n, CheckinField f) => switch (f) {
  CheckinField.sleepQuality => l10n.checkinSleepLow,
  CheckinField.stress => l10n.checkinStressLow,
  CheckinField.neckTension => l10n.checkinNeckLow,
  CheckinField.caffeine => l10n.checkinNone,
  CheckinField.hydration => l10n.checkinHydrationLow,
  CheckinField.alcohol => l10n.checkinNone,
  CheckinField.lightExposure => l10n.checkinExposureLow,
  CheckinField.screenExposure => l10n.checkinExposureLow,
};

String checkinHighLabel(AppLocalizations l10n, CheckinField f) => switch (f) {
  CheckinField.sleepQuality => l10n.checkinSleepHigh,
  CheckinField.stress => l10n.checkinStressHigh,
  CheckinField.neckTension => l10n.checkinNeckHigh,
  CheckinField.caffeine => l10n.checkinCupsOrMore(f.max),
  CheckinField.hydration => l10n.checkinHydrationHigh,
  CheckinField.alcohol => l10n.checkinDrinksOrMore(f.max),
  CheckinField.lightExposure => l10n.checkinExposureHigh,
  CheckinField.screenExposure => l10n.checkinExposureHigh,
};

String checkinValueLabel(AppLocalizations l10n, CheckinField f, int v) =>
    l10n.checkinValueSemantics(checkinFieldLabel(l10n, f), v, f.max);
