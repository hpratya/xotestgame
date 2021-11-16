import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  CustomDialog(this.title, this.content, this.callback,
      [this.actionText = "Reset"]);
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: callback,
          style: TextButton.styleFrom(shadowColor: Colors.blue),
          child: Text(actionText),
        )
      ],
    );
  }
}
