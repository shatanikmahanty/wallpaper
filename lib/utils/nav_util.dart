import 'package:flutter/material.dart';

void push(BuildContext context, Route<dynamic> route) {
  Navigator.of(context).push(route);
}

void pushReplacement(BuildContext context, Route<dynamic> route) {
  Navigator.of(context).pushReplacement(route);
}

void pushAndRemoveAll(BuildContext context, Route<dynamic> route) {
  Navigator.of(context).pushAndRemoveUntil(
    route,
    (Route<dynamic> route) => false,
  );
}
