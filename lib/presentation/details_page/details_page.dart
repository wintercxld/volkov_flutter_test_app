import 'package:flutter/material.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';

class DetailsPage extends StatelessWidget {
  final CardData data;

  const DetailsPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    data.imageUrl ?? 'face-with-raised-eyebrow.png',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                data.text,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                data.descriptionText,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
