import 'package:flutter/foundation.dart';

/// The report as finished text, independent of how it is drawn. The PDF
/// (phase 23) and the clinician share page (phase 34) both render this, so
/// a shared link shows exactly what the PDF shows.
@immutable
class ReportDocument {
  const ReportDocument({
    required this.title,
    required this.period,
    required this.generated,
    required this.blocks,
    required this.disclaimer,
    required this.footer,
  });

  factory ReportDocument.fromJson(Map<String, Object?> json) => ReportDocument(
    title: json['title']! as String,
    period: json['period']! as String,
    generated: json['generated']! as String,
    blocks: [
      for (final b in json['blocks']! as List)
        ReportBlock.fromJson((b as Map).cast<String, Object?>()),
    ],
    disclaimer: json['disclaimer']! as String,
    footer: json['footer']! as String,
  );

  /// Bumped when a block type changes; the share page checks it.
  static const int formatVersion = 1;

  final String title;
  final String period;
  final String generated;
  final List<ReportBlock> blocks;
  final String disclaimer;
  final String footer;

  Map<String, Object?> toJson() => {
    'v': formatVersion,
    'title': title,
    'period': period,
    'generated': generated,
    'blocks': [for (final b in blocks) b.toJson()],
    'disclaimer': disclaimer,
    'footer': footer,
  };
}

sealed class ReportBlock {
  const ReportBlock();

  factory ReportBlock.fromJson(Map<String, Object?> json) {
    List<String> strings(Object? v) => [for (final s in v! as List) '$s'];
    return switch (json['type']) {
      'heading' => HeadingBlock(json['text']! as String),
      'hint' => HintBlock(json['text']! as String),
      'text' => TextBlock(json['text']! as String),
      'stats' => StatsBlock([
        for (final t in json['tiles']! as List)
          (label: '${(t as Map)['label']}', value: '${t['value']}'),
      ]),
      'table' => TableBlock(
        header: strings(json['header']),
        rows: [for (final r in json['rows']! as List) strings(r)],
      ),
      'columns' => ColumnsBlock([
        for (final c in json['columns']! as List) strings(c),
      ]),
      'calendar' => CalendarBlock(
        title: json['title']! as String,
        leadingBlanks: json['leading']! as int,
        days: [
          for (final d in json['days']! as List)
            CalendarDay.fromJson((d as Map).cast<String, Object?>()),
        ],
      ),
      _ => throw FormatException('unknown block ${json['type']}'),
    };
  }

  Map<String, Object?> toJson();
}

class HeadingBlock extends ReportBlock {
  const HeadingBlock(this.text);
  final String text;
  @override
  Map<String, Object?> toJson() => {'type': 'heading', 'text': text};
}

/// A muted explanation under a heading.
class HintBlock extends ReportBlock {
  const HintBlock(this.text);
  final String text;
  @override
  Map<String, Object?> toJson() => {'type': 'hint', 'text': text};
}

class TextBlock extends ReportBlock {
  const TextBlock(this.text);
  final String text;
  @override
  Map<String, Object?> toJson() => {'type': 'text', 'text': text};
}

/// Headline numbers, drawn as tiles.
class StatsBlock extends ReportBlock {
  const StatsBlock(this.tiles);
  final List<({String label, String value})> tiles;
  @override
  Map<String, Object?> toJson() => {
    'type': 'stats',
    'tiles': [
      for (final t in tiles) {'label': t.label, 'value': t.value},
    ],
  };
}

class TableBlock extends ReportBlock {
  const TableBlock({required this.header, required this.rows});
  final List<String> header;
  final List<List<String>> rows;
  @override
  Map<String, Object?> toJson() => {
    'type': 'table',
    'header': header,
    'rows': rows,
  };
}

/// Side-by-side lists of lines.
class ColumnsBlock extends ReportBlock {
  const ColumnsBlock(this.columns);
  final List<List<String>> columns;
  @override
  Map<String, Object?> toJson() => {'type': 'columns', 'columns': columns};
}

/// One month, Monday first.
class CalendarBlock extends ReportBlock {
  const CalendarBlock({
    required this.title,
    required this.leadingBlanks,
    required this.days,
  });
  final String title;
  final int leadingBlanks;
  final List<CalendarDay> days;
  @override
  Map<String, Object?> toJson() => {
    'type': 'calendar',
    'title': title,
    'leading': leadingBlanks,
    'days': [for (final d in days) d.toJson()],
  };
}

@immutable
class CalendarDay {
  const CalendarDay({
    required this.day,
    required this.inRange,
    required this.attack,
    this.intensity,
  });

  factory CalendarDay.fromJson(Map<String, Object?> json) => CalendarDay(
    day: json['d']! as int,
    inRange: json['in']! as bool,
    attack: json['a']! as bool,
    intensity: json['i'] as int?,
  );

  final int day;
  final bool inRange;
  final bool attack;
  final int? intensity;

  /// The number shown: the intensity on an attack day, else the date.
  String get label => attack && intensity != null ? '$intensity' : '$day';

  /// Fill shade on an attack day: 0 mild or unrated, 1 moderate, 2 severe.
  int get band {
    final i = intensity;
    if (i == null || i <= 3) return 0;
    if (i <= 6) return 1;
    return 2;
  }

  Map<String, Object?> toJson() => {
    'd': day,
    'in': inRange,
    'a': attack,
    'i': ?intensity,
  };
}
