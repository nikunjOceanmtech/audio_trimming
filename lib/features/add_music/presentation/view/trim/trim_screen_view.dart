// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:audio/features/add_music/presentation/cubit/music_list/music_list_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef CallbackSelection = void Function(double duration);

class WaveSlider extends StatefulWidget {
  final double widthWaveSlider;
  final double heightWaveSlider;
  final Color wavActiveColor;
  final Color wavDeactiveColor;
  final Color boxColor;
  final Color backgroundColor;
  final Color positionTextColor;
  final double duration;
  final CallbackSelection callbackStart;
  final CallbackSelection callbackEnd;
  final TrimLoadedState trimLoadedState;
  final TrimCubit trimCubit;
  final MusicListCubit musicListCubit;
  final Color barBackgroundColor;
  final Color barColor;
  final Color circleColor;
  const WaveSlider({
    Key? key,
    required this.duration,
    required this.callbackStart,
    required this.callbackEnd,
    required this.trimLoadedState,
    required this.trimCubit,
    required this.musicListCubit,
    this.widthWaveSlider = 0,
    this.heightWaveSlider = 0,
    this.wavActiveColor = Colors.deepPurple,
    this.wavDeactiveColor = Colors.blueGrey,
    this.boxColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.positionTextColor = Colors.black,
    this.barBackgroundColor = Colors.white,
    this.barColor = Colors.blue,
    this.circleColor = Colors.red,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  @override
  void initState() {
    super.initState();

    var shortSize = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide;

    widget.trimCubit.findBarEndPosition(
      state: widget.trimLoadedState,
      widthWaveSlider: widget.widthWaveSlider,
      heightWaveSlider: widget.heightWaveSlider,
      shortSize: shortSize,
    );
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
      width: widget.trimLoadedState.widthSlider - 5,
      height: widget.trimLoadedState.heightSlider,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                  _timeFormatter(widget.trimCubit
                      .getStartTime(duration: widget.duration, trimLoadedState: widget.trimLoadedState)),
                  style: TextStyle(color: widget.positionTextColor)),
              Expanded(child: Container()),
              Text(
                  _timeFormatter(
                      widget.trimCubit.getEndTime(trimLoadedState: widget.trimLoadedState, duration: widget.duration)),
                  style: TextStyle(color: widget.positionTextColor)),
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
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: fixedBarViewer(
                      musicListCubit: widget.musicListCubit,
                      backgroundColor: widget.barBackgroundColor,
                      barColor: widget.barColor,
                    ),
                  ),
                  cemterBar(
                    horizontalBoxColor: widget.boxColor,
                    position: widget.trimCubit.getBarStartPosition(trimLoadedState: widget.trimLoadedState) +
                        widget.trimLoadedState.selectBarWidth,
                    width: widget.trimCubit.getBarEndPosition(trimLoadedState: widget.trimLoadedState) -
                        widget.trimCubit.getBarStartPosition(trimLoadedState: widget.trimLoadedState) -
                        widget.trimLoadedState.selectBarWidth,
                    callback: (details) {
                      widget.trimCubit.drageMusic(trimLoadedState: widget.trimLoadedState, dx: details.delta.dx);
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(widget.trimCubit
                          .getStartTime(trimLoadedState: widget.trimLoadedState, duration: widget.duration)
                          .toDouble());
                    },
                  ),
                  bar(
                    circleColor: widget.circleColor,
                    position: widget.trimCubit.getBarStartPosition(trimLoadedState: widget.trimLoadedState),
                    varticalBoxColor: widget.boxColor,
                    width: widget.trimLoadedState.selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      widget.trimCubit.changeBarStartPos(
                        trimLoadedState: widget.trimLoadedState,
                        dx: details.delta.dx,
                      );
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(widget.trimCubit
                          .getStartTime(trimLoadedState: widget.trimLoadedState, duration: widget.duration)
                          .toDouble());
                    },
                  ),
                  bar(
                    circleColor: widget.circleColor,
                    position: widget.trimCubit.getBarEndPosition(trimLoadedState: widget.trimLoadedState),
                    varticalBoxColor: widget.boxColor,
                    width: widget.trimLoadedState.selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      widget.trimCubit.changeBarEndPos(
                        trimLoadedState: widget.trimLoadedState,
                        dx: details.delta.dx,
                      );
                    },
                    callbackEnd: (details) {
                      widget.callbackEnd(widget.trimCubit
                          .getEndTime(trimLoadedState: widget.trimLoadedState, duration: widget.duration)
                          .toDouble());
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
    required Color varticalBoxColor,
    required Color circleColor,
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
                  color: varticalBoxColor,
                ),
              ),
              Container(
                width: 16,
                alignment: Alignment.center,
                child: Icon(Icons.circle, size: 16, color: circleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cemterBar({
    required Color? horizontalBoxColor,
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
          width: width! + 16,
          child: Column(
            children: [
              Container(height: 4, color: horizontalBoxColor),
              Expanded(child: Container()),
              Container(height: 4, color: horizontalBoxColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget fixedBarViewer({Color? backgroundColor, Color? barColor, required MusicListCubit musicListCubit}) {
    int i = 0;
    return Container(
      height: 50,
      color: backgroundColor ?? Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: musicListCubit.bars.map((int? height) {
          i++;
          return Container(
            color: barColor,
            height: height?.toDouble(),
            width: 1,
          );
        }).toList(),
      ),
    );
  }
}
