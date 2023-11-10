part of 'music_category_cubit.dart';

abstract class MusicCategoryState extends Equatable {
  const MusicCategoryState();

  @override
  List<Object> get props => [];
}

class MusicCategoryLoadingState extends MusicCategoryState {
  @override
  List<Object> get props => [];
}

class MusicCategoryLoadedState extends MusicCategoryState {
  final List<MusicCategoryEntity> musicCategoryList;
  final double random;

  const MusicCategoryLoadedState({required this.musicCategoryList, required this.random});

  MusicCategoryLoadedState copyWith({List<MusicCategoryEntity>? musicCategoryList, double? random}) {
    return MusicCategoryLoadedState(
      musicCategoryList: musicCategoryList ?? this.musicCategoryList,
      random: random ?? this.random,
    );
  }

  @override
  List<Object> get props => [musicCategoryList, random];
}

class MusicCategoryErrorState extends MusicCategoryState {
  final AppErrorType appErrorType;
  final String errorMessage;

  const MusicCategoryErrorState({required this.appErrorType, required this.errorMessage});
  @override
  List<Object> get props => [appErrorType, errorMessage];
}
