import 'package:flutter/material.dart';

Center noDataFoundImage({required String text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Image(
          image: AssetImage('images/empty_screen.png'),
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
