import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:post_client/model/media/album.dart';
import 'package:post_client/model/media/article.dart';
import 'package:post_client/service/media/album_service.dart';
import 'package:post_client/view/component/input/media_info_card.dart';

import '../../../constant/media.dart';
import '../../../domain/task/single_upload_task.dart';
import '../../../enums/upload_task.dart';
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
  late Future _futureBuilderFuture;

  final QuillController _contentController = QuillController.basic();
  final FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  SingleUploadTask coverUploadImage = SingleUploadTask();
  final titleController = TextEditingController();
  final introductionController = TextEditingController(text: "");
  bool _withPost = true;
  Album? _selectedAlbum;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();

    if (widget.article != null && widget.article!.id != null) {
      titleController.text = widget.article!.title ?? "";
      introductionController.text = widget.article!.introduction ?? "";
      coverUploadImage.status = UploadTaskStatus.finished;
      coverUploadImage.mediaType = MediaType.gallery;
      coverUploadImage.coverUrl = widget.article!.coverUrl;
      if (widget.article!.content != null && widget.article!.content!.isNotEmpty) {
        _contentController.document = Document.fromJson(json.decode(widget.article!.content!));
      }
    }
  }

  Future getData() async {
    return Future.wait([getAlbum()]);
  }

  Future<void> getAlbum() async {
    if (widget.article == null || widget.article!.albumId == null) return;
    try {
      _selectedAlbum = await AlbumService.getAlbumById(widget.article!.albumId!);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();

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
                      title: widget.article != null ? "保存" : "发布",
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
                            if (coverUploadImage.status != UploadTaskStatus.finished) {
                              ShowSnackBar.error(context: context, message: "封面未上传完成，请稍后");
                              return;
                            }

                            if (widget.article != null) {
                              //保存
                              String? newTitle;
                              String? newIntroduction;
                              String? newCoverUrl;
                              String? newContent;
                              bool isAlbumChange = false;

                              if (titleController.value.text != widget.article!.title) {
                                newTitle = titleController.value.text;
                                widget.article!.title = newTitle;
                              }
                              if (introductionController.value.text != widget.article!.introduction) {
                                newIntroduction = introductionController.value.text;
                                widget.article!.introduction = newIntroduction;
                              }
                              if (content != widget.article!.content) {
                                newContent = content;
                                widget.article!.content = newContent;
                              }
                              if (widget.article!.coverUrl != coverUploadImage.coverUrl) {
                                newCoverUrl = coverUploadImage.coverUrl;
                                widget.article!.coverUrl = newCoverUrl;
                              }

                              if (widget.article!.albumId != _selectedAlbum?.id) {
                                widget.article!.albumId = _selectedAlbum?.id;
                                isAlbumChange = true;
                              }
                              if (newTitle == null && newIntroduction == null && newCoverUrl == null && newContent == null && !isAlbumChange) throw const FormatException("未做修改");

                              await ArticleService.updateArticleData(
                                mediaId: widget.article!.id!,
                                title: newTitle,
                                introduction: newIntroduction,
                                content: newContent,
                                coverUrl: newCoverUrl,
                                albumId: _selectedAlbum?.id,
                              );
                              if (widget.onUpdateMedia != null) {
                                widget.onUpdateMedia!(widget.article!);
                              }
                            } else {
                              //新建
                              var _ = await ArticleService.createArticle(
                                title: titleController.value.text,
                                introduction: introductionController.value.text,
                                content: content,
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
            body: Form(
              key: formKey,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverToBoxAdapter(
                        child: MediaInfoCard(
                          coverUploadImage: coverUploadImage,
                          titleController: titleController,
                          introductionController: introductionController,
                          onWithPost: widget.article != null
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
                          mediaType: MediaType.article,
                          initAlbum: _selectedAlbum,
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
