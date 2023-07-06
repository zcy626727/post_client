import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/user.dart';

part 'gallery.g.dart';

@JsonSerializable()
class Gallery extends Media{
  String? id;
  int? userId;
  String? title;
  String? introduction;
  DateTime? createTime;
  List<int>? fileIdList;
  List<String>? thumbnailUrlList;
  String? coverUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Gallery();

  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);
}