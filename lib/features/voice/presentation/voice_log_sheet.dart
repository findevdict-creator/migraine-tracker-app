import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/attack_log/presentation/head_map.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_controller.dart';
import 'package:migraine_tracker/features/voice/data/speech_capture.dart';
import 'package:migraine_tracker/features/voice/domain/voice_lexicon.dart';
import 'package:migraine_tracker/features/voice/domain/voice_parser.dart';

/// How many of the person's own medication names the parser knows.
const int _medicationNameLimit = 50;

/// Opens the voice sheet for [attackId]. Listens, parses, then shows the
/// confirmation form; nothing is saved until "Save to attack".
Future<void> showVoiceLogSheet(BuildContext context, String attackId) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => VoiceLogSheet(attackId: attackId),
    );

enum _Stage { listening, failed, review }

class VoiceLogSheet extends ConsumerStatefulWidget {
  const VoiceLogSheet({required this.attackId, super.key});

  final String attackId;

  @override
  ConsumerState<VoiceLogSheet> createState() => _VoiceLogSheetState();
}

class _VoiceLogSheetState extends ConsumerState<VoiceLogSheet> {
  _Stage _stage = _Stage.listening;
  SpeechFailure? _failure;
  String _partial = '';
  VoiceDraft? _draft;
  bool _saving = false;
  late final SpeechCapture _speech;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _speech = ref.read(speechCaptureProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The locale is read in _listen, so the first listen waits until the
    // inherited widgets are available.
    if (!_started) {
      _started = true;
      unawaited(_listen());
    }
  }

  @override
  void dispose() {
    if (_stage == _Stage.listening) unawaited(_speech.cancel());
    super.dispose();
  }

  Future<void> _listen() async {
    setState(() {
      _stage = _Stage.listening;
      _partial = '';
      _failure = null;
    });
    final locale = Localizations.localeOf(context);
    final ready = await _speech.initialize();
    if (!mounted) return;
    if (!ready) {
      setState(() {
        _stage = _Stage.failed;
        _failure = SpeechFailure.unavailable;
      });
      return;
    }
    await _speech.listen(
      localeId: locale.toLanguageTag().replaceAll('-', '_'),
      onWords: (words) {
        if (mounted) setState(() => _partial = words);
      },
      onDone: (words, failure) => unawaited(_heard(words, failure, locale)),
    );
  }

  Future<void> _heard(
    String? words,
    SpeechFailure? failure,
    Locale locale,
  ) async {
    if (!mounted) return;
    if (words == null || words.trim().isEmpty) {
      setState(() {
        _stage = _Stage.failed;
        _failure = failure ?? SpeechFailure.noMatch;
      });
      return;
    }
    final names = await ref
        .read(medicationRepositoryProvider)
        .recentNames(limit: _medicationNameLimit);
    final draft = VoiceParser(
      lexicon: VoiceLexicon.forLanguage(locale.languageCode),
      medicationNames: names,
    ).parse(words);
    if (!mounted) return;
    setState(() {
      _draft = draft;
      _stage = _Stage.review;
    });
  }

  Future<void> _save() async {
    final draft = _draft;
    if (draft == null || _saving) return;
    setState(() => _saving = true);
    await ref
        .read(attackEditorProvider(widget.attackId).notifier)
        .applyVoice(
          intensity: draft.intensity,
          symptoms: draft.symptoms,
          locations: draft.locations,
        );
    final log = ref.read(medicationLogProvider);
    for (final m in draft.medications) {
      await log.add(
        name: m.name,
        kind: MedicationKind.acute,
        dose: m.dose,
        attackId: widget.attackId,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: switch (_stage) {
      _Stage.listening => _listening(context),
      _Stage.failed => _failed(context),
      _Stage.review => _review(context),
    },
  );

  Widget _listening(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      key: const ValueKey('voice-listening'),
      padding: const EdgeInsets.all(AppThemeTokens.space5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.mic,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
            semanticLabel: l10n.voiceListening,
          ),
          const SizedBox(height: AppThemeTokens.space3),
          Text(
            l10n.voiceListening,
            textAlign: TextAlign.center,
            style: context.textStyles.headlineSmall,
          ),
          const SizedBox(height: AppThemeTokens.space3),
          Text(
            _partial.isEmpty ? l10n.voiceListeningHint : _partial,
            key: const ValueKey('voice-partial'),
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLarge,
          ),
          const SizedBox(height: AppThemeTokens.space5),
          AppButton(
            key: const ValueKey('voice-stop'),
            label: l10n.voiceStop,
            large: true,
            expand: true,
            onPressed: () => unawaited(_speech.stop()),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          AppButton(
            key: const ValueKey('voice-cancel'),
            label: l10n.voiceCancel,
            variant: AppButtonVariant.text,
            expand: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _failed(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      key: const ValueKey('voice-failed'),
      padding: const EdgeInsets.all(AppThemeTokens.space5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _failure == SpeechFailure.unavailable
                ? l10n.voiceUnavailable
                : l10n.voiceNoMatch,
            style: context.textStyles.bodyLarge,
          ),
          const SizedBox(height: AppThemeTokens.space5),
          if (_failure != SpeechFailure.unavailable) ...[
            AppButton(
              key: const ValueKey('voice-retry'),
              label: l10n.voiceTryAgain,
              large: true,
              expand: true,
              onPressed: () => unawaited(_listen()),
            ),
            const SizedBox(height: AppThemeTokens.space2),
          ],
          AppButton(
            key: const ValueKey('voice-cancel'),
            label: l10n.voiceCancel,
            variant: AppButtonVariant.text,
            expand: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _review(BuildContext context) {
    final l10n = context.l10n;
    final draft = _draft!;
    final names = {for (final m in draft.medications) m.name: m};
    return ListView(
      key: const ValueKey('voice-review'),
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppThemeTokens.space4),
      children: [
        Text(l10n.voiceReviewTitle, style: context.textStyles.headlineSmall),
        const SizedBox(height: AppThemeTokens.space2),
        Text(
          l10n.voiceHeard(draft.transcript),
          key: const ValueKey('voice-transcript'),
          style: context.textStyles.bodyMedium,
        ),
        if (draft.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppThemeTokens.space3),
            child: Text(
              l10n.voiceNothingUnderstood,
              key: const ValueKey('voice-nothing'),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.appColors.warning,
              ),
            ),
          ),
        SectionHeader(title: l10n.voiceIntensity),
        if (draft.intensity == null)
          Text(
            l10n.voiceIntensityNone,
            key: const ValueKey('voice-no-intensity'),
          )
        else
          AppIntensitySlider(
            key: const ValueKey('voice-intensity'),
            value: draft.intensity,
            onChanged: (v) =>
                setState(() => _draft = draft.copyWith(intensity: v)),
            semanticLabel: l10n.voiceIntensity,
          ),
        SectionHeader(title: l10n.voiceSymptoms),
        Wrap(
          spacing: AppThemeTokens.space2,
          runSpacing: AppThemeTokens.space2,
          children: [
            for (final s in Symptom.values)
              AppChoiceChip(
                key: ValueKey('voice-symptom-${s.name}'),
                label: symptomLabel(l10n, s),
                selected: draft.symptoms.contains(s),
                onSelected: (on) => setState(
                  () => _draft = draft.copyWith(
                    symptoms: on
                        ? {...draft.symptoms, s}
                        : ({...draft.symptoms}..remove(s)),
                  ),
                ),
              ),
          ],
        ),
        SectionHeader(title: l10n.voiceLocations),
        Wrap(
          spacing: AppThemeTokens.space2,
          runSpacing: AppThemeTokens.space2,
          children: [
            for (final h in HeadLocation.values)
              AppChoiceChip(
                key: ValueKey('voice-location-${h.name}'),
                label: headLocationLabel(l10n, h),
                selected: draft.locations.contains(h),
                onSelected: (on) => setState(
                  () => _draft = draft.copyWith(
                    locations: on
                        ? {...draft.locations, h}
                        : ({...draft.locations}..remove(h)),
                  ),
                ),
              ),
          ],
        ),
        if (names.isNotEmpty) ...[
          SectionHeader(title: l10n.voiceMedications),
          Wrap(
            spacing: AppThemeTokens.space2,
            runSpacing: AppThemeTokens.space2,
            children: [
              for (final m in names.values)
                AppChoiceChip(
                  key: ValueKey('voice-medication-${m.name}'),
                  label: m.toString(),
                  selected: true,
                  onSelected: (_) => setState(
                    () => _draft = draft.copyWith(
                      medications: [
                        for (final x in draft.medications)
                          if (x != m) x,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppThemeTokens.space5),
        AppButton(
          key: const ValueKey('voice-save'),
          label: l10n.voiceSave,
          large: true,
          expand: true,
          onPressed: draft.isEmpty || _saving ? null : _save,
        ),
        const SizedBox(height: AppThemeTokens.space2),
        AppButton(
          key: const ValueKey('voice-retry'),
          label: l10n.voiceTryAgain,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: () => unawaited(_listen()),
        ),
        AppButton(
          key: const ValueKey('voice-cancel'),
          label: l10n.voiceCancel,
          variant: AppButtonVariant.text,
          expand: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
