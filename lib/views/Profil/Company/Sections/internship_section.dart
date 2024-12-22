import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_app_stagi/views/Profil/Company/updateSection/Liste_internship.dart';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';

class InternshipSection extends StatefulWidget {
  final List<Internship> internships;
  final Function(Internship) onInternshipUpdated;

  const InternshipSection({
    Key? key,
    required this.internships,
    required this.onInternshipUpdated
  }) : super(key: key);

  @override
  _InternshipSectionState createState() => _InternshipSectionState();
}

class _InternshipSectionState extends State<InternshipSection> {
  bool _showAllInternships = false;

  late List<Internship> internships;

  String formatDate(DateTime date) {
    return DateFormat('d MMMM y').format(date);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
  TextEditingController requirementsController = TextEditingController();
  List<String> requirements = [];

  void _showAddInternshipDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController requirementsController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    bool isActive = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF5F2F2),
              title: const Text(
                'Add New Internship',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      key: const Key('usernameField'),
                      controller: titleController,
                      labelText: 'Internship Title',
                      icon: Icons.work_outline,
                      hintText: 'Enter the title of the internship',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      key: const Key('usernameField'),
                      controller: descriptionController,
                      labelText: 'Description',
                      icon: Icons.description_outlined,
                      hintText: 'Describe the internship details',
                      maxLines: 6,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      key: const Key('usernameField'),
                      controller: requirementsController,
                      labelText: 'Requirements',
                      icon: Icons.check_circle_outline,
                      hintText: 'List the requirements (comma-separated)',
                    ),
                    const SizedBox(height: 10),
                    // Display the requirements entered
                    if (requirementsController.text.isNotEmpty)
                      Column(
                        children: requirementsController.text.split(',').map((requirement) {
                          return ListTile(
                            title: Text(
                              requirement.trim(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            key: const Key('usernameField'),
                            controller: startDateController,
                            labelText: 'Start Date',
                            icon: Icons.date_range_outlined,
                            hintText: 'Select the start date',
                            isReadOnly: true,
                            onTap: () => _selectDate(context, startDateController),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomTextField(
                            key: const Key('usernameField'),
                            controller: endDateController,
                            labelText: 'End Date',
                            icon: Icons.date_range_outlined,
                            hintText: 'Select the end date',
                            isReadOnly: true,
                            onTap: () => _selectDate(context, endDateController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Active:'),
                        Switch(
                          value: isActive,
                          onChanged: (bool value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        startDateController.text.isNotEmpty &&
                        endDateController.text.isNotEmpty) {
                      Internship newInternship = Internship(
                        title: titleController.text,
                        description: descriptionController.text,
                        requirements: requirementsController.text.split(',').map((e) => e.trim()).toList(),
                        startDate: DateTime.parse(startDateController.text),
                        endDate: DateTime.parse(endDateController.text),
                        isActive: isActive,
                        postedDate: DateTime.now(),
                        companyName: "",
                        companyAddress: "",
                      );

                      setState(() {
                        widget.internships.add(newInternship);
                      });
                      widget.onInternshipUpdated(newInternship);
                      Navigator.of(context).pop();
                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6D8C),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    internships = widget.internships;
  }


  @override
  Widget build(BuildContext context) {
    final displayedInternships = _showAllInternships
        ? widget.internships
        : widget.internships.take(10).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ProfileSectionCard(
            title: 'Internships',
            icon: Icons.work_outline_outlined,
            content: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedInternships.map((internship) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    internship.title ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Start Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              formatDate(internship.startDate),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'End Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              formatDate(internship.endDate),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    internship.description ?? '',
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    'Requirements',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    internship.requirements.join('\n'),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Posted Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              formatDate(internship.postedDate),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Active',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(height: 3),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: internship.isActive
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        const Divider(thickness: 2),
                      ],
                    );
                  }).toList(),
                ),

              ],
            ),
            hasAddIcon: () => _showAddInternshipDialog(context),
            onEditPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InternshipListPage(
                    internships: widget.internships,
                    onInternshipUpdated: widget.onInternshipUpdated,
                  ),
                ),
              );
            },


          ),
        ],
      ),
    );
  }
}
