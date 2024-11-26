import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/HomeSearchViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/views/Home/item_internship.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/views/Home/CommentsPage.dart';
import 'package:frontend_app_stagi/views/Home/PublicationPage.dart'; // Import the PublicationPage
import 'package:frontend_app_stagi/views/Home/PublicationDetailsPage.dart';
import 'package:frontend_app_stagi/widgets/WidgetHome/sidebar.dart';

class HomeView extends StatefulWidget {
  final String token;

  const HomeView({Key? key, required this.token}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSidebarVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final companyProfileViewModel = Provider.of<CompanyProfileViewModel>(context, listen: false);
    companyProfileViewModel.fetchInternships();
    companyProfileViewModel.addListener(() {
      debugPrint('Internships loaded: ${companyProfileViewModel.internships.length}');
    });

    final publicationViewModel =
        Provider.of<PublicationViewModel>(context, listen: false);
    publicationViewModel.fetchPublications(widget.token);
    publicationViewModel.addListener(() {
      final publications = publicationViewModel.publications;
      Provider.of<HomeSearchViewModel>(context, listen: false)
          .initializePublications(publications);
    });
  }



  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final publicationViewModel = Provider.of<PublicationViewModel>(context);
    final searchViewModel = Provider.of<HomeSearchViewModel>(context);
    final companyProfileViewModel =
        Provider.of<CompanyProfileViewModel>(context);

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
              controller: _searchController,
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
              onChanged: (query) {
                searchViewModel.filterPublications(query);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add_box_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PublicationPage(token: widget.token), // Navigate here
                    ),
                  );
                },
              ),
            ],
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 16.0),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: publicationViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount:
                              searchViewModel.filteredPublications.length +
                                  companyProfileViewModel.internships.length,
                          itemBuilder: (context, index) {
                            if (index <
                                searchViewModel.filteredPublications.length) {
                              final publication =
                                  searchViewModel.filteredPublications[index];
                              final user = publication['user'];
                              final hasLiked =
                                  publication['likedByUser'] ?? false;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PublicationDetailsPage(
                                        publicationId: publication['_id'],
                                        token: widget.token,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Row for profile photo and username
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/photoprofile.png'),
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
                                        // Like and comment icons with like count
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                hasLiked
                                                    ? Icons.thumb_up_alt
                                                    : Icons
                                                        .thumb_up_alt_outlined,
                                                color: hasLiked
                                                    ? Colors.blue
                                                    : null,
                                              ),
                                              onPressed: () {
                                                publicationViewModel.toggleLike(
                                                    widget.token,
                                                    publication['_id'],
                                                    hasLiked);
                                              },
                                            ),
                                            Text(
                                                '${publication['likes']} likes'),
                                            SizedBox(width: 8),
                                            IconButton(
                                              icon:
                                                  Icon(Icons.comment_outlined),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommentsPage(
                                                      publicationId:
                                                          publication['_id'],
                                                      token: widget.token,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final internship =
                                  companyProfileViewModel.internships[index -
                                      searchViewModel
                                          .filteredPublications.length];
                              return ListTile(
                                  subtitle: InternshipItem(
                                      companyName: internship.companyName,
                                      companyAddress: internship.companyAddress,
                                      title: internship.title,
                                      description: internship.description,
                                      requirements: internship.requirements,
                                      startDate: internship.startDate,
                                      endDate: internship.endDate,
                                      postedDate: internship.postedDate,
                                      onApply: () {}));
                            }
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
