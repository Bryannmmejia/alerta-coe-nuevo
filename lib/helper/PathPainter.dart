import 'dart:ui' as ui;

import 'package:alertacoe/models/AlertModel.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class MapPainter extends CustomPainter {
  MapPainter(this._notifier, this.cb, this._alertModel)
      : super(repaint: _notifier);

  final ValueNotifier<Offset> _notifier;
  final Paint _paint = Paint();
  final Function cb;
  final AlertModel _alertModel;

  Size _size = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, Size(810.22101, 523.22101), size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      for (var shape in _alertModel.provinces) {
        shape.path.transform(matrix);
      }
      //print('new size: $_size');
    }
    canvas
      ..drawColor(Colors.lightBlue[200]!, BlendMode.src); // <- null safety fix

    Province? selectedShape;
    for (var shape in _alertModel.provinces) {
      final path = shape.path.transformedPath!;
      final selected = path.contains(_notifier.value);
      _paint
        ..color = shape.coast.color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);
      selectedShape ??= selected ? shape : null;

      _paint
        ..color = shape.coast.strokeColor
        ..strokeWidth = shape.coast.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    }
    if (selectedShape != null) {
      _paint
        ..color = Colors.black
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12)
        ..style = PaintingStyle.fill;
      canvas.drawPath(selectedShape.path.transformedPath!, _paint);
      _paint.maskFilter = null;

      final builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          fontSize: 12,
          fontFamily: 'Roboto',
        ),
      )
        ..pushStyle(
          ui.TextStyle(
            color: whiteColor,
            shadows: [
              ...?kElevationToShadow[1],
              ...?kElevationToShadow[2],
            ],
          ),
        )
        ..addText(selectedShape.name);
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: size.width));
      canvas.drawParagraph(paragraph, _notifier.value.translate(0, -32));
      cb(selectedShape.id);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
