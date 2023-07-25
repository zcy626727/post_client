import 'package:flutter/material.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/model/favorites.dart';
import 'package:post_client/view/component/input/common_dropdown.dart';
import 'package:post_client/view/component/input/common_info_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/upload_media_task.dart';
import '../../../service/favorites_service.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class FavoritesEditPage extends StatefulWidget {
  const FavoritesEditPage({super.key, this.favorites, this.onUpdate});

  final Favorites? favorites;
  final Function(Favorites)? onUpdate;

  @override
  State<FavoritesEditPage> createState() => _FavoritesEditPageState();
}

class _FavoritesEditPageState extends State<FavoritesEditPage> {
  UploadMediaTask coverUploadImage = UploadMediaTask();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final introductionController = TextEditingController();
  (int, String) _selectedSource = SourceType.option[0];
  bool isSave = false;

  @override
  void initState() {
    super.initState();
    if (widget.favorites != null) {
      isSave = true;
      titleController.text = widget.favorites!.title ?? "";
      introductionController.text = widget.favorites!.introduction ?? "";
      coverUploadImage.staticUrl = widget.favorites!.coverUrl;
      coverUploadImage.status = UploadTaskStatus.finished.index;
      coverUploadImage.mediaType = MediaType.gallery;
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
          "编辑收藏夹",
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
                      if (coverUploadImage.status != null && coverUploadImage.status != UploadTaskStatus.finished.index) {
                        ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                        return;
                      }
                      if (isSave) {
                        //保存
                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;
                        int? newFileId;

                        Favorites f = widget.favorites!;

                        if (titleController.value.text != widget.favorites!.title) {
                          newTitle = titleController.value.text;
                          f.title = newTitle;
                        }
                        if (introductionController.value.text != widget.favorites!.introduction) {
                          newIntroduction = introductionController.value.text;
                          f.introduction = newIntroduction;
                        }
                        if (coverUploadImage.staticUrl != widget.favorites!.coverUrl) {
                          newCoverUrl = coverUploadImage.staticUrl;
                          f.coverUrl = newCoverUrl;
                        }
                        await FavoritesService.updateFavoritesData(widget.favorites!.id!, widget.favorites!.sourceType!, newTitle, newIntroduction, newCoverUrl);
                        if (widget.onUpdate != null) {
                          await widget.onUpdate!(f);
                        }
                      } else {
                        //新建
                        var favorites = await FavoritesService.createFavorites(
                          titleController.text,
                          introductionController.text,
                          coverUploadImage.staticUrl,
                          _selectedSource.$1,
                        );
                      }

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
            if (!isSave)
              CommonDropdown(
                title: "类型",
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                  });
                },
                options: SourceType.option,
              ),
          ],
        ),
      ),
    );
  }
}
