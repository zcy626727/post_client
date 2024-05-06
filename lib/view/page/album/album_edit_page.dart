import 'package:flutter/material.dart';
import 'package:post_client/model/post/album.dart';

import '../../../constant/source.dart';
import '../../../domain/task/single_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/post/album_service.dart';
import '../../component/input/common_dropdown.dart';
import '../../component/input/common_info_card.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class AlbumEditPage extends StatefulWidget {
  const AlbumEditPage({super.key, this.album, this.onUpdate});

  final Album? album;
  final Function(Album)? onUpdate;

  @override
  State<AlbumEditPage> createState() => _AlbumEditPageState();
}

class _AlbumEditPageState extends State<AlbumEditPage> {
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  (int, String) _selectedMedia = SourceType.mediaOption[0];

  @override
  void initState() {
    super.initState();
    if (widget.album != null && widget.album!.id != null) {
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = SourceType.gallery;
      coverUploadImage.coverUrl = widget.album!.coverUrl;
      titleController.text = widget.album!.title ?? "";
      introductionController.text = widget.album!.introduction ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "编辑合集",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: "发布",
                height: 35,
                onTap: () async {
                  formKey.currentState?.save();
                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      if (coverUploadImage.status != null && coverUploadImage.status != UploadTaskStatus.finished) {
                        ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                        return;
                      }

                      if (widget.album != null) {
                        //保存

                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;

                        if (titleController.value.text != widget.album!.title) {
                          newTitle = titleController.value.text;
                          widget.album!.title = newTitle;
                        }
                        if (introductionController.value.text != widget.album!.introduction) {
                          newIntroduction = introductionController.value.text;
                          widget.album!.introduction = newIntroduction;
                        }
                        if (coverUploadImage.coverUrl != widget.album!.coverUrl) {
                          newCoverUrl = coverUploadImage.coverUrl;
                          widget.album!.coverUrl = newCoverUrl;
                        }
                        if (newTitle == null && newIntroduction == null && newCoverUrl == null) throw const FormatException("未做修改");
                        await AlbumService.updateAlbumInfo(
                          albumId: widget.album!.id!,
                          title: newTitle,
                          introduction: newIntroduction,
                          coverUrl: newCoverUrl,
                        );
                        if (widget.onUpdate != null) {
                          widget.onUpdate!(widget.album!);
                        }
                      } else {
                        var _ = await AlbumService.createAlbum(
                          titleController.text,
                          introductionController.text,
                          _selectedMedia.$1,
                          coverUploadImage.coverUrl,
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
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            CommonInfoCard(
              coverUploadImage: coverUploadImage,
              titleController: titleController,
              introductionController: introductionController,
            ),
            // CommonCheckBox(
            //   value: _isPublic,
            //   title: "公开",
            //   onChanged: (bool? value) {
            //     setState(() {
            //       _isPublic = value!;
            //     });
            //   },
            // ),
            CommonDropdown(
              title: "类型",
              onChanged: (value) {
                setState(() {
                  _selectedMedia = value;
                });
              },
              options: SourceType.mediaOption,
            ),
          ],
        ),
      ),
    );
  }
}
