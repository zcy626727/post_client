import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ArticleEditPage extends StatefulWidget {
  const ArticleEditPage({Key? key}) : super(key: key);

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  final QuillController _controller = QuillController.basic();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QuillToolbar.basic(controller: _controller),
          Container(
            height: 100,
            child: Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          ),
        ],
      ),
    );
  }
}
