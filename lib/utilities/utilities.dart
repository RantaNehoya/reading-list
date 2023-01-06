import 'package:flutter/material.dart';

//dialog alert box
class AlertBox extends StatelessWidget {
  final VoidCallback function;
  const AlertBox({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      content: const Text(
        'Do you wish to delete this book?\nThis action is irreversible',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13.5,
          fontWeight: FontWeight.w300,
        ),
      ),

      actions: [
        OutlinedButton(
          onPressed: function,
          child: const Text('Yes'),
        ),

        OutlinedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
