import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/export/domain/data_export.dart';

void main() {
  test('Csv quotes commas, quotes and newlines and keeps nulls empty', () {
    final csv = Csv.encode(
      ['a', 'b', 'c'],
      [
        ['plain', 'has,comma', null],
        ['say "hi"', 'line\nbreak', 3],
      ],
    );
    expect(csv, 'a,b,c\nplain,"has,comma",\n"say ""hi""","line\nbreak",3\n');
    expect(Csv.decode(csv), [
      ['a', 'b', 'c'],
      ['plain', 'has,comma', null],
      ['say "hi"', 'line\nbreak', '3'],
    ]);
  });

  test('empty quoted cell is an empty string, not null', () {
    expect(Csv.decode('x,y\n"",\n'), [
      ['x', 'y'],
      ['', null],
    ]);
  });
}
