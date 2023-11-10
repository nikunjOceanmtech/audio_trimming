import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/add_music/domain/repositories/add_music_repositories.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:audio/features/shared/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class MusicCategoryUseCase extends UseCase<List<MusicCategoryEntity>, String> {
  final MusicCategoryRepositories musicCategoryRepositories;

  MusicCategoryUseCase({required this.musicCategoryRepositories});

  @override
  Future<Either<AppError, List<MusicCategoryEntity>>> call(String params) {
    return musicCategoryRepositories.getMusicCategoryData(type: params);
  }
}

class MusicListUseCase extends UseCase<List<MusicListEntity>,int> {
  final MusicCategoryRepositories musicCategoryRepositories;

  MusicListUseCase({required this.musicCategoryRepositories});

  @override
  Future<Either<AppError, List<MusicListEntity>>> call(int params) {
    return musicCategoryRepositories.getMusicListData(id: params);
  }
}
