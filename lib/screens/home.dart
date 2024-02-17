import 'package:flutter/material.dart';
import 'package:together/screens/v1.dart';
import 'package:together/screens/v2.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // V1 - First version (UI) of the cards
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const V1(),
                ),
              ),
              child: const Text('V1'),
            ),
            const SizedBox(
              height: 14,
            ),

            // V2 - Second version (UI) of the cards
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const V2(),
                ),
              ),
              child: const Text('V2'),
            ),
          ],
        ),
      ),
    );
  }
}
