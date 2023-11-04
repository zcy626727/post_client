import 'package:flutter/material.dart';
import 'package:post_client/constant/media.dart';
import 'package:post_client/service/media/album_service.dart';

import '../../../domain/task/single_upload_task.dart';
import '../../../enums/upload_task.dart';
import '../../../service/media/file_url_service.dart';
import '../../component/input/common_dropdown.dart';
import '../../component/input/common_info_card.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class AlbumEditPage extends StatefulWidget {
  const AlbumEditPage({super.key});

  @override
  State<AlbumEditPage> createState() => _AlbumEditPageState();
}

class _AlbumEditPageState extends State<AlbumEditPage> {
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _isPublic = false;
  (int, String) _selectedMedia = MediaType.option[0];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
          "创建合集",
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
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  //执行验证
                  if (formKey.currentState!.validate()) {
                    try {
                      if (coverUploadImage.status != null && coverUploadImage.status != UploadTaskStatus.finished) {
                        ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                        return;
                      }
                      var (_, staticUrl) = await FileUrlService.genGetFileUrl(coverUploadImage.fileId!);

                      var _ = await AlbumService.createAlbum(
                        titleController.text,
                        introductionController.text,
                        _selectedMedia.$1,
                        staticUrl,
                      );

                      if (mounted) Navigator.pop(context);
                    } on Exception catch (e) {
                      ShowSnackBar.exception(context: context, e: e, defaultValue: "创建文件失败");
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
              options: MediaType.option,
            ),
          ],
        ),
      ),
    );
  }
}
