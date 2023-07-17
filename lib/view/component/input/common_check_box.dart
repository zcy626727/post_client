import 'package:flutter/material.dart';

class CommonCheckBox extends StatelessWidget {
  const CommonCheckBox({super.key, required this.value, this.onChanged, required this.title});

  final String title;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool switchMode = true;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        leading: Text(
          title,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
          strutStyle: const StrutStyle(fontSize: 21),
        ),
        trailing: switchMode
            ? Switch(
                value: value, //当前状态
                onChanged: onChanged,
              )
            : Checkbox(
                fillColor: MaterialStateProperty.all(value ? colorScheme.primary : colorScheme.onSurface),
                value: value,
                onChanged: onChanged,
              ),
      ),
    );
  }
}
