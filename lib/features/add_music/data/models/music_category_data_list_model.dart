// ignore_for_file: overridden_fields, annotate_overrides, must_be_immutable

import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';

class MusicListModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  MusicListModel({this.status, this.success, this.message, this.data});

  MusicListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? currentPage;
  List<MusicListData>? data;
  int? from;
  int? lastPage;
  String? nextPageUrl;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.from,
    this.lastPage,
    this.nextPageUrl,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <MusicListData>[];
      json['data'].forEach((v) {
        data!.add(MusicListData.fromJson(v));
      });
    }
    from = json['from'];
    lastPage = json['last_page'];
    nextPageUrl = json['next_page_url'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class MusicListData extends MusicListEntity {
  final int id;
  final String homeCategoryId;
  final String homeCategoryName;
  final String musicName;
  final String musicFile;
  final Duration audioDuration;
  bool isAudioPlay = false;
  String? path;

  MusicListData({
    required this.id,
    required this.homeCategoryId,
    required this.homeCategoryName,
    required this.musicName,
    required this.musicFile,
    required this.isAudioPlay,
    required this.audioDuration,
    this.path,
  }) : super(
            id: id,
            homeCategoryId: homeCategoryId,
            homeCategoryName: homeCategoryName,
            musicName: musicName,
            musicFile: musicFile,
            isAudioPlay: false,
            audioDuration: audioDuration,
            path: path);

  factory MusicListData.fromJson(Map<String, dynamic> json) {
    return MusicListData(
      id: json['id'],
      homeCategoryId: json['home_category_id'],
      homeCategoryName: json['home_category_name'],
      musicName: json['music_name'],
      musicFile: json['music_file'],
      isAudioPlay: false,
      audioDuration: Duration.zero,
    );
  }
}
