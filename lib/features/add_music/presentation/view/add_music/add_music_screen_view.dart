import 'package:audio/features/add_music/presentation/cubit/music_list/music_list_cubit.dart';
import 'package:audio/features/add_music/presentation/view/add_music/add_music_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddMusicScreen extends StatefulWidget {
  const AddMusicScreen({super.key});

  @override
  State<AddMusicScreen> createState() => _AddMusicScreenState();
}

class _AddMusicScreenState extends AddMusicScreenWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back, size: 25.h, color: allColor),
                  SizedBox(width: 15.w),
                  Text("Add Music", style: TextStyle(color: allColor, fontSize: 25.sp))
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: subTitleColor.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    Icon(Icons.search, size: 20.h, color: allColor),
                    SizedBox(width: 10.w),
                    Text("Search", style: TextStyle(color: allColor, fontSize: 16.sp))
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              categoryList(),
              SizedBox(height: 10.h),
              BlocBuilder(
                bloc: musicListCubit,
                builder: (context, state) {
                  if (state is MusicListLoadedState) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            musicListCubit.musicPicker(state: state);
                          },
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: allColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            alignment: Alignment.center,
                            child: const Text("Upload"),
                          ),
                        ),
                        // Container(
                        //   width: ScreenUtil().screenWidth,
                        //   child: singleAudio(
                        //     state: state,
                        //     index: 0,
                        //     musicListEntity: MusicListEntity(
                        //       id: 0,
                        //       homeCategoryId: '',
                        //       homeCategoryName: 'homeCategoryName',
                        //       musicName: 'musicName',
                        //       musicFile: 'musicFile',
                        //       isAudioPlay: false,
                        //       audioDuration: Duration(
                        //         seconds: state.totalDuration.toInt(),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: 10.h),
              Expanded(child: musicList()),
            ],
          ),
        ),
      ),
    );
  }
}
