import 'package:flutter/material.dart';

SnackBar snackBarUtils(
    BuildContext context, String? title, IconData icon, Color color) {
  return SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8.0),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          GestureDetector(
            onTap: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            child: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
