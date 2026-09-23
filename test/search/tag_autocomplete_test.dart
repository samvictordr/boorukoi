// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:boorusama/core/tags/autocompletes/types.dart';
import 'package:boorusama/core/tags/metatag/types.dart';

import 'common.dart';

final _defaultExtractor = DefaultMetatagExtractor(
  metatags: {
    const Metatag.simple(name: 'meta'),
  },
);

/// Renders highlighted runs as `[text]` so expectations stay readable.
String _render(List<AutocompleteDisplaySegment> segments) =>
    segments.map((s) => s.highlighted ? '[${s.text}]' : s.text).join();

void main() {
  group('suggestion highlighting', () {
    final cases = [
      (
        name: 'highlights the matching part of a tag',
        data: autocompleteData('tag'),
        query: 'ta',
        extractor: null,
        expected: '[ta]g',
      ),
      (
        name: 'highlights the tag but not its alias',
        data: autocompleteData('tag', 'alias'),
        query: 'ta',
        extractor: null,
        expected: 'alias ➞ [ta]g',
      ),
      (
        name: 'ignores the negation operator',
        data: autocompleteData('tag'),
        query: '-ta',
        extractor: null,
        expected: '[ta]g',
      ),
      (
        name: 'ignores the or operator',
        data: autocompleteData('tag'),
        query: '~ta',
        extractor: null,
        expected: '[ta]g',
      ),
      (
        name: 'ignores a known metatag prefix',
        data: autocompleteData('tag'),
        query: 'meta:ta',
        extractor: _defaultExtractor,
        expected: '[ta]g',
      ),
      (
        name: 'keeps the original casing of the matched text',
        data: const AutocompleteData(
          value: 'meta:Sentence_Case',
          label: 'Sentence Case',
        ),
        query: 'meta:sent',
        extractor: _defaultExtractor,
        expected: '[Sent]ence Case',
      ),
      (
        name: 'does not highlight when the metatag is unknown',
        data: const AutocompleteData(
          value: 'foo:Unknown',
          label: 'Unknown',
        ),
        query: 'foo:unk',
        extractor: _defaultExtractor,
        expected: 'Unknown',
      ),
      (
        name: 'does not highlight when the query has leading syntax',
        data: autocompleteData('tag'),
        query: '(ta',
        extractor: _defaultExtractor,
        expected: 'tag',
      ),
      (
        name: 'keeps markup characters in labels as plain text',
        data: autocompleteData('<3_<b>'),
        query: '<',
        extractor: null,
        expected: '[<]3 [<]b>',
      ),
    ];

    for (final c in cases) {
      test(c.name, () {
        expect(
          _render(c.data.toDisplaySegments(c.query, c.extractor)),
          c.expected,
        );
      });
    }
  });
}
