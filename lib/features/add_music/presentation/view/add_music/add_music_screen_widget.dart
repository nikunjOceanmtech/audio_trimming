// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:audio/di/get_it.dart';
import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/add_music/presentation/cubit/music_catgory/music_category_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/music_list/music_list_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_cubit.dart';
import 'package:audio/features/add_music/presentation/cubit/trim_cubit/trim_state.dart';
import 'package:audio/features/add_music/presentation/view/add_music/add_music_screen_view.dart';
import 'package:audio/features/add_music/presentation/view/trim/trim_screen_view.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AddMusicScreenWidget extends State<AddMusicScreen> {
  final Color allColor = Colors.blue.shade900;
  final Color subTitleColor = Colors.grey;
  late MusicCategoryCubit musicCategoryCubit;
  late MusicListCubit musicListCubit;
  late TrimCubit trimCubit;

  @override
  void initState() {
    musicCategoryCubit = getItInstance<MusicCategoryCubit>();
    musicListCubit = getItInstance<MusicListCubit>();
    trimCubit = getItInstance<TrimCubit>();
    musicCategoryCubit.loadmusicCategoryData();
    musicListCubit.loadMusicListData(id: 0);
    super.initState();
  }

  @override
  void dispose() {
    musicCategoryCubit.close();
    musicListCubit.close();
    trimCubit.close();
    super.dispose();
  }

  Widget categoryList({String? id}) {
    return BlocBuilder(
      bloc: musicCategoryCubit,
      builder: (context, state) {
        if (state is MusicCategoryLoadedState) {
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.musicCategoryList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    musicListCubit.loadMusicListData(id: state.musicCategoryList[index].id);
                    musicCategoryCubit.changeCategory(state: state, index: index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.musicCategoryList[index].isChangeCategory ? allColor : subTitleColor,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      state.musicCategoryList[index].name,
                      style: TextStyle(
                        color: state.musicCategoryList[index].isChangeCategory ? allColor : subTitleColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is MusicCategoryErrorState) {
          return Text(state.appErrorType.name);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget musicList() {
    return BlocBuilder(
      bloc: musicListCubit,
      builder: (context, state) {
        if (state is MusicListLoadedState) {
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              itemCount: state.musicList.length,
              itemBuilder: (context, index) {
                return singleAudio(state: state, musicListEntity: state.musicList[index], index: index);
              },
            ),
          );
        } else if (state is MusicListLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MusicListErrorState) {
          return Center(
            child: Text(
              state.appErrorType.name.compareTo(AppErrorType.data.name) == 0 ? " No Data Found" : state.errorMessage,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget singleAudio(
      {required MusicListLoadedState state, required int index, required MusicListEntity musicListEntity}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        width: 120.w,
        height: musicListEntity.isAudioPlay ? 140.h : 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: allColor),
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: musicListEntity.isAudioPlay
            ? state.totalDuration == 0
                ? Center(
                    child: CircularProgressIndicator(
                      color: allColor,
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        height: 60.h,
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              musicListCubit.changeIcon(state: state, index: index);
                              musicListCubit.genrateList();
                            },
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: allColor),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                musicListEntity.isAudioPlay ? Icons.pause : Icons.play_arrow,
                                color: allColor,
                              ),
                            ),
                          ),
                          title: Text(
                            musicListEntity.homeCategoryName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: allColor,
                            ),
                          ),
                          subtitle: Text(
                            "${musicListEntity.audioDuration!.inSeconds}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: subTitleColor,
                            ),
                          ),
                          trailing: Visibility(
                            visible: musicListEntity.isAudioPlay,
                            child: Container(
                              height: 25.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: allColor),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Apply",
                                style: TextStyle(color: allColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                        child: BlocBuilder<TrimCubit, TrimState>(
                          bloc: trimCubit,
                          builder: (context, trimState) {
                            if (trimState is TrimLoadedState) {
                              return WaveSlider(
                                barBackgroundColor: Colors.white,
                                barColor: allColor,
                                circleColor: Colors.red,
                                musicListCubit: musicListCubit,
                                boxColor: allColor,
                                callbackStart: (duration) {
                                  // musicListCubit.audioPlayer.stop();
                                  musicListCubit.trimMusic(state: state, start: duration, end: state.endValue);
                                },
                                duration: state.totalDuration,
                                callbackEnd: (duration) {
                                  musicListCubit.audioPlayer.stop();

                                  musicListCubit.trimMusic(state: state, end: duration, start: state.startValue);
                                },
                                backgroundColor: Colors.white,
                                heightWaveSlider: 10,
                                widthWaveSlider: ScreenUtil().screenWidth - 80,
                                // trimLoadedState: trimState,
                                // trimCubit: trimCubit,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  )
            : Container(
                height: 60.h,
                alignment: Alignment.center,
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      musicListCubit.changeIcon(state: state, index: index);
                      musicListCubit.genrateList();
                    },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: allColor),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        musicListEntity.isAudioPlay ? Icons.pause : Icons.play_arrow,
                        color: allColor,
                      ),
                    ),
                  ),
                  title: Text(
                    musicListEntity.homeCategoryName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: allColor,
                    ),
                  ),
                  subtitle: Text(
                    musicListEntity.audioDuration!.toString().substring(2, 7),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: subTitleColor,
                    ),
                  ),
                  trailing: Visibility(
                    visible: musicListEntity.isAudioPlay,
                    child: Container(
                      height: 25.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: allColor),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Apply",
                        style: TextStyle(color: allColor),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
