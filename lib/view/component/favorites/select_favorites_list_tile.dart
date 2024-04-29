import 'package:flutter/material.dart';
import 'package:post_client/model/post/favorites.dart';

class SelectFavoritesListTile extends StatefulWidget {
  const SelectFavoritesListTile({
    super.key,
    required this.favorites,
    required this.sourceId,
    required this.onChanged,
    required this.sourceInFavoritesIdMap,
  });

  final Favorites favorites;
  final Map<String, bool> sourceInFavoritesIdMap;

  //当前资源的id
  final String sourceId;

  //favorite中包括的资源id
  final Function(bool) onChanged;

  @override
  State<SelectFavoritesListTile> createState() => _SelectFavoritesListTileState();
}

class _SelectFavoritesListTileState extends State<SelectFavoritesListTile> {
  bool _selected = false;
  int length = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.sourceInFavoritesIdMap[widget.favorites.id] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: colorScheme.primaryContainer,
      child: ListTile(
        title: Text(widget.favorites.title ?? ""),
        visualDensity: const VisualDensity(vertical: -4),
        trailing: Checkbox(
            value: _selected,
            onChanged: (bool? value) {
              if (value != null) {
                _selected = value;
                setState(() {});
                widget.onChanged(value);
              }
            }),
      ),
    );
  }
}
