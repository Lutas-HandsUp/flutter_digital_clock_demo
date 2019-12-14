import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(title: Text("Clock")),
            body: new Container(
              child: DigitalNumber(),
//              color: Colors.black,
            )));
  }
}

class DigitalNumber extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DigitalNumberState();
  }
}

class _DigitalNumberState extends State<DigitalNumber> {
  Timer _timer;
  int _number = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _number++;
          if (_number > 9) {
            _number = 0;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
//      child: Text(_number.toString()),
      child: CustomPaint(painter: DigitalNumberPainter(_number)),
//      color: Colors.black,
    );
  }
}

class DigitalNumberPainter extends CustomPainter {
  Paint white = new Paint()
    ..color = Colors.orangeAccent
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8.0;
  var funList = [];
  Map digitalMap = {
    0: [true, false, true, true, true, true, true],
    1: [false, false, false, false, false, true, true],
    2: [true, true, true, false, true, true, false],
    3: [true, true, true, false, false, true, true],
    4: [false, true, false, true, false, true, true],
    5: [true, true, true, true, false, false, true],
    6: [true, true, true, true, true, false, true],
    7: [true, false, false, true, false, true, true],
    8: [true, true, true, true, true, true, true],
    9: [true, true, true, true, false, true, true],
  };
  int number;

  DigitalNumberPainter(int number) {
    this.number = number;

    double padding = 8;
    double rowWidth = 36;
    double columnHeight = 48;

    for (int i = 0; i < 3; i++) {
      double height = columnHeight * i + padding;
      Offset p1 = new Offset(padding + padding, height);
      Offset p2 = new Offset(rowWidth, height);

      funList.add((Canvas canvas) {
        canvas.drawLine(p1, p2, white);
      });
    }

    for (int i = 0; i < 2; i++) {
      double width = rowWidth * i + padding;
      Offset p1 = new Offset(width, padding + padding);
      Offset p2 = new Offset(width, columnHeight);

      funList.add((Canvas canvas) {
        canvas.drawLine(p1, p2, white);
      });

      Offset p3 = new Offset(width, padding + padding + columnHeight);
      Offset p4 = new Offset(width, columnHeight + columnHeight);

      funList.add((Canvas canvas) {
        canvas.drawLine(p3, p4, white);
      });
    }
  } //  MyPainter({this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    List<bool> num = digitalMap[number];
    for (int i = 0; i < 7; i++) {
      if (num[i]) {
        funList[i](canvas);
      }
    }
  }

  @override
  bool shouldRepaint(DigitalNumberPainter oldDelegate) {
//    return number == oldDelegate.number;
    return true;
  }
}
