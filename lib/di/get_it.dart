import 'package:audio/core/api_client.dart';
import 'package:audio/features/add_music/data/datasources/add_music_data_source.dart';
import 'package:audio/features/add_music/data/repositories/add_music_repositories_impl.dart';
import 'package:audio/features/add_music/domain/repositories/add_music_repositories.dart';
import 'package:audio/features/add_music/domain/usecases/add_music_usecases.dart';
import 'package:audio/features/add_music/presentation/cubit/music_catgory/music_category_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/music_list/music_list_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());
  getItInstance.registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  //Data source Dependency
  getItInstance
      .registerLazySingleton<MusicCategoryDataSource>(() => MusicCategoryDataSourceImpl(client: getItInstance()));

  //Data Repository Dependency
  getItInstance.registerLazySingleton<MusicCategoryRepositories>(
      () => MusicCategoryRepositoriedImpl(musicCategoryDataSource: getItInstance()));

  //Usecase Dependency
  getItInstance.registerLazySingleton<MusicCategoryUseCase>(
    () => MusicCategoryUseCase(musicCategoryRepositories: getItInstance()),
  );
  getItInstance.registerLazySingleton<MusicListUseCase>(
    () => MusicListUseCase(musicCategoryRepositories: getItInstance()),
  );

  //Cubit Dependency
  getItInstance.registerFactory<MusicCategoryCubit>(() => MusicCategoryCubit(musicCategoryUseCase: getItInstance()));
  getItInstance.registerFactory<MusicListCubit>(() => MusicListCubit(musicListUseCase: getItInstance()));
  getItInstance.registerFactory<TrimCubit>(() => TrimCubit());

  //Theme Dependency
}
