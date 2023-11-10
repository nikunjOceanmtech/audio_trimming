// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:audio/features/add_music/data/models/music_category_data_list_model.dart';
import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';
import 'package:audio/features/add_music/domain/usecases/add_music_usecases.dart';
import 'package:audio/features/shared/domain/entities/app_error.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
part 'music_list_state.dart';

class MusicListCubit extends Cubit<MusicListState> {
  final MusicListUseCase musicListUseCase;
  MusicListCubit({required this.musicListUseCase}) : super(MusicListLoadingState());

  // AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  List<int> bars = [];

  Future<void> loadMusicListData({required int id}) async {
    Either<AppError, List<MusicListEntity>> response = await musicListUseCase(id);

    response.fold(
      (l) {
        emit(MusicListErrorState(appErrorType: l.errorType, errorMessage: l.errorMessage));
      },
      (r) async {
        // l1 = await getMusicDurations(music: r);

        emit(
          MusicListLoadedState(
            musicList: r,
            random: Random().nextDouble(),
            totalDuration: 100,
            startValue: 0,
            endValue: 1000,
          ),
        );
      },
    );
  }

  // Future<void> getAudioDuraton({required List<MusicListEntity> music}) async {
  //   for (var musicUrl in music) {
  //     var duration = await audioPlayer.setUrl(musicUrl.musicFile);
  //     musicUrl.audioDuration = duration;
  //   }

  //   print(music[0].audioDuration);
  // }

  Future<void> changeIcon({required MusicListLoadedState state, required int index}) async {
    bars.clear();
    genrateList();
    Duration? totalDuration;
    if (state.musicList[index].isAudioPlay != true) {
      audioPlayer.stop();
      emit(state.copyWith(totalDuration: 0, startValue: 0, endValue: 0, random: Random().nextDouble()));
      for (var element in state.musicList) {
        element.isAudioPlay = false;
      }
      state.musicList[index].isAudioPlay = !state.musicList[index].isAudioPlay;

      if (state.musicList[index].path != null) {
        totalDuration = await audioPlayer.setFilePath(state.musicList[index].path!);
      } else {
        totalDuration = await audioPlayer.setUrl(state.musicList[index].musicFile);
      }
      emit(state.copyWith(
        musicList: state.musicList,
        totalDuration: totalDuration?.inSeconds.toDouble(),
        random: Random().nextDouble(),
        endValue: totalDuration!.inSeconds.toDouble(),
        startValue: 0,
      ));
      playMusic();
    } else {
      audioPlayer.stop();
      for (var element in state.musicList) {
        element.isAudioPlay = false;
      }
      emit(state.copyWith(
        musicList: state.musicList,
        totalDuration: 0,
        startValue: 0,
        endValue: 0,
        random: Random().nextDouble(),
      ));
    }
  }

  void genrateList() {
    List.generate(28, (index) {
      bars.add(Random().nextInt(50));
    });
  }

  Future<void> trimMusic({required MusicListLoadedState state, double? start, double? end}) async {
    await audioPlayer.setClip(start: Duration(seconds: start!.toInt()), end: Duration(seconds: end!.toInt()));
    // Future.delayed(
    //   Duration(seconds: 1),
    //   () => ,
    // );
    playMusic();
    emit(state.copyWith(startValue: start, endValue: end));
  }

  Future<void> musicPicker({required MusicListLoadedState state}) async {
    audioPlayer.stop();
    double totalDuration = 0;
    FilePickerResult? filePicker = await FilePicker.platform.pickFiles(type: FileType.audio);

    String? filePath = filePicker!.files.first.path;

    List<MusicListEntity> musicList = state.musicList;
    for (var e in musicList) {
      if (e.isAudioPlay == true) {
        e.isAudioPlay = false;
        audioPlayer.stop();
      }
    }
    if (musicList[0].path == null) {
      musicList.insert(
        0,
        MusicListData(
          id: 0,
          homeCategoryId: "0",
          homeCategoryName: 'File',
          musicName: filePicker.files.first.name,
          musicFile: 'musicFile',
          isAudioPlay: true,
          audioDuration: Duration.zero,
          path: filePath,
        ),
      );
    } else {
      musicList[0] = MusicListData(
        id: 0,
        homeCategoryId: "0",
        homeCategoryName: 'File',
        musicName: filePicker.files.first.name,
        musicFile: 'musicFile',
        isAudioPlay: true,
        audioDuration: Duration.zero,
        path: filePath,
      );
    }
    genrateList();
    audioPlayer.setFilePath(filePath!);
    emit(state.copyWith(musicList: musicList, random: Random().nextDouble()));
    playMusic();
  }

  Future<void> playMusic() async {
    await audioPlayer.play();
  }
}
