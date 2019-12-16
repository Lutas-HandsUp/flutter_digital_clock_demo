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
  Timer _timer;
  List<int> _time = List(6);

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          var now = new DateTime.now();
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
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[0])),
          flex: 1,
        ),
        Expanded(
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[1])),
          flex: 1,
        ),
        Expanded(
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[2])),
          flex: 1,
        ),
        Expanded(
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[3])),
          flex: 1,
        ),
        Expanded(
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[4])),
          flex: 1,
        ),
        Expanded(
          child: CustomPaint(painter: DigitalNumberPainter(number: _time[5])),
          flex: 1,
        ),
      ],
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

  DigitalNumberPainter({this.number = 0}) {
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
    if (num == null) return;
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
