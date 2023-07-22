import 'package:flutter/material.dart';
import 'package:post_client/model/favorites.dart';

class SelectFavoritesListTile extends StatefulWidget {
  const SelectFavoritesListTile({super.key, required this.favorites, required this.sourceId, required this.onChanged});

  final Favorites favorites;

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
    if(widget.favorites.sourceIdList!=null){
      length = widget.favorites.sourceIdList!.length;
      if (widget.favorites.sourceIdList!.contains(widget.sourceId)) {
        _selected = true;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      color: colorScheme.primaryContainer,
      child: ListTile(
        title: Text(widget.favorites.title ?? ""),
        subtitle: Text("$length 个内容"),
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
