import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/views/Profil/Company/updateSection/update_internship.dart';
import 'package:intl/intl.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';

class InternshipListPage extends StatefulWidget {
  final List<Internship> internships;
  final Function(Internship) onInternshipUpdated;

  const InternshipListPage({
    Key? key,
    required this.internships,
    required this.onInternshipUpdated,
  }) : super(key: key);

  @override
  _InternshipListPageState createState() => _InternshipListPageState();
}

class _InternshipListPageState extends State<InternshipListPage> {
  late List<Internship> internships;
  List<String> requirements = [];

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

  @override
  void initState() {
    super.initState();
    internships = widget.internships;
  }

  void _updateInternship(int index, Internship updatedInternship) {
    setState(() {
      internships[index] = updatedInternship;
    });
    widget.onInternshipUpdated(updatedInternship);
  }

  Future<List<Internship>> _loadInternships() async {
    await Future.delayed(const Duration(seconds: 1));
    return internships;
  }


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
                      controller: titleController,
                      labelText: 'Internship Title',
                      icon: Icons.work_outline,
                      hintText: 'Enter the title of the internship',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: descriptionController,
                      labelText: 'Description',
                      icon: Icons.description_outlined,
                      hintText: 'Describe the internship details',
                      maxLines: 6,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: requirementsController,
                      labelText: 'Requirements',
                      icon: Icons.check_circle_outline,
                      hintText: 'List the requirements',
                    ),

                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    if (requirements.isNotEmpty)
                      Column(
                        children: requirements.map((requirements) {
                          return ListTile(
                            title: Text(
                              requirements,
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
                        requirements:  requirementsController.text.split(','),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F2F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(

          child: Text(
            'Edit Internships',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6D8C),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF3A6D8C)),
            onPressed: () => _showAddInternshipDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Internship>>(
        future: _loadInternships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load internships'));
          }

          final internshipList = snapshot.data;

          if (internshipList == null || internshipList.isEmpty) {
            return const Center(child: Text('No internships available.'));
          }

          return ListView.builder(
            itemCount: internshipList.length,
            itemBuilder: (context, index) {
              final reverseIndex = internshipList.length - 1 - index;
              final internship = internshipList[reverseIndex];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    '${internship.title} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A6D8C),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 7),
                      Text(internship.description ?? ''),
                      Text(
                        '${DateFormat('MMM yyyy').format(internship.startDate)} - ${DateFormat('MMM yyyy').format(internship.endDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Text(
                            'Active',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 8),
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
                      const SizedBox(height: 7),
                       Text(
                        'Posted on: ${DateFormat('dd/MM/yyyy').format(internship.postedDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),



                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditInternshipPage(
                            internship: internship,
                            onInternshipUpdated: (updatedInternship) {
                              _updateInternship(index, updatedInternship);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }
}

