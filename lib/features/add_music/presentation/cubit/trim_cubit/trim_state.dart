import 'package:equatable/equatable.dart';

sealed class TrimState extends Equatable {
  const TrimState();

  @override
  List<Object> get props => [];
}

final class TrimLodingSate extends TrimState {}

class TrimLoadedState extends TrimState {
  final double barStartPosition;
  final double barEndPosition;
  final double widthSlider;
  final double heightSlider;
  final double barWidth;
  final double selectBarWidth;

  const TrimLoadedState({
    required this.barStartPosition,
    required this.barEndPosition,
    required this.widthSlider,
    required this.heightSlider,
    required this.barWidth,
    required this.selectBarWidth,
  });

  TrimLoadedState copywith({
    double? barStartPosition,
    double? barEndPosition,
    double? widthSlider,
    double? heightSlider,
    double? barWidth,
    double? selectBarWidth,
  }) {
    return TrimLoadedState(
      barWidth: barWidth ?? this.barWidth,
      heightSlider: heightSlider ?? this.heightSlider,
      selectBarWidth: selectBarWidth ?? this.selectBarWidth,
      widthSlider: widthSlider ?? this.widthSlider,
      barStartPosition: barStartPosition ?? this.barStartPosition,
      barEndPosition: barEndPosition ?? this.barEndPosition,
    );
  }

  @override
  List<Object> get props => [
        barStartPosition,
        barEndPosition,
        widthSlider,
        heightSlider,
        barWidth,
        selectBarWidth,
      ];
}

class TrimErrorState extends TrimState {
  final String errormessage;

  const TrimErrorState({required this.errormessage});

  @override
  List<Object> get props => [errormessage];
}
