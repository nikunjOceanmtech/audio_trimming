import 'package:audio/features/add_music/data/datasources/add_music_data_source.dart';
import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/add_music/domain/repositories/add_music_repositories.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';

class MusicCategoryRepositoriedImpl extends MusicCategoryRepositories {
  final MusicCategoryDataSource musicCategoryDataSource;

  MusicCategoryRepositoriedImpl({required this.musicCategoryDataSource});

  @override
  Future<Either<AppError, List<MusicCategoryEntity>>> getMusicCategoryData({required String type}) {
    return musicCategoryDataSource.getMusicCategoryData(type: type);
  }

  @override
  Future<Either<AppError, List<MusicListEntity>>> getMusicListData({required int id}) {
    return musicCategoryDataSource.getMusicListData(id: id);
  }
}
