import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(title: const Text("Clock")),
            body: Container(
              color: Colors.black,
              child: DigitalClock(),
            )));
  }
}

class DigitalClock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DigitalClockState();
  }
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  final List<int> _time = [0, 0, 0, 0, 0, 0];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          var now = DateTime.now();
          var hour = now.hour;
          _time[0] = hour ~/ 10;
          _time[1] = hour % 10;
          var minute = now.minute;
          _time[2] = minute ~/ 10;
          _time[3] = minute % 10;
          var second = now.second;
          _time[4] = second ~/ 10;
          _time[5] = second % 10;
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
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[0])),
        ),
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[1])),
        ),
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[2])),
        ),
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[3])),
        ),
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[4])),
        ),
        Expanded(
          flex: 1,
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[5])),
        ),
      ],
    );
  }
}

class DigitalNumberPainter extends CustomPainter {
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

  DigitalNumberPainter({this.number = 0}) {
    Paint paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    double padding = 8;
    double rowWidth = 36;
    double columnHeight = 48;

    for (int i = 0; i < 3; i++) {
      double height = columnHeight * i + padding;
      Offset p1 = Offset(padding + padding, height);
      Offset p2 = Offset(rowWidth, height);

      funList.add((Canvas canvas) {
        canvas.drawLine(p1, p2, paint);
      });
    }

    for (int i = 0; i < 2; i++) {
      double width = rowWidth * i + padding;
      Offset p1 = Offset(width, padding + padding);
      Offset p2 = Offset(width, columnHeight);

      funList.add((Canvas canvas) {
        canvas.drawLine(p1, p2, paint);
      });

      Offset p3 = Offset(width, padding + padding + columnHeight);
      Offset p4 = Offset(width, columnHeight + columnHeight);

      funList.add((Canvas canvas) {
        canvas.drawLine(p3, p4, paint);
      });
    }
  } //  MyPainter({this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    List<bool> num = digitalMap[number];
    for (int i = 0; i < 7; i++) {
      if (num[i] && funList[i] != null) {
        funList[i](canvas);
      }
    }
  }

  @override
  bool shouldRepaint(DigitalNumberPainter oldDelegate) {
    return number != oldDelegate.number;
  }
}
