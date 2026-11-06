import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Why a listen ended without a transcript.
enum SpeechFailure {
  /// Microphone or speech permission refused, or no recognizer.
  unavailable,

  /// Recognition ran but heard nothing usable (or the on-device model is
  /// missing).
  noMatch,
}

/// Microphone to text. One implementation uses the platform recognizer,
/// tests use a scripted fake.
abstract interface class SpeechCapture {
  /// Asks for permissions and prepares the recognizer; false when speech
  /// cannot be used on this phone.
  Future<bool> initialize();

  /// Starts listening. [onWords] gets partial and final text; [onDone]
  /// fires once, with the final text or a failure.
  Future<void> listen({
    required void Function(String words) onWords,
    required void Function(String? finalWords, SpeechFailure? failure) onDone,
    String? localeId,
  });

  Future<void> stop();

  Future<void> cancel();
}

final speechCaptureProvider = Provider<SpeechCapture>(
  (ref) => DeviceSpeechCapture(),
);

/// The `speech_to_text` plugin, on-device only per [AppThresholds].
class DeviceSpeechCapture implements SpeechCapture {
  DeviceSpeechCapture([SpeechToText? speech])
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  void Function(String? finalWords, SpeechFailure? failure)? _onDone;
  String _last = '';

  void _finish(String? words, SpeechFailure? failure) {
    final done = _onDone;
    _onDone = null;
    done?.call(words, failure);
  }

  @override
  Future<bool> initialize() async {
    try {
      return await _speech.initialize(
        onError: (error) {
          debugPrint('speech error: ${error.errorMsg}');
          _finish(
            _last.isEmpty ? null : _last,
            _last.isEmpty ? SpeechFailure.noMatch : null,
          );
        },
        onStatus: (status) {
          if (status == SpeechToText.doneStatus) {
            _finish(
              _last.isEmpty ? null : _last,
              _last.isEmpty ? SpeechFailure.noMatch : null,
            );
          }
        },
      );
    } on Object catch (error) {
      debugPrint('speech unavailable: $error');
      return false;
    }
  }

  @override
  Future<void> listen({
    required void Function(String words) onWords,
    required void Function(String? finalWords, SpeechFailure? failure) onDone,
    String? localeId,
  }) async {
    _last = '';
    _onDone = onDone;
    if (!_speech.isAvailable) {
      _finish(null, SpeechFailure.unavailable);
      return;
    }
    await _speech.listen(
      onResult: (result) {
        _last = result.recognizedWords;
        onWords(_last);
        if (result.finalResult) {
          _finish(_last.isEmpty ? null : _last, null);
        }
      },
      listenOptions: SpeechListenOptions(
        onDevice: AppThresholds.voiceOnDeviceOnly,
        listenMode: ListenMode.dictation,
        listenFor: AppThresholds.voiceListenFor,
        pauseFor: AppThresholds.voicePauseFor,
        localeId: localeId,
        cancelOnError: true,
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() async {
    _onDone = null;
    await _speech.cancel();
  }
}
