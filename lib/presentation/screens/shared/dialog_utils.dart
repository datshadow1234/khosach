import 'package:flutter/material.dart';
// import 'package:shopcaycanh/ui/payment_cart/payment_cart_screen.dart';
// import '../../ui/payment_cart/';


Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Thông báo'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Không'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Có'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
}

Future<bool?> showConfirmDialogZaloCancel(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Thông báo'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Có lỗi xảy ra!'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
