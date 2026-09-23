// Package imports:
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sliver_masonry_grid/sliver_masonry_grid.dart';

// Project imports:
import '../../../../../foundation/error_monitor.dart';
import '../../../../errors/types.dart';
import '../../../../widgets/widgets.dart';
import '../../../post/types.dart';
import '../../widgets.dart';
import '../types/image_list_type.dart';
import '../widgets/post_grid_controller.dart';
import 'raw_post_grid.dart';

class SliverPostGrid<T extends Post> extends StatelessWidget {
  const SliverPostGrid({
    required this.postController,
    required this.itemBuilder,
    required this.errorTranslator,
    super.key,
    this.padding,
    this.listType,
    this.spacing,
    this.aspectRatio,
    this.placeholderAspectRatio,
    this.borderRadius,
    this.postsPerPage,
    this.httpErrorActionBuilder,
    this.httpHandshakeErrorActionBuilder,
  });

  final PostGridController<T> postController;
  final EdgeInsetsGeometry? padding;
  final ImageListType? listType;
  final double? spacing;
  final double? aspectRatio;
  final double? placeholderAspectRatio;
  final BorderRadius? borderRadius;
  final int? postsPerPage;

  final IndexedWidgetBuilder itemBuilder;

  final Widget Function(BuildContext context, int httpStatusCode)?
  httpErrorActionBuilder;

  final Widget Function(BuildContext context, AppError error)?
  httpHandshakeErrorActionBuilder;

  final AppErrorTranslator errorTranslator;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: ValueListenableBuilder(
        valueListenable: postController.errors,
        builder: (_, error, _) {
          if (error != null) {
            return SliverToBoxAdapter(
              child: switch (error) {
                final AppError e => ErrorBox(
                  errorMessage: errorTranslator.translateAppError(context, e),
                  onRetry: switch (e.type) {
                    AppErrorType.cannotReachServer ||
                    AppErrorType.loadDataFromServerFailed => _onErrorRetry,
                    AppErrorType.handshakeFailed ||
                    AppErrorType.certificateError => null,
                  },
                  altAction: switch (e.type) {
                    AppErrorType.handshakeFailed ||
                    AppErrorType.certificateError
                        when httpHandshakeErrorActionBuilder != null =>
                      httpHandshakeErrorActionBuilder!(context, e),
                    _ => null,
                  },
                ),
                final ServerError e => KurumiEmptyState(
                  icon: Symbols.cloud_off,
                  tone: KurumiEmptyStateTone.error,
                  title:
                      e.httpStatusCode?.toString() ??
                      context.t.generic.errors.unknown,
                  message: errorTranslator.translateServerError(context, e),
                  action: switch ((
                    httpErrorActionBuilder,
                    e.httpStatusCode,
                  )) {
                    (final builder?, final int statusCode) => builder(
                      context,
                      statusCode,
                    ),
                    _ when e.isServerError => FilledButton.tonal(
                      onPressed: _onErrorRetry,
                      child: Text(context.t.generic.action.retry),
                    ),
                    _ => null,
                  },
                  details: _ServerErrorDetails(message: e.message),
                ),
                final UnknownError e => ErrorBox(
                  errorMessage: e.error.toString(),
                ),
              },
            );
          }

          return ValueListenableBuilder(
            valueListenable: postController.refreshingNotifier,
            builder: (_, refreshing, _) {
              return refreshing
                  ? SliverPostGridPlaceHolder(
                      padding: padding,
                      listType: listType,
                      spacing: spacing,
                      aspectRatio: aspectRatio,
                      placeholderAspectRatio: placeholderAspectRatio,
                      borderRadius: borderRadius,
                      postsPerPage: postsPerPage,
                    )
                  : _buildGrid(context);
            },
          );
        },
      ),
    );
  }

  void _onErrorRetry() => postController.refresh();

  Widget _buildGrid(BuildContext context) {
    final constraints = PostGridConstraints.of(context);

    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      sliver: ValueListenableBuilder(
        valueListenable: postController.itemsNotifier,
        builder: (_, data, _) {
          final crossAxisCount = constraints?.crossAxisCount ?? 3;
          final imageListType = listType ?? ImageListType.standard;

          return data.isNotEmpty
              ? switch (imageListType) {
                  ImageListType.masonry => SliverMasonryGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing ?? 4,
                    crossAxisSpacing: spacing ?? 4,
                    childCount: data.length,
                    itemBuilder: itemBuilder,
                  ),
                  _ => SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: aspectRatio ?? 1,
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing ?? 4,
                      crossAxisSpacing: spacing ?? 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      itemBuilder,
                      childCount: data.length,
                    ),
                  ),
                }
              : const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: NoDataBox(),
                  ),
                );
        },
      ),
    );
  }
}

String? translateServerError(BuildContext context, ServerError error) =>
    switch (error) {
      final ServerError e => switch (e.httpStatusCode) {
        null => null,
        401 => context.t.search.errors.forbidden,
        403 => context.t.search.errors.access_denied,
        429 => context.t.search.errors.rate_limited,
        >= 500 => context.t.search.errors.down,
        _ => null,
      },
    };

class _ServerErrorDetails extends StatefulWidget {
  const _ServerErrorDetails({
    required this.message,
  });

  final String message;

  @override
  State<_ServerErrorDetails> createState() => _ServerErrorDetailsState();
}

class _ServerErrorDetailsState extends State<_ServerErrorDetails> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Kurumi.themeOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded
                ? context.t.generic.action.hide_details
                : context.t.generic.action.show_details,
          ),
        ),
        AnimatedSize(
          duration: context.kurumiBehavior.effectiveDuration(
            KurumiMotion.standard,
          ),
          curve: KurumiMotion.standardCurve,
          alignment: Alignment.topCenter,
          child: !_expanded
              ? const SizedBox(width: double.infinity)
              : Builder(
                  builder: (context) {
                    try {
                      return MarkdownBody(
                        styleSheet: MarkdownStyleSheet(
                          codeblockPadding: const EdgeInsets.all(
                            KurumiSpacing.md,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: KurumiBorderRadius.md,
                          ),
                        ),
                        data: wrapIntoJsonToCodeBlock(
                          prettyPrintJson(widget.message),
                        ),
                      );
                    } catch (_) {
                      return Text(
                        widget.message,
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}
