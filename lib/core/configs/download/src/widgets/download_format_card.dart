// Package imports:
import 'package:expandable/expandable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

// Project imports:
import '../../../../downloads/filename/providers.dart';
import '../../../../downloads/filename/types.dart';
import '../../../../posts/post/types.dart';
import '../../../config/types.dart';
import 'filename_preview.dart';
import 'format_editing_field.dart';

class DownloadFormatCard extends ConsumerStatefulWidget {
  const DownloadFormatCard({
    required this.downloadFilenameBuilder,
    required this.defaultFileNameFormat,
    required this.format,
    required this.onChanged,
    required this.config,
    required this.title,
    super.key,
    this.previewBuilder,
    this.textController,
  });

  final DownloadFilenameGenerator<Post>? downloadFilenameBuilder;
  final String defaultFileNameFormat;
  final String? format;
  final BooruConfig config;
  final void Function(String value)? onChanged;
  final String title;
  final Widget Function(
    DownloadFilenameGenerator<Post> generator,
    String format,
  )?
  previewBuilder;
  final RichTextController? textController;

  @override
  ConsumerState<DownloadFormatCard> createState() => _DownloadFormatCardState();
}

class _DownloadFormatCardState extends ConsumerState<DownloadFormatCard> {
  late final RichTextController textController;

  @override
  void initState() {
    super.initState();

    textController =
        widget.textController ??
        RichTextController(
          text: widget.format,
          matchers: ref
              .read(downloadFilenameBuilderProvider(widget.config.auth))
              ?.textMatchers,
        );
  }

  @override
  void dispose() {
    if (widget.textController == null) {
      textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.downloadFilenameBuilder != null
        ? ValueListenableBuilder(
            valueListenable: textController,
            builder: (context, value, child) => widget.previewBuilder != null
                ? widget.previewBuilder!(
                    widget.downloadFilenameBuilder!,
                    value.text,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FilenamePreview(
                      filename: widget.downloadFilenameBuilder!.generateSample(
                        value.text,
                      ),
                    ),
                  ),
          )
        : const SizedBox();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Kurumi.themeOf(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(KurumiRadius.sm)),
      ),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          iconColor: Kurumi.themeOf(context).iconTheme.color,
          inkWellBorderRadius: const BorderRadius.all(
            Radius.circular(KurumiRadius.sm),
          ),
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            widget.title,
            style: Kurumi.themeOf(context).textTheme.bodyMedium,
          ),
        ),
        collapsed: preview,
        expanded: Column(
          children: [
            preview,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FormatEditingField(
                controller: textController,
                onChanged: widget.onChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          textController.text = widget.defaultFileNameFormat;
                          widget.onChanged?.call(widget.defaultFileNameFormat);
                        });
                      },
                      child: Text(
                        context.t.generic.action.reset,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
