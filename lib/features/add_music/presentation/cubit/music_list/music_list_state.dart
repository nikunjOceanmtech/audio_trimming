part of 'music_list_cubit.dart';

sealed class MusicListState extends Equatable {
  const MusicListState();

  @override
  List<Object> get props => [];
}

class MusicListLoadingState extends MusicListState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class MusicListLoadedState extends MusicListState {
  final List<MusicListEntity> musicList;
  final double random;
  final double totalDuration;
  final double startValue;
  final double endValue;
  

  MusicListLoadedState({
    required this.musicList,
    required this.random,
    required this.totalDuration,
    required this.startValue,
    required this.endValue,
   
  });

  MusicListLoadedState copyWith({
    List<MusicListEntity>? musicList,
    double? random,
    double? totalDuration,
    double? startValue,
    double? endValue,
  
  }) {
    return MusicListLoadedState(
     
      musicList: musicList ?? this.musicList,
      random: random ?? this.random,
      totalDuration: totalDuration ?? this.totalDuration,
      startValue: startValue ?? this.startValue,
      endValue: endValue ?? this.endValue,
    );
  }

  @override
  List<Object> get props => [
        musicList,
        random,
        totalDuration,
        startValue,
        endValue,
   
      ];
}

class MusicListErrorState extends MusicListState {
  final AppErrorType appErrorType;
  final String errorMessage;

  const MusicListErrorState({required this.appErrorType, required this.errorMessage});
  @override
  List<Object> get props => [appErrorType, errorMessage];
}
