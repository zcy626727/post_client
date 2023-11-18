import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:post_client/domain/task/single_upload_task.dart';
import 'package:post_client/model/media/album.dart';
import 'package:post_client/model/media/video.dart';
import 'package:post_client/service/media/video_service.dart';
import 'package:post_client/view/component/media/upload/video_upload_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/media/album_service.dart';
import '../../component/input/media_info_card.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class VideoEditPage extends StatefulWidget {
  const VideoEditPage({super.key, this.video, this.onUpdateMedia});

  final Video? video;
  final Function(Video)? onUpdateMedia;

  @override
  State<VideoEditPage> createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {
  late Future _futureBuilderFuture;

  MultipartUploadTask videoUploadTask = MultipartUploadTask();
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _withPost = true;
  Album? _selectedAlbum;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();

    if (widget.video != null && widget.video!.id != null) {
      titleController.text = widget.video!.title ?? "";
      introductionController.text = widget.video!.introduction ?? "";
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = MediaType.gallery;
      coverUploadImage.coverUrl = widget.video!.coverUrl;
      videoUploadTask.fileId = widget.video!.fileId;
      videoUploadTask.status = UploadTaskStatus.finished;
    }
  }

  Future getData() async {
    return Future.wait([getAlbum()]);
  }

  Future<void> getAlbum() async {
    if (widget.video == null || widget.video!.albumId == null) return;
    try {
      _selectedAlbum = await AlbumService.getAlbumById(widget.video!.albumId!);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: AppBar(
              toolbarHeight: 50,
              centerTitle: true,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              leading: IconButton(
                splashRadius: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: colorScheme.onBackground,
                ),
              ),
              title: Text(
                "编辑视频",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 30,
                  width: 70,
                  child: Center(
                    child: CommonActionOneButton(
                      title: widget.video != null ? "保存" : "发布",
                      height: 30,
                      onTap: () async {
                        formKey.currentState?.save();
                        //执行验证
                        if (formKey.currentState!.validate()) {
                          try {
                            if (videoUploadTask.fileId == null) {
                              ShowSnackBar.error(context: context, message: "还未上传视频");
                              return;
                            }
                            if (videoUploadTask.status != UploadTaskStatus.finished) {
                              ShowSnackBar.error(context: context, message: "视频未上传完成，请稍后");
                              return;
                            }
                            if (coverUploadImage.status != UploadTaskStatus.finished) {
                              ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                              return;
                            }

                            if (widget.video != null) {
                              //保存
                              String? newTitle;
                              String? newIntroduction;
                              String? newCoverUrl;
                              int? newFileId;
                              bool isAlbumChange = false;

                              Video media = widget.video!;

                              if (titleController.value.text != widget.video!.title) {
                                newTitle = titleController.value.text;
                                media.title = newTitle;
                              }
                              if (introductionController.value.text != widget.video!.introduction) {
                                newIntroduction = introductionController.value.text;
                                media.introduction = newIntroduction;
                              }
                              if (coverUploadImage.coverUrl != widget.video!.coverUrl) {
                                newCoverUrl = coverUploadImage.coverUrl;
                                media.coverUrl = newCoverUrl;
                              }
                              if (videoUploadTask.fileId! != widget.video!.fileId) {
                                newFileId = videoUploadTask.fileId!;
                                media.fileId = newFileId;
                              }
                              if (widget.video!.albumId != _selectedAlbum?.id) {
                                widget.video!.albumId = _selectedAlbum?.id;
                                isAlbumChange = true;
                              }
                              if (newTitle == null && newIntroduction == null && newCoverUrl == null && newFileId == null && !isAlbumChange) throw const FormatException("未做修改");

                              await VideoService.updateVideoData(
                                mediaId: widget.video!.id!,
                                title: newTitle,
                                introduction: newIntroduction,
                                fileId: newFileId,
                                coverUrl: newCoverUrl,
                                albumId: _selectedAlbum?.id,
                              );
                              if (widget.onUpdateMedia != null) {
                                widget.onUpdateMedia!(media);
                              }
                            } else {
                              //新建
                              var video = await VideoService.createVideo(
                                title: titleController.value.text,
                                introduction: introductionController.value.text,
                                fileId: videoUploadTask.fileId!,
                                coverUrl: coverUploadImage.coverUrl,
                                withPost: _withPost,
                                albumId: _selectedAlbum?.id,
                              );
                            }

                            if (mounted) Navigator.pop(context);
                          } on Exception catch (e) {
                            if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
                          }
                          //加载
                          setState(() {});
                        }
                      },
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                    ),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    VideoUploadCard(key: ValueKey(videoUploadTask.srcPath), task: videoUploadTask),
                    MediaInfoCard(
                      coverUploadImage: coverUploadImage,
                      titleController: titleController,
                      introductionController: introductionController,
                      onWithPost: widget.video != null
                          ? null
                          : (withPost) {
                              _withPost = withPost;
                            },
                      onSelectedAlbum: (album) {
                        _selectedAlbum = album;
                      },
                      onClearAlbum: () {
                        _selectedAlbum = null;
                      },
                      mediaType: MediaType.video,
                      initAlbum: _selectedAlbum,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: colorScheme.background,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }
      },
    );
  }
}
