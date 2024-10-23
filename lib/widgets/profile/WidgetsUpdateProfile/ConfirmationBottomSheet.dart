import 'package:flutter/material.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final Function onContinue;
  final Function onUndo;

  const ConfirmationBottomSheet({
    Key? key,
    required this.title,
    required this.message,
    required this.onContinue,
    required this.onUndo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6D8C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onContinue(); // Appelle la fonction pour continuer
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A6D8C),
                ),
                child: const Text(
                  'Continue Filling',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onUndo(); // Appelle la fonction pour annuler les modifications
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Undo Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
