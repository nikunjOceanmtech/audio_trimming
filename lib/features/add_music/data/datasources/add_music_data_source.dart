import 'dart:io';
import 'package:audio/core/api_client.dart';
import 'package:audio/core/api_constants.dart';
import 'package:audio/core/unathorised_exception.dart';
import 'package:audio/features/add_music/data/models/music_category_data_list_model.dart';
import 'package:audio/features/add_music/data/models/music_category_model.dart';
import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';

abstract class MusicCategoryDataSource {
  Future<Either<AppError, List<MusicCategoryEntity>>> getMusicCategoryData({required String type});
  Future<Either<AppError, List<MusicListEntity>>> getMusicListData({required int id});
}

class MusicCategoryDataSourceImpl extends MusicCategoryDataSource {
  final ApiClient client;

  MusicCategoryDataSourceImpl({required this.client});

  @override
  Future<Either<AppError, List<MusicCategoryEntity>>> getMusicCategoryData({required String type}) async {
    try {
      final parseData = await client.get(
        'https://dmt.oceanmtechdmt.in/api/v7/business-category/get?type=$type',
        header: ApiConstatnts().headers,
      );
      MusicCategoryModel musicCategoryModel = MusicCategoryModel.fromJson(parseData);
      if (musicCategoryModel.status == 200) {
        return Right(musicCategoryModel.data ?? []);
      } else if (musicCategoryModel.status == 404) {
        return Left(
          AppError(
            errorType: AppErrorType.data,
            errorMessage: '(Error:100 & ${musicCategoryModel.status.toString()})',
          ),
        );
      } else if (musicCategoryModel.status == 406 || musicCategoryModel.status == 405) {
        return Left(
          AppError(
            errorType: AppErrorType.api,
            errorMessage: '(Error:100 & ${musicCategoryModel.status.toString()})',
          ),
        );
      } else {
        return Left(AppError(errorType: AppErrorType.api, errorMessage: musicCategoryModel.message!));
      }
    } on UnauthorisedException catch (_) {
      return const Left(AppError(errorType: AppErrorType.unauthorised, errorMessage: "Un-Authorised"));
    } on SocketException catch (e) {
      if (e.toString().contains('ClientException with SocketException')) {
        return const Left(
          AppError(
            errorType: AppErrorType.network,
            errorMessage: "Please check your internet connection, try again!!!\n(Error:102)",
          ),
        );
      } else if (e.toString().contains('ClientException') && e.toString().contains('Software')) {
        return const Left(
          AppError(
            errorType: AppErrorType.network,
            errorMessage: "Network Change Detected, Please try again!!!\n(Error:103)",
          ),
        );
      }
      return const Left(
        AppError(
          errorType: AppErrorType.network,
          errorMessage: "Something went wrong, try again!\nSocket Problem (Error:104)",
        ),
      );
    } catch (exception) {
      return const Left(
        AppError(errorType: AppErrorType.app, errorMessage: "Something went wrong, try again!\n(Error:105)"),
      );
    }
  }

  // music List

  @override
  Future<Either<AppError, List<MusicListEntity>>> getMusicListData({required int id}) async {
    try {
      final parseData = await client.get(
        'https://dmt.oceanmtechdmt.in/api/v7/music/list/get?home_category_id=$id',
        header: ApiConstatnts().headers,
      );
      MusicListModel musicListModel = MusicListModel.fromJson(parseData);
      if (musicListModel.status == 200) {
        return Right(musicListModel.data!.data!);
      } else if (musicListModel.status == 404) {
        return Left(
          AppError(
            errorType: AppErrorType.data,
            errorMessage: '(Error:100 & ${musicListModel.message})',
          ),
        );
      } else if (musicListModel.status == 406 || musicListModel.status == 405) {
        return Left(
          AppError(
            errorType: AppErrorType.api,
            errorMessage: '(Error:100 & ${musicListModel.message})',
          ),
        );
      } else {
        return Left(AppError(errorType: AppErrorType.api, errorMessage: musicListModel.message!));
      }
    } on UnauthorisedException catch (_) {
      return const Left(AppError(errorType: AppErrorType.unauthorised, errorMessage: "Un-Authorised"));
    } on SocketException catch (e) {
      if (e.toString().contains('ClientException with SocketException')) {
        return const Left(
          AppError(
            errorType: AppErrorType.network,
            errorMessage: "Please check your internet connection, try again!!!\n(Error:102)",
          ),
        );
      } else if (e.toString().contains('ClientException') && e.toString().contains('Software')) {
        return const Left(
          AppError(
            errorType: AppErrorType.network,
            errorMessage: "Network Change Detected, Please try again!!!\n(Error:103)",
          ),
        );
      }
      return const Left(
        AppError(
          errorType: AppErrorType.network,
          errorMessage: "Something went wrong, try again!\nSocket Problem (Error:104)",
        ),
      );
    } catch (exception) {
      return const Left(
        AppError(errorType: AppErrorType.app, errorMessage: "Something went wrong, try again!\n(Error:105)"),
      );
    }
  }
}
