import 'dart:math';

import 'package:flutter/material.dart';

class FlutterReflectiveScreensaver extends StatefulWidget {
  const FlutterReflectiveScreensaver(
      {super.key, required this.child, this.backgroundColor, this.speed = 4.0});

  final Widget child;

  final double speed;

  final Color? backgroundColor;

  @override
  State<FlutterReflectiveScreensaver> createState() =>
      _FlutterReflectiveScreensaverState();
}

class _FlutterReflectiveScreensaverState
    extends State<FlutterReflectiveScreensaver> {
  GlobalKey widgetKey = GlobalKey();
  late Size deviceLength;
  late Size widgetSize;
  var location = const Offset(100, 100);
  late var vector = vectors(Random().nextInt(4));

  Offset vectors(int num) {
    if (num == 0) {
      return Offset(widget.speed, -widget.speed);
    } else if (num == 1) {
      return Offset(-widget.speed, -widget.speed);
    } else if (num == 2) {
      return Offset(-widget.speed, widget.speed);
    } else if (num == 3) {
      return Offset(widget.speed, widget.speed);
    } else {
      return const Offset(0, 0);
    }
  }

  void getPosition() {
    final box = widgetKey.currentContext!.findRenderObject() as RenderBox?;
    widgetSize = box!.size;
  }

  void addPosition() async {
    while (true) {
      /// 上
      if (location.dy <= 0 && vector == vectors(0)) {
        vector = vectors(3);
        setState(() {});
      } else if (location.dy <= 0 && vector == vectors(1)) {
        vector = vectors(2);
        setState(() {});
      }

      /// 左
      if (location.dx <= 0 && vector == vectors(1)) {
        setState(() {});
        vector = vectors(0);
      } else if (location.dx <= 0 && vector == vectors(2)) {
        setState(() {});
        vector = vectors(3);
      }

      /// 下
      if (location.dy >= deviceLength.height - widgetSize.height &&
          vector == vectors(3)) {
        setState(() {});
        vector = vectors(0);
      } else if (location.dy >= deviceLength.height - widgetSize.height &&
          vector == vectors(2)) {
        setState(() {});
        vector = vectors(1);
      }

      /// 右
      if (location.dx >= deviceLength.width - widgetSize.width &&
          vector == vectors(0)) {
        setState(() {});
        vector = vectors(1);
      } else if (location.dx >= deviceLength.width - widgetSize.width &&
          vector == vectors(3)) {
        setState(() {});
        vector = vectors(2);
      }
      await Future.delayed(const Duration(milliseconds: 10));
      setState(() {
        location += vector;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    deviceLength = MediaQuery.of(context).size;

    /// ランダムで デバイスの縦横の値 × 0.8 の値 を取得
    var randomWidth = deviceLength.width * 0.1 * Random().nextDouble() +
        deviceLength.width * 0.6;
    var randomHeight = deviceLength.height * 0.1 +
        Random().nextDouble() * deviceLength.height * 0.6;

    location = Offset(randomWidth, randomHeight);
    await Future.delayed(const Duration(milliseconds: 50));
    getPosition();
    addPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: location.dy,
          left: location.dx,
          child: Container(
            key: widgetKey,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
