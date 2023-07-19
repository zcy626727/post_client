import '../../../model/message_favorites.dart';
import '../message_http_config.dart';

class MessageFavoritesApi {
  static Future<MessageFavorites> createMessageFavorites(
    String title,
    String introduction,
    String? coverUrl,
    int messageType,
  ) async {
    var r = await MessageHttpConfig.dio.post(
      "/messageFavorites/createMessageFavorites",
      data: {
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "messageType": messageType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return MessageFavorites.fromJson(r.data['messageFavorites']);
  }

  static Future<void> deleteUserMessageFavoritesById(
    String favoritesId,
  ) async {
    await MessageHttpConfig.dio.post(
      "/messageFavorites/deleteUserMessageFavoritesById",
      data: {
        "favoritesId": favoritesId,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> addMessageToFavorites(
    String favoritesId,
    String messageId,
    int messageType,
  ) async {
    await MessageHttpConfig.dio.post(
      "/messageFavorites/addMessageToFavorites",
      data: {
        "favoritesId": favoritesId,
        "messageId": messageId,
        "messageType": messageType,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<MessageFavorites>> getUserMessageFavoritesList(
    int messageType,
    int pageIndex,
    int pageSize,
  ) async {
    var r = await MessageHttpConfig.dio.get(
      "/messageFavorites/getUserMessageFavoritesList",
      queryParameters: {
        "messageType": messageType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": true,
      }),
    );

    List<MessageFavorites> favoritesList = [];
    for (var favoritesJson in r.data['messageFavoritesList']) {
      var favorites = MessageFavorites.fromJson(favoritesJson);
      favoritesList.add(favorites);
    }
    return favoritesList;
  }
}
