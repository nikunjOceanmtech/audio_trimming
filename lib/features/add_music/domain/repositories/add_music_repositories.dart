import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';

abstract class MusicCategoryRepositories {
  Future<Either<AppError, List<MusicCategoryEntity>>> getMusicCategoryData({required String type});
  Future<Either<AppError, List<MusicListEntity>>> getMusicListData({required int id});
}
