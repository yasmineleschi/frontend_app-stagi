import 'package:flutter/material.dart';

class InternshipItem extends StatelessWidget {
  final String companyName;
  final String companyAddress;
  final String title;
  final String description;
  final List<String> requirements;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime postedDate;
  final VoidCallback? onApply;
  final String companyId;


  InternshipItem({
    required this.companyName,
    required this.companyAddress,
    required this.title,
    required this.description,
    required this.requirements,
    required this.startDate,
    required this.endDate,
    required this.postedDate,
     this.onApply,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/photoprofile.png'),
                  radius: 20,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName.isNotEmpty ? companyName : 'No companyName',
                        style: TextStyle(
                          fontFamily: "Roboto Slab",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.orangeAccent,
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              companyAddress.isNotEmpty
                                  ? companyAddress
                                  : 'No company address',
                              style: TextStyle(
                                fontFamily: "Roboto Slab",
                                fontSize: 10,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis, // Truncate text if too long
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.bookmark_border_outlined,
                    size: 30,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title.isNotEmpty ? title : 'No Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto Slab",
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description_outlined, size: 16, color: Colors.orangeAccent), // Icon for Description
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description.isNotEmpty ? description : 'No Description',
                    style: TextStyle(
                      fontFamily: "Roboto Slab",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (requirements.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.checklist, size: 16, color: Colors.orangeAccent), // Icon for Requirements
                  SizedBox(width: 8),
                  Text(
                    'Requirements:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              for (var req in requirements)
                Text(
                  '    • $req',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              SizedBox(height: 8),
            ],
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.orangeAccent),
                        SizedBox(width: 4),
                        Text(
                          'Start Date:',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      '${startDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, size: 16, color: Colors.orangeAccent),
                        SizedBox(width: 4),
                        Text(
                          'End Date:',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      '${endDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.post_add, size: 16, color: Colors.orangeAccent),
                        SizedBox(width: 4),
                        Text(
                          'Posted Date:',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      '${postedDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),
            if (onApply != null)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B3B6D),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Apply Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto Slab",
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
