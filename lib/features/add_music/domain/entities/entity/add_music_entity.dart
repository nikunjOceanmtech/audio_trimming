// ignore_for_file: must_be_immutable
//
import 'package:equatable/equatable.dart';

class MusicCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  bool isChangeCategory;

  MusicCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.isChangeCategory,
  });

  @override
  List<Object?> get props => [id, name, image, isChangeCategory];
}

class MusicListEntity extends Equatable {
  final int id;
  final String homeCategoryId;
  final String homeCategoryName;
  final String musicName;
  final String musicFile;
  Duration? audioDuration;
  bool isAudioPlay = false;
  String? path;

  MusicListEntity({
    required this.id,
    required this.homeCategoryId,
    required this.homeCategoryName,
    required this.musicName,
    required this.musicFile,
    required this.isAudioPlay,
    required this.audioDuration,
    this.path,
  });

  @override
  List<Object?> get props => [id, homeCategoryId, homeCategoryName, musicName, musicFile, isAudioPlay, path];
}
