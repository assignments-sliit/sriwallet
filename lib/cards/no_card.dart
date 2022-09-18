import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoCard extends StatelessWidget {
  const NoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
             
             TextButton.icon(onPressed: null, icon: const Icon(Icons.add_card, size: 32,),
             label: const Text('Add a card', style: TextStyle(fontSize: 26),))
              
            ]),
      ),
    );
  }
}
