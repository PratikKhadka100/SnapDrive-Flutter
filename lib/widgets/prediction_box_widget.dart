import 'dart:math' as math;

import 'package:flutter/material.dart';

class PredictionBoxWidget extends StatelessWidget {
  final List<dynamic> results;
  final double previewH;
  final double previewW;
  final double screenH;
  final double screenW;

  const PredictionBoxWidget({
    required this.results,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> renderBoxes() {
      return results.map((e) {
        var x0 = e["rect"]["x"];
        var w0 = e["rect"]["w"];
        var y0 = e["rect"]["y"];
        var h0 = e["rect"]["h"];
        dynamic scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (x0 - difW / 2) * scaleW;
          w = w0 * scaleW;
          if (x0 < difW / 2) w -= (difW / 2 - x0) * scaleW;
          y = y0 * scaleH;
          h = h0 * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = x0 * scaleW;
          w = w0 * scaleW;
          y = (y0 - difH / 2) * scaleH;
          h = h0 * scaleH;
          if (y0 < difH / 2) h -= (difH / 2 - y0) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: FittedBox(
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    children: [
                      Text(
                        e['detectedClass'],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${(e['confidenceInClass'] * 100).toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: renderBoxes(),
    );
  }
}
