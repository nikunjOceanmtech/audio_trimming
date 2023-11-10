// ignore_for_file: overridden_fields, annotate_overrides, must_be_immutable

import 'package:audio/features/add_music/domain/entities/entity/add_music_entity.dart';

class MusicCategoryModel {
  int? status;
  bool? success;
  String? message;
  List<MusicCategoryList>? data;

  MusicCategoryModel({this.status, this.success, this.message, this.data});

  MusicCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MusicCategoryList>[];
      json['data'].forEach((v) {
        data!.add(MusicCategoryList.fromJson(v));
      });
    }
  }
}

class MusicCategoryList extends MusicCategoryEntity {
  final int id;
  final String name;
  final String image;
  bool isChangeCategory = false;

  MusicCategoryList({
    required this.id,
    required this.name,
    required this.image,
    required this.isChangeCategory,
  }) : super(
          id: id,
          image: image,
          name: name,
          isChangeCategory: isChangeCategory,
        );

  factory MusicCategoryList.fromJson(Map<String, dynamic> json) {
    return MusicCategoryList(
      isChangeCategory: false,
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
