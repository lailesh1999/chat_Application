import 'dart:async';

import 'package:chat_application/screens/voiceMessage.dart';
import 'package:flutter/material.dart';

class ZoomButton extends StatefulWidget {
  @override
  _ZoomButtonState createState() => _ZoomButtonState();
}

class _ZoomButtonState extends State<ZoomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isButtonPressed = false;

  late Timer _timer;
  int _seconds = 0;

  int _start = 0;
  late StreamController<int> _streamController;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 10) {
          _start = 0;
          setState(() {
            rc.stopRecord();
            _handlePressEnd();
            timer.cancel();
          });
        } else {
          setState(() {
            _streamController.add(_start);
            _start++;
          });
        }
      },
    );
  }

  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    _streamController.close();
  }

  double iconSize = 24.0;
  double enlargedIconSize = 73.0;

  Record rc = Record();

  void _handleLongPressStart() async {
    _animationController.forward();
    startTimer();
    setState(() {
      iconSize = enlargedIconSize;
      _isButtonPressed = false;
    });

    rc.playAudioForDuration();
    rc.startRecord();
  }


  void _handlePressEnd() {

    _start = 0;
    _animationController.reverse();
    setState(() {
      resetTimer();
      stopTimer();
      iconSize = 24;
      _start = 0;
      _isButtonPressed = true;

    });
    rc.stopRecord();
  }


  void resetTimer() {
    setState(() {
      _start = 0;
      _streamController.add(_start);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _handleLongPressStart();
          _isButtonPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _handlePressEnd();
          _isButtonPressed = false;
        });
      },
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: StreamBuilder<int>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  _isButtonPressed
                      ? Text(
                          formatTime(snapshot.data ?? 0),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      : Text(""),
                  Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Usage example
