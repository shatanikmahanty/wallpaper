import 'package:flutter/material.dart';

class NavItemModel {
  final String _title;
  final IconData _icon;

  NavItemModel(this._title, this._icon);

  IconData get icon => _icon;

  String get title => _title;
}
