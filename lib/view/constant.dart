import 'package:flutter/cupertino.dart';

const ShapeBorder allCircleShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const ShapeBorder topCircleShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
  topLeft: Radius.circular(10.0),
  topRight: Radius.circular(10.0),
));

const String testImageUrl = "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg";
