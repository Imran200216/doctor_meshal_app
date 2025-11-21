import 'package:flutter/material.dart';

class StableZoomContainer extends StatelessWidget {
  final Widget child;

  const StableZoomContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {},
      onPointerMove: (_) {},
      onPointerUp: (_) {},
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleStart: (_) {},
        onScaleUpdate: (_) {},
        child: InteractiveViewer(
          panEnabled: false,
          // Disable panning
          scaleEnabled: true,
          // Keep zoom
          clipBehavior: Clip.none,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.5,
          maxScale: 4.0,
          child: RepaintBoundary(child: child),
        ),
      ),
    );
  }
}
