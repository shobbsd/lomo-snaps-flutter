import 'package:flutter/material.dart';

navigateToWithoutBack(BuildContext context, newPage) {
  Navigator.of(context).pushAndRemoveUntil(
      new MaterialPageRoute(builder: (BuildContext context) => newPage),
      (Route route) => route == null);
}
