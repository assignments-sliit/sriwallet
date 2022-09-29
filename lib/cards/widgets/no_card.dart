import 'package:flutter/material.dart';
import 'package:sriwallet/cards/screens/add_card.dart';

class NoCard extends StatelessWidget {
  const NoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddCardPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 350,
          //height: 200,
          //width: 175,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddCardPage()));
                    },
                    icon: const Icon(
                      Icons.add_card,
                      size: 32,
                    ),
                    label: const Text(
                      'Add a card',
                      style: TextStyle(fontSize: 26),
                    ))
              ]),
        ),
      ),
    );
  }
}
