import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/media/article.dart';
import 'package:post_client/view/component/input/common_info_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/upload_media_task.dart';
import '../../../service/media/article_service.dart';
import '../../component/quill/quill_editor.dart';
import '../../component/quill/quill_tool_bar.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class ArticleEditPage extends StatefulWidget {
  const ArticleEditPage({Key? key, this.article, this.onUpdateMedia}) : super(key: key);
  final Article? article;
  final Function(Article)? onUpdateMedia;

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  final QuillController _contentController = QuillController.basic();
  final FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  UploadMediaTask coverUploadImage = UploadMediaTask();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _withPost = true;

  bool isSave = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null && widget.article!.id != null) {
      isSave = true;
      titleController.text = widget.article!.title ?? "";
      introductionController.text = widget.article!.introduction ?? "";
      coverUploadImage.staticUrl = widget.article!.coverUrl;
      coverUploadImage.status = UploadTaskStatus.finished.index;
      coverUploadImage.mediaType = MediaType.gallery;
      _contentController.document = Document.fromJson(json.decode(widget.article!.content ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();

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
          "编辑文章",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: isSave ? "保存" : "发布",
                height: 30,
                onTap: () async {
                  formKey.currentState?.save();
                  //执行验证

                  if (formKey.currentState!.validate()) {
                    try {
                      var content = jsonEncode(_contentController.document.toDelta().toJson());
                      if (content.isEmpty) {
                        ShowSnackBar.error(context: context, message: "内容为空");
                        return;
                      }
                      String? coverUrl;
                      if (coverUploadImage.status != null && coverUploadImage.status != UploadTaskStatus.finished.index) {
                        ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                        return;
                      }
                      coverUrl = coverUploadImage.staticUrl;

                      if (isSave) {
                        //保存
                        String? newTitle;
                        String? newIntroduction;
                        String? newCoverUrl;
                        String? newContent;
                        Article media = widget.article!;

                        if (titleController.value.text != widget.article!.title) {
                          newTitle = titleController.value.text;
                          media.title = newTitle;
                        }
                        if (introductionController.value.text != widget.article!.introduction) {
                          newIntroduction = introductionController.value.text;
                          media.introduction = newIntroduction;
                        }
                        if (content != widget.article!.content) {
                          newContent = content;
                          media.content = newContent;
                        }
                        if (coverUrl != widget.article!.coverUrl) {
                          newCoverUrl = coverUrl;
                          media.coverUrl = newCoverUrl;
                        }
                        await ArticleService.updateArticleData(widget.article!.id!, newTitle, newIntroduction, newContent, newCoverUrl);
                        if (widget.onUpdateMedia != null) {
                          widget.onUpdateMedia!(media);
                        }
                      } else {
                        //新建
                        var article = await ArticleService.createArticle(
                          titleController.value.text,
                          introductionController.value.text,
                          content,
                          coverUrl,
                          _withPost,
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
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CommonInfoCard(
                        coverUploadImage: coverUploadImage,
                        titleController: titleController,
                        introductionController: introductionController,
                      ),
                      if (!isSave)
                        Container(
                          color: colorScheme.surface,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          margin: const EdgeInsets.only(top: 2, bottom: 2),
                          child: ListTile(
                            leading: Text(
                              '同时发布动态',
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            trailing: Checkbox(
                              fillColor: MaterialStateProperty.all(_withPost ? colorScheme.primary : colorScheme.onSurface),
                              value: _withPost,
                              onChanged: (bool? value) {
                                setState(() {
                                  _withPost = value!;
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ArticleQuillEditor(
                      controller: _contentController,
                      focusNode: focusNode,
                    ),
                  ),
                ),
                ArticleQuillToolBar(controller: _contentController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
