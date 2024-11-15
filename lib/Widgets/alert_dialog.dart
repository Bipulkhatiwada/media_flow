import 'package:flutter/material.dart';

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onConfirm,
}) {
  // Alert dialog buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () => Navigator.pop(context),
  );
  Widget confirmButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      onConfirm();
      Navigator.pop(context); // Close the dialog after confirm action
    },
  );

  // Alert dialog UI
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [cancelButton, confirmButton],
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}