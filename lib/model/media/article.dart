import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user/user.dart';

import 'media.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Media {
  String? content;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Article();

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  void copyArticle(Article article) {
    super.copy(article);
    content = article.content;
    user = article.user;
  }
}
