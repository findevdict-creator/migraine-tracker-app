import 'dart:typed_data';

import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/report/application/report_content.dart';
import 'package:migraine_tracker/features/report/domain/report_document.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Draws a [ReportDocument] as an A4 PDF. The wording lives in
/// [ReportContent], shared with the clinician share page, so this file is
/// layout only. Uses the built-in Helvetica fonts (Latin-1).
class ReportPdf {
  ReportPdf(this.l10n, {String? locale})
    : _content = ReportContent(l10n, locale: locale);

  final AppLocalizations l10n;
  final ReportContent _content;

  static const _ink = PdfColor.fromInt(0xFF1F2933);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _rule = PdfColor.fromInt(0xFFD1D5DB);
  static const _tileFill = PdfColor.fromInt(0xFFF3F4F6);
  static const _calendarFills = [
    PdfColor.fromInt(0xFFFDE68A),
    PdfColor.fromInt(0xFFFCA5A5),
    PdfColor.fromInt(0xFFEF4444),
  ];

  Future<Uint8List> build(
    ReportSummary report, {
    bool includeQuestionnaires = true,
  }) => render(
    _content.build(report, includeQuestionnaires: includeQuestionnaires),
  );

  Future<Uint8List> render(ReportDocument d) async {
    final doc =
        pw.Document(
          title: d.title,
          author: AppIdentity.name,
          creator: AppIdentity.name,
        )..addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            theme:
                pw.ThemeData.withFont(
                  base: pw.Font.helvetica(),
                  bold: pw.Font.helveticaBold(),
                ).copyWith(
                  defaultTextStyle: const pw.TextStyle(
                    fontSize: 10,
                    color: _ink,
                  ),
                ),
            footer: (context) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    d.footer,
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                  pw.Text(
                    l10n.reportPdfPage(context.pageNumber, context.pagesCount),
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                ],
              ),
            ),
            build: (context) => [
              _header(d),
              for (final b in d.blocks) _block(b),
              pw.SizedBox(height: 16),
              pw.Text(
                d.disclaimer,
                style: const pw.TextStyle(fontSize: 8, color: _muted),
              ),
            ],
          ),
        );
    return await doc.save();
  }

  pw.Widget _header(ReportDocument d) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        d.title,
        style: const pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(d.period),
      pw.Text(d.generated, style: const pw.TextStyle(color: _muted)),
      pw.SizedBox(height: 6),
      pw.Divider(color: _rule, thickness: 0.5),
    ],
  );

  pw.Widget _block(ReportBlock b) => switch (b) {
    HeadingBlock(:final text) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
    ),
    HintBlock(:final text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(text, style: const pw.TextStyle(color: _muted)),
    ),
    TextBlock(:final text) => pw.Text(text),
    StatsBlock(:final tiles) => _stats(tiles),
    TableBlock(:final header, :final rows) => _table(header, rows),
    ColumnsBlock(:final columns) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final c in columns)
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [for (final line in c) pw.Text(line)],
            ),
          ),
      ],
    ),
    final CalendarBlock c => _calendar(c),
  };

  pw.Widget _stats(List<({String label, String value})> tiles) => pw.Column(
    children: [
      for (var i = 0; i < tiles.length; i += 3) ...[
        if (i > 0) pw.SizedBox(height: 6),
        pw.Row(
          children: [
            for (final t in tiles.skip(i).take(3)) _tile(t.label, t.value),
          ],
        ),
      ],
    ],
  );

  pw.Widget _tile(String label, String value) => pw.Expanded(
    child: pw.Container(
      margin: const pw.EdgeInsets.only(right: 6),
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: _tileFill,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: _muted)),
        ],
      ),
    ),
  );

  pw.Widget _table(List<String> header, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: header,
        data: rows,
        border: null,
        headerStyle: const pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.5)),
        ),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellPadding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.25)),
        ),
      );

  pw.Widget _calendar(CalendarBlock c) {
    final cells = <pw.Widget>[
      for (var i = 0; i < c.leadingBlanks; i++) pw.SizedBox(),
      for (final day in c.days)
        pw.Container(
          height: 16,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            color: day.attack ? _calendarFills[day.band] : null,
            border: pw.Border.all(color: _rule, width: 0.25),
          ),
          child: pw.Text(
            day.label,
            style: pw.TextStyle(
              fontSize: 7,
              color: day.inRange ? _ink : _rule,
              fontWeight: day.attack ? pw.FontWeight.bold : null,
            ),
          ),
        ),
    ];
    while (cells.length % 7 != 0) {
      cells.add(pw.SizedBox());
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            c.title,
            style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.GridView(
            crossAxisCount: 7,
            childAspectRatio: 1 / 4.4,
            children: cells,
          ),
        ],
      ),
    );
  }
}
