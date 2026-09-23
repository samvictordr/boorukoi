import 'package:flutter/foundation.dart';

typedef KurumiFeedbackCallback = void Function();

@immutable
class KurumiBehaviorData {
  const KurumiBehaviorData({
    this.reduceMotion = false,
    this.selectionFeedback,
    this.sliderLimitFeedback,
    this.sliderInteractionFeedback,
    this.refreshFeedback,
    this.menuFeedback,
    this.adaptiveMenuFeedback,
    this.contextMenuShowFeedback,
    this.contextMenuSelectionFeedback,
    this.contextMenuStartFeedbackEnabled = false,
    this.segmentedSelectionFeedback,
    this.successFeedback,
    this.errorFeedback,
    this.enableIMEPersonalizedLearning = true,
  });

  final bool reduceMotion;
  final KurumiFeedbackCallback? selectionFeedback;
  final KurumiFeedbackCallback? sliderLimitFeedback;
  final KurumiFeedbackCallback? sliderInteractionFeedback;
  final KurumiFeedbackCallback? refreshFeedback;
  final KurumiFeedbackCallback? menuFeedback;
  final KurumiFeedbackCallback? adaptiveMenuFeedback;
  final KurumiFeedbackCallback? contextMenuShowFeedback;
  final KurumiFeedbackCallback? contextMenuSelectionFeedback;
  final bool contextMenuStartFeedbackEnabled;
  final KurumiFeedbackCallback? segmentedSelectionFeedback;

  /// A task finished, e.g. a download completed.
  final KurumiFeedbackCallback? successFeedback;

  /// Something was rejected, e.g. a wrong PIN.
  final KurumiFeedbackCallback? errorFeedback;
  final bool enableIMEPersonalizedLearning;

  Duration effectiveDuration(Duration duration) =>
      reduceMotion ? Duration.zero : duration;

  void provideSelectionFeedback() => selectionFeedback?.call();

  void provideSuccessFeedback() => successFeedback?.call();

  void provideErrorFeedback() => errorFeedback?.call();
}
