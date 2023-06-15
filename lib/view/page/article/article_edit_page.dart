import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../component/quill/quill_editor.dart';
import '../../component/quill/quill_tool_bar.dart';
import '../../widget/button/common_action_one_button.dart';

class ArticleEditPage extends StatefulWidget {
  const ArticleEditPage({Key? key}) : super(key: key);

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  final QuillController _controller = QuillController.basic();

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            height: 30,
            width: 70,
            child: Center(
              child: CommonActionOneButton(
                title: "发布",
                height: 30,
                onTap: () {
                  print('1');
                  var delta = _controller.document.toDelta().toList();
                  for (var d in delta) {
                    var data = d.data;
                    if (data is Map<String, dynamic>) {
                      var data2 = data['at'];
                      if (data2 != null) {
                        print("找到一个：$data2");
                      }
                    }
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
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: ArticleQuillEditor(
                  controller: _controller,
                  focusNode: focusNode,
                ),
              ),
            ),
            ArticleQuillToolBar(controller: _controller),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
