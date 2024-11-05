import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/views/Home/PublicationPage.dart';
import 'package:frontend_app_stagi/widgets/WidgetHome/sidebar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final String token;

  const HomeView({Key? key, required this.token}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSidebarVisible = false;

  @override
  void initState() {
    super.initState();
    final publicationViewModel =
    Provider.of<PublicationViewModel>(context, listen: false);
    publicationViewModel.fetchPublications(widget.token);
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  void _navigateToPublicationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublicationPage(token: widget.token)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final publicationViewModel = Provider.of<PublicationViewModel>(context);

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            leading: GestureDetector(
              onTap: () {
                // Navigate to ProfileSectionCard page
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/photoprofile.png'),
              ),
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.create),
                onPressed: _navigateToPublicationPage,
              ),
            ],
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 16.0),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: publicationViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: publicationViewModel.publications.length,
                    itemBuilder: (context, index) {
                      final publication = publicationViewModel.publications[index];
                      final user = publication['user'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row for profile photo and username
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage('assets/photoprofile.png'),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    user['username'] ?? 'Anonymous',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Publication content
                              Text(publication['content']),
                              SizedBox(height: 8),
                              // Like and comment icons
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up_alt_outlined),
                                    onPressed: () {
                                      // Add like functionality here
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.comment_outlined),
                                    onPressed: () {
                                      // Add comment functionality here
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isSidebarVisible)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Sidebar(onClose: _toggleSidebar),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
