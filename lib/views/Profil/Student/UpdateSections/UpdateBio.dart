import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';

class UpdateBioPage extends StatelessWidget {
  final String initialBio;
  final Function(String) onBioUpdated;

  const UpdateBioPage({Key? key, required this.initialBio, required this.onBioUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newBio = initialBio;

    return WillPopScope(
      onWillPop: () async {
        _showConfirmationBottomSheet(context, newBio);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F2F2),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About me",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A6D8C),
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                labelText: 'About Me',
                initialValue: initialBio,
                onChanged: (value) {
                  newBio = value;
                },
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      onBioUpdated(newBio);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A6D8C),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context, String newBio) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationBottomSheet(
          title: 'Undo Changes?',
          message: 'Are you sure you want to discard the changes you made?',
          onContinue: () {

          },
          onUndo: () {
            onBioUpdated(initialBio);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
