import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_state.dart';
import 'package:bloc/bloc.dart';

class TrimCubit extends Cubit<TrimState> {
  TrimCubit()
      : super(const TrimLoadedState(
          barEndPosition: 50,
          barStartPosition: 0.0,
          widthSlider: 300,
          heightSlider: 100,
          barWidth: 5.0,
          selectBarWidth: 20.0,
        ));

  void findBarEndPosition(
      {required TrimLoadedState state,
      required double heightWaveSlider,
      required double widthWaveSlider,
      required double shortSize}) {
    double bartEndPos = state.widthSlider - state.selectBarWidth;
    double widthSlider = (widthWaveSlider < 50) ? (shortSize - 2 - 40) : widthWaveSlider;
    double heightSlider = (heightWaveSlider < 50) ? 100 : heightWaveSlider;
    emit(state.copywith(barEndPosition: bartEndPos, widthSlider: widthSlider, heightSlider: heightSlider));
  }

  double getBarStartPosition({required TrimLoadedState trimLoadedState}) {
    return ((trimLoadedState.barEndPosition) < trimLoadedState.barStartPosition)
        ? trimLoadedState.barEndPosition
        : trimLoadedState.barStartPosition;
  }

  double getBarEndPosition({required TrimLoadedState trimLoadedState}) {
    return ((trimLoadedState.barStartPosition + trimLoadedState.selectBarWidth) > trimLoadedState.barEndPosition)
        ? (trimLoadedState.barStartPosition + trimLoadedState.selectBarWidth)
        : trimLoadedState.barEndPosition;
  }

  int getStartTime({required TrimLoadedState trimLoadedState, required double duration}) {
    return getBarStartPosition(trimLoadedState: trimLoadedState) ~/ (trimLoadedState.widthSlider / duration);
  }

  int getEndTime({required TrimLoadedState trimLoadedState, required double duration}) {
    return ((getBarEndPosition(trimLoadedState: trimLoadedState) + trimLoadedState.selectBarWidth) /
            (trimLoadedState.widthSlider / duration))
        .ceilToDouble()
        .toInt();
  }

  void drageMusic({required TrimLoadedState trimLoadedState, required double dx}) {
    var tmp1 = trimLoadedState.barStartPosition + dx;
    var tmp2 = trimLoadedState.barEndPosition + dx;
    if ((tmp1 > 0) && ((tmp2 + trimLoadedState.selectBarWidth) < trimLoadedState.widthSlider)) {
      double barStartPos = trimLoadedState.barStartPosition;
      double barEndPos = trimLoadedState.barEndPosition;
      barStartPos = barStartPos + dx;
      barEndPos = barEndPos + dx;
      emit(trimLoadedState.copywith(barStartPosition: barStartPos, barEndPosition: barEndPos));
    }
  }

  void changeBarStartPos({required TrimLoadedState trimLoadedState, required double dx}) {
    var tmp = trimLoadedState.barStartPosition + dx;
    if ((trimLoadedState.barEndPosition - trimLoadedState.selectBarWidth) > tmp && (tmp >= 0)) {
      double barStartPos = trimLoadedState.barStartPosition;
      barStartPos = barStartPos + dx;
      emit(trimLoadedState.copywith(barStartPosition: barStartPos));
    }
  }

  void changeBarEndPos({required TrimLoadedState trimLoadedState, required double dx}) {
    var tmp = trimLoadedState.barEndPosition + dx;
    if ((trimLoadedState.barStartPosition + trimLoadedState.selectBarWidth) < tmp &&
        (tmp + trimLoadedState.selectBarWidth) <= trimLoadedState.widthSlider) {
      double barEndPos = trimLoadedState.barEndPosition;
      barEndPos = barEndPos + dx;
      emit(trimLoadedState.copywith(barEndPosition: barEndPos));
    }
  }
}
