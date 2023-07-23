import '../model/user/user.dart';

class FavoritesSource{
  String? coverUrl;
  String? title;
  int? sourceType;
  String? sourceId;
  User? user;

  FavoritesSource(this.coverUrl, this.title, this.sourceType, this.sourceId, this.user);
}