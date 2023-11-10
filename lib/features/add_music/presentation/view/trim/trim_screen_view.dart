import 'dart:math';

import 'package:audio/features/add_music/presentation/cubit/music_list/music_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef CallbackSelection = void Function(double duration);

class WaveSlider extends StatefulWidget {
  final double widthWaveSlider;
  final double heightWaveSlider;
  final Color wavActiveColor;
  final Color wavDeactiveColor;
  final Color sliderColor;
  final Color backgroundColor;
  final Color positionTextColor;
  final double duration;
  final CallbackSelection callbackStart;
  final CallbackSelection callbackEnd;
  final MusicListCubit musicListCubit;
  final Color? boxColor;
  final MaterialColor? circleColor;
  final Color? barColor;
  final Color? barBackgroundColor;
  const WaveSlider({
    Key? key,
    required this.duration,
    required this.callbackStart,
    required this.musicListCubit,
    required this.callbackEnd,
    this.widthWaveSlider = 0,
    this.heightWaveSlider = 0,
    this.wavActiveColor = Colors.deepPurple,
    this.wavDeactiveColor = Colors.blueGrey,
    this.sliderColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.positionTextColor = Colors.black,
    this.boxColor,
    this.circleColor,
    this.barColor,
    this.barBackgroundColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double widthSlider = 300;
  double heightSlider = 100;
  static const barWidth = 5.0;
  static const selectBarWidth = 20.0;
  double barStartPosition = 0.0;
  double barEndPosition = 50;

  @override
  void initState() {
    super.initState();

    var shortSize = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide;

    widthSlider = (widget.widthWaveSlider < 50) ? (shortSize - 2 - 40) : widget.widthWaveSlider;
    heightSlider = (widget.heightWaveSlider < 50) ? 100 : widget.heightWaveSlider;
    barEndPosition = widthSlider - selectBarWidth;
  }

  double _getBarStartPosition() {
    return ((barEndPosition) < barStartPosition) ? barEndPosition : barStartPosition;
  }

  double _getBarEndPosition() {
    return ((barStartPosition + selectBarWidth) > barEndPosition)
        ? (barStartPosition + selectBarWidth)
        : barEndPosition;
  }

  int _getStartTime() {
    // ignore: division_optimization
    return (_getBarStartPosition() / (widthSlider / widget.duration)).toInt();
  }

  int _getEndTime() {
    return ((_getBarEndPosition() + selectBarWidth) / (widthSlider / widget.duration)).ceilToDouble().toInt();
  }

  String _timeFormatter(int second) {
    Duration duration = Duration(seconds: second);

    List<int> durations = [];
    if (duration.inHours > 0) {
      durations.add(duration.inHours);
    }
    durations.add(duration.inMinutes);
    durations.add(duration.inSeconds);

    return durations.map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthSlider - 5,
      height: heightSlider,
      child: Column(
        children: [
          Row(
            children: [
              Text(_timeFormatter(_getStartTime()), style: TextStyle(color: widget.positionTextColor)),
              Expanded(child: Container()),
              Text(_timeFormatter(_getEndTime()), style: TextStyle(color: widget.positionTextColor)),
            ],
          ),
          Expanded(
            child: Container(
              color: widget.backgroundColor,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(6.h),
                    child: flexbar(),
                  ),
                  cemterBar(
                    position: _getBarStartPosition() + selectBarWidth,
                    width: _getBarEndPosition() - _getBarStartPosition() - selectBarWidth,
                    callback: (details) {
                      var tmp1 = barStartPosition + details.delta.dx;
                      var tmp2 = barEndPosition + details.delta.dx;
                      if ((tmp1 > 0) && ((tmp2 + selectBarWidth) < widthSlider)) {
                        setState(() {
                          barStartPosition += details.delta.dx;
                          barEndPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(_getStartTime().toDouble());
                      widget.callbackEnd(_getEndTime().toDouble());
                    },
                  ),
                  bar(
                    position: _getBarStartPosition(),
                    colorBG: widget.sliderColor,
                    width: selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      var tmp = barStartPosition + details.delta.dx;
                      if ((barEndPosition - selectBarWidth) > tmp && (tmp >= 0)) {
                        setState(() {
                          barStartPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(_getStartTime().toDouble());
                    },
                  ),
                  bar(
                    position: _getBarEndPosition(),
                    colorBG: widget.sliderColor,
                    width: selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      var tmp = barEndPosition + details.delta.dx;
                      if ((barStartPosition + selectBarWidth) < tmp && (tmp + selectBarWidth) <= widthSlider) {
                        setState(() {
                          barEndPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackEnd(_getEndTime().toDouble());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bar({
    double? position,
    Color? colorBG,
    double? width,
    required GestureDragUpdateCallback callback,
    required GestureDragEndCallback? callbackEnd,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: position! >= 0.0 ? position : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: SizedBox(
          width: 16,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: double.infinity,
                  width: 4,
                  color: widget.barColor,
                ),
              ),
              Container(
                width: 16,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: Icon(Icons.circle, size: 16, color: widget.circleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cemterBar({
    double? position,
    double? width,
    GestureDragUpdateCallback? callback,
    GestureDragEndCallback? callbackEnd,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: position! >= 0.0 ? position - 10 : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          color: Colors.transparent,
          // height: 200.0,
          width: width! + 16,
          child: Column(
            children: [
              Container(height: 4, color: widget.barColor),
              Expanded(child: Container()),
              Container(height: 4, color: widget.barColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget flexbar() {
    int i = 0;
    return Container(
      height: 50,
      color: widget.barBackgroundColor,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.musicListCubit.bars.map((int? height) {
          i++;
          return Container(
            color: widget.barColor ?? Colors.black,
            height: height?.toDouble(),
            width: 1,
          );
        }).toList(),
      ),
    );
  }
}
