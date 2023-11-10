import 'dart:math';
import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/add_music/domain/usecases/add_music_usecases.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'music_category_state.dart';

class MusicCategoryCubit extends Cubit<MusicCategoryState> {
  final MusicCategoryUseCase musicCategoryUseCase;
  MusicCategoryCubit({required this.musicCategoryUseCase}) : super(MusicCategoryLoadingState());

  Future<void> loadmusicCategoryData() async {
    String type = "music";
    Either<AppError, List<MusicCategoryEntity>> response = await musicCategoryUseCase(type);

    response.fold(
      (l) => emit(
        MusicCategoryErrorState(
          appErrorType: l.errorType,
          errorMessage: l.errorMessage,
        ),
      ),
      (r) {
        List<MusicCategoryEntity> l1 = [];
        l1.add(MusicCategoryEntity(id: 0, name: "All", image: "", isChangeCategory: true));
        l1.addAll(r);
        emit(
          MusicCategoryLoadedState(
            musicCategoryList: l1,
            random: Random().nextDouble(),
          ),
        );
      },
    );
  }

  void changeCategory({required MusicCategoryLoadedState state, required int index}) {
    if (state.musicCategoryList[index].isChangeCategory != true) {
      for (var element in state.musicCategoryList) {
        element.isChangeCategory = false;
      }
      state.musicCategoryList[index].isChangeCategory = !state.musicCategoryList[index].isChangeCategory;
    } else {
      for (var element in state.musicCategoryList) {
        element.isChangeCategory = false;
      }
    }
    emit(state.copyWith(musicCategoryList: state.musicCategoryList, random: Random().nextDouble()));
  }
}
