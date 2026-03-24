import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkifyText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LinkifyText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.bodyMedium;
    final linkStyle = defaultStyle?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    final spans = _buildSpans(text, defaultStyle, linkStyle);
    return RichText(
      text: TextSpan(children: spans, style: defaultStyle),
    );
  }

  List<InlineSpan> _buildSpans(
    String input,
    TextStyle? normalStyle,
    TextStyle? linkStyle,
  ) {
    final spans = <InlineSpan>[];
    final markdownLink = RegExp(r'\[([^\]]+)\]\((https?://[^)\s]+)\)');
    final plainUrl = RegExp(r'https?://[^\s)]+');

    int cursor = 0;

    while (cursor < input.length) {
      final mdMatch = markdownLink.matchAsPrefix(input, cursor);
      if (mdMatch != null) {
        final label = mdMatch.group(1) ?? '';
        final url = mdMatch.group(2) ?? '';
        if (label.isNotEmpty && url.isNotEmpty) {
          spans.add(
            TextSpan(
              text: label,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _openUrl(url);
                },
            ),
          );
        }
        cursor = mdMatch.end;
        continue;
      }

      final urlMatch = plainUrl.matchAsPrefix(input, cursor);
      if (urlMatch != null) {
        final url = urlMatch.group(0) ?? '';
        spans.add(
          TextSpan(
            text: url,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _openUrl(url);
              },
          ),
        );
        cursor = urlMatch.end;
        continue;
      }

      final nextMd = markdownLink.firstMatch(input.substring(cursor));
      final nextUrl = plainUrl.firstMatch(input.substring(cursor));

      int next = input.length;
      if (nextMd != null) {
        next = cursor + nextMd.start;
      }
      if (nextUrl != null) {
        next = next < cursor + nextUrl.start ? next : cursor + nextUrl.start;
      }

      if (next <= cursor) {
        next = cursor + 1;
      }

      spans.add(
        TextSpan(text: input.substring(cursor, next), style: normalStyle),
      );
      cursor = next;
    }

    return spans;
  }

  Future<void> _openUrl(String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
