import 'package:flutter/material.dart';

class PredictionItemWidget extends StatelessWidget {
  final String predictedLabel;
  final String predictedConfidence;
  final Rect? detectedObjectRect;

  const PredictionItemWidget({
    required this.predictedLabel,
    required this.predictedConfidence,
    required this.detectedObjectRect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          'Object: $predictedLabel '
          ' Confidence: $predictedConfidence %',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (detectedObjectRect !=
            null) // Render the red box if an object is detected
          Positioned(
            left: detectedObjectRect!.left,
            top: detectedObjectRect!.top,
            width: detectedObjectRect!.width,
            height: detectedObjectRect!.height,
            child: Container(
              width: detectedObjectRect!.width,
              height: detectedObjectRect!.height,
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
                          predictedLabel,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$predictedConfidence %',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
