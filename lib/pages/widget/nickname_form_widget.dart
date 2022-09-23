import 'package:flutter/cupertino.dart';

class NickNameFormWidget extends StatelessWidget {
  const NickNameFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: const [
          Text("What's your nickname?" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20)),
          SizedBox(height: 10),
          CupertinoTextField(
            placeholder: 'insert your name',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
