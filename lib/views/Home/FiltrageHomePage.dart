import 'package:flutter/material.dart';

class FiltrageHomePage extends StatefulWidget {
  final void Function(DateTime? startDate,  String? address) onFilter;

  const FiltrageHomePage({Key? key, required this.onFilter}) : super(key: key);

  @override
  _FiltrageHomePageState createState() => _FiltrageHomePageState();
}

class _FiltrageHomePageState extends State<FiltrageHomePage> {
  DateTime? _selectedStartDate;
  String? _selectedAddress;

  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Options"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            Row(
              children: [
                const Text("Start Date: "),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    setState(() {
                      _selectedStartDate = date;
                    });
                  },
                  child: Text(_selectedStartDate != null
                      ? "${_selectedStartDate!.toLocal()}".split(' ')[0]
                      : "Select Date"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Education Level


            // Company Address
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Company Address"),
              onChanged: (value) {
                _selectedAddress = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFilter(_selectedStartDate, _selectedAddress);
            Navigator.of(context).pop();
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }
}
