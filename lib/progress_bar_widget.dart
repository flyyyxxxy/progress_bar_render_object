import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProgressBar extends LeafRenderObjectWidget {
  final Color dotColor;
  final Color thumbColor;
  final double thumbSize;
  const ProgressBar({
    super.key,
    required this.dotColor,
    required this.thumbColor,
    required this.thumbSize,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      dotColor: dotColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderProgressBar extends RenderBox {
  RenderProgressBar({
    required Color dotColor,
    required Color thumbColor,
    required double thumbSize,
  })  : _dotColor = dotColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  Color _dotColor;
  Color _thumbColor;
  double _thumbSize;
  double _currentThumbValue = 0.5;

  Color get dotColor => _dotColor;
  set dotColor(Color value) {
    if (_dotColor == value) {
      return;
    }
    _dotColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) {
      return;
    }
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) {
      return;
    }
    _thumbSize = value;
    markNeedsPaint();
  }

  late HorizontalDragGestureRecognizer _drag;
  @override
  bool hitTestSelf(Offset position) => true;
  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void performLayout() {
    final desireWidth = constraints.maxWidth;
    final desireHeight = thumbSize;
    final desireSize = Size(desireWidth, desireHeight);
    size = constraints.constrain(desireSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    final dotPaint = Paint()
      ..color = dotColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final barPaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    final spacins = size.width / 10;
    for (var i = 0; i < 11; i++) {
      var upperPoint = Offset(spacins * i, size.height * 0.75);
      final lowerPoint = Offset(spacins * i, size.height);
      if (i % 5 == 0) {
        upperPoint = Offset(spacins * i, size.height * 0.25);
      }
      canvas.drawLine(upperPoint, lowerPoint, dotPaint);
    }
    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);

    final p1 = Offset(0, size.height / 2);
    final p2 = Offset(thumbDx, size.height / 2);
    canvas.drawLine(p1, p2, barPaint);

    canvas.drawCircle(center, thumbSize / 2, thumbPaint);
    canvas.restore();
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = double.parse((dx / size.width).toStringAsFixed(1));
    markNeedsPaint();
  }
}
