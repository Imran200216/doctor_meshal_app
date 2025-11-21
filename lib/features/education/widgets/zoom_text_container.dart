import 'package:flutter/material.dart';

class ZoomableTextContainer extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;

  const ZoomableTextContainer({
    super.key,
    required this.child,
    this.minScale = 1.0,
    this.maxScale = 3.0,
  });

  @override
  State<ZoomableTextContainer> createState() => _ZoomableTextContainerState();
}

class _ZoomableTextContainerState extends State<ZoomableTextContainer> {
  double _scale = 1.0;
  double _baseScale = 1.0;
  bool _isScaling = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onScaleStart: (details) {
        if (details.pointerCount == 2) {
          setState(() => _isScaling = true);
          _baseScale = _scale;
        }
      },

      onScaleUpdate: (details) {
        if (details.pointerCount == 2) {
          setState(() {
            _scale = (_baseScale * details.scale).clamp(
              widget.minScale,
              widget.maxScale,
            );
          });
        }
      },

      onScaleEnd: (_) {
        setState(() => _isScaling = false);
      },

      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: _scale),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          // No SingleChildScrollView here - let child handle it
          child: widget.child,
        ),
      ),
    );
  }
}
