// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';

class RTest extends StatefulWidget {
  const RTest({Key? key}) : super(key: key);

  @override
  State<RTest> createState() => _RTestState();
}

class _RTestState extends State<RTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: window.physicalSize.width > 1200 ? MediaQuery.of(context).size.width / 3 : 2000,
                  width: window.physicalSize.width > 1200 ? MediaQuery.of(context).size.width / 3 : 2000,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/mpos_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 500,
                  width: 800,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/mpos_logo.png'), fit: BoxFit.cover),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
