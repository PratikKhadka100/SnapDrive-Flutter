import 'package:flutter/material.dart';

class OrientationPredictionWidget extends StatelessWidget {
  final String label;
  final String confidence;

  const OrientationPredictionWidget(this.label, this.confidence, {super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
    );

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textStyle,
          ),
          Text(
            ' $confidence%',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
