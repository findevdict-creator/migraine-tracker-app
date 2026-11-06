import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_controller.dart';

/// Typed-city fallback. Only the typed name is sent to the geocoder; the
/// chosen place is stored rounded like any other cell.
Future<void> showCitySearchSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => const CitySearchSheet(),
);

class CitySearchSheet extends ConsumerStatefulWidget {
  const CitySearchSheet({super.key});

  @override
  ConsumerState<CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends ConsumerState<CitySearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<GeocodeResult> _results = const [];
  bool _searching = false;
  bool _failed = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    setState(() {
      _searching = true;
      _failed = false;
    });
    try {
      final results = await ref.read(geocoderProvider).search(query);
      if (!mounted) return;
      setState(() => _results = results);
    } on Object {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _failed = true;
      });
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _choose(GeocodeResult result) async {
    final sync = ref.read(weatherSyncProvider);
    await sync.setManualLocation(
      ManualLocation(
        name: result.label,
        cell: LocationCell.from(result.lat, result.lon),
      ),
    );
    ref
      ..invalidate(weatherLocationProvider)
      ..invalidate(environmentViewProvider)
      ..invalidate(weatherRefreshProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: AppThemeTokens.space4,
        right: AppThemeTokens.space4,
        top: AppThemeTokens.space4,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppThemeTokens.space4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.envCitySearchTitle, style: context.textStyles.titleLarge),
          const SizedBox(height: AppThemeTokens.space3),
          TextField(
            key: const ValueKey('city-query'),
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.envCitySearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(AppThemeTokens.space3),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            onChanged: _onChanged,
            onSubmitted: _search,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(l10n.envPrivacyNote, style: context.textStyles.bodySmall),
          const SizedBox(height: AppThemeTokens.space3),
          if (_failed)
            Text(
              l10n.envCitySearchFailed,
              key: const ValueKey('city-failed'),
              style: context.textStyles.bodyMedium,
            )
          else if (_results.isEmpty && _controller.text.trim().length >= 2)
            if (!_searching)
              Text(
                l10n.envCityNoResults,
                key: const ValueKey('city-no-results'),
                style: context.textStyles.bodyMedium,
              ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final r = _results[index];
                return ListTile(
                  key: ValueKey('city-result-$index'),
                  leading: const Icon(Icons.place_outlined),
                  title: Text(r.label),
                  onTap: () => _choose(r),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
