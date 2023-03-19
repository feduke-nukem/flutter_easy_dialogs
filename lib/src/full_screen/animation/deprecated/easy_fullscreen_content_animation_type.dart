@Deprecated(
  'Will be removed in 2.1.0. Consider using EasyFullScreenForegroundAnimator',
)

/// Full screen dialog content's appearance animation types.
enum EasyFullScreenContentAnimationType {
  /// Fade.
  fade,

  /// Bounce.
  ///
  /// Content bounces in and out when appears.
  bounce,

  /// Expansion.
  ///
  /// Content expands from it's center when appears.
  expansion,

  /// No animation.
  none,
}
