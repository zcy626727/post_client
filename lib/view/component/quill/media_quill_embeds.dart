import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:post_client/view/component/quill/embed/Image_embed.dart';
import 'package:post_client/view/component/quill/embed/mention_embed.dart';
import 'package:post_client/view/component/quill/embed/audio_embed.dart';
import 'package:post_client/view/component/quill/embed/video_embed.dart';

class ArticleQuillEmbeds {
  static List<EmbedBuilder> builders({void Function(GlobalKey videoContainerKey)? onVideoInit}) => [
        //builder
        ImageEmbedBuilder(),
        MyVideoEmbedBuilder(),
        MyAudioEmbedBuilder(),
      ];

  static List<EmbedButtonBuilder> buttons({
    bool showImageButton = true,
    bool showVideoButton = true,
    bool showAudioButton = true,
  }) {
    return [
      (controller, toolbarIconSize, iconTheme, dialogTheme) => VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
      if (showImageButton)
        (controller, toolbarIconSize, iconTheme, dialogTheme) => MyImageEmbedButton(
              controller: controller,
              iconTheme: iconTheme,
              iconSize: toolbarIconSize,
              dialogTheme: dialogTheme,
            ),
      if (showVideoButton)
        (controller, toolbarIconSize, iconTheme, dialogTheme) => MyVideoEmbedButton(
              controller: controller,
              iconTheme: iconTheme,
              iconSize: toolbarIconSize,
              dialogTheme: dialogTheme,
            ),
      if (showAudioButton)
        (controller, toolbarIconSize, iconTheme, dialogTheme) => MyAudioEmbedButton(
              controller: controller,
              iconTheme: iconTheme,
              iconSize: toolbarIconSize,
              dialogTheme: dialogTheme,
            ),
    ];
  }
}

class PostQuillEmbeds {
  static List<EmbedBuilder> builders({void Function(GlobalKey videoContainerKey)? onVideoInit}) => [
        //builder
        MyMentionEmbedBuilder(),
      ];

  static List<EmbedButtonBuilder> buttons({
    bool showAtButton = true,
  }) {
    return [
      (controller, toolbarIconSize, iconTheme, dialogTheme) => VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
      if (showAtButton)
        (controller, toolbarIconSize, iconTheme, dialogTheme) => MyAtEmbedButton(
              controller: controller,
              iconTheme: iconTheme,
              iconSize: toolbarIconSize,
              dialogTheme: dialogTheme,
            ),
    ];
  }
}
