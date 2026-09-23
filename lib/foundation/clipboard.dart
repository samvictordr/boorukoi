// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pasteboard/pasteboard.dart';

// Project imports:

abstract class AppClipboard {
  static Future<void> copy(String text) =>
      Clipboard.setData(ClipboardData(text: text));

  static Future<void> copyImageBytes(Uint8List bytes) =>
      Pasteboard.writeImage(bytes);

  static Future<String?> paste(String format) async {
    final data = await Clipboard.getData(format);
    return data?.text;
  }

  static Future<void> copyAndToast(
    BuildContext context,
    String text, {
    required String message,
  }) async {
    await copy(text);
    if (!context.mounted) return;
    Kurumi.showSuccessToast(
      context,
      message,
      icon: Symbols.content_copy,
      duration: KurumiDurations.shortToast,
    );
  }

  static Future<void> copyWithDefaultToast(
    BuildContext context,
    String text,
  ) => copyAndToast(
    context,
    text,
    message: context.t.generic.copied,
  );
}
