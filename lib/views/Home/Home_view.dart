import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/HomeSearchViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/views/ApplyNow/apply_now.dart';
import 'package:frontend_app_stagi/widgets/item_internship.dart';
import 'package:frontend_app_stagi/views/Profil/Company/company_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/views/Comments/CommentsPage.dart';
import 'package:frontend_app_stagi/views/Publication/PublicationPage.dart'; // Import the PublicationPage
import 'package:frontend_app_stagi/views/Publication/PublicationDetailsPage.dart';

class HomeView extends StatefulWidget {
  final String token;
  final String userId;
  final String role;

  const HomeView({
    Key? key,
    required this.token,
    required this.userId,
    required this.role,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    final companyProfileViewModel = Provider.of<CompanyProfileViewModel>(context, listen: false);
    companyProfileViewModel.fetchInternships();
    companyProfileViewModel.addListener(() {
      debugPrint('Internships loaded: ${companyProfileViewModel.internships.length}');
    });

    final publicationViewModel = Provider.of<PublicationViewModel>(context, listen: false);
    publicationViewModel.fetchPublications(widget.token);
    publicationViewModel.addListener(() {
      final publications = publicationViewModel.publications;
      Provider.of<HomeSearchViewModel>(context, listen: false).initializePublications(publications);
    });
  }

  void _handleApplyNow(String internshipId) {
    if (widget.role == 'Student') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApplyForInternshipPage(
            internshipId: ,
            studentId: widget.userId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicationViewModel = Provider.of<PublicationViewModel>(context);
    final searchViewModel = Provider.of<HomeSearchViewModel>(context);
    final companyProfileViewModel = Provider.of<CompanyProfileViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1B3B6D),

            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.role == 'Student') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentProfileView(userId: widget.userId),
                        ),
                      );
                    } else if (widget.role == 'Company') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanyProfileView(userId: widget.userId),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/photoprofile.png'),
                      radius: 20.0,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
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
                ),
                IconButton(
                  color: Colors.orangeAccent,
                  icon: Icon(Icons.filter_list , size: 40,),
                  onPressed: () {
                    print('Filter button tapped');
                  },
                ),
              ],
            ),

            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: TextStyle(
                  fontFamily: "Roboto Slab", fontSize: 20, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.work_outline_outlined,
                    size: 20,
                  ),
                  text: 'Internships',
                ),
                Tab(
                  icon: Icon(
                    Icons.article_outlined,
                    size: 20,
                  ),
                  text: 'Publications',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                itemCount: companyProfileViewModel.internships.length,
                itemBuilder: (context, index) {
                  final sortedInternships = companyProfileViewModel.internships
                      .where((internship) => internship.postedDate != null)
                      .toList()
                    ..sort((a, b) {
                      final dateA = DateTime.parse(a.postedDate?.toString() ?? '');
                      final dateB = DateTime.parse(b.postedDate?.toString() ?? '');
                      return dateB.compareTo(dateA);
                    });

                  final internship = sortedInternships[index];

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
                      onApply: widget.role == 'Student'
                          ? () => _handleApplyNow(internship.id ?? '')
                          : null,
                    ),
                  );
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: publicationViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: searchViewModel.filteredPublications.length,
                itemBuilder: (context, index) {
                  final publication = searchViewModel.filteredPublications[index];
                  final user = publication['user'];
                  final hasLiked = publication['likedByUser'] ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublicationDetailsPage(
                            publicationId: publication['_id'],
                            token: widget.token,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Text(publication['content']),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    hasLiked
                                        ? Icons.thumb_up_alt
                                        : Icons.thumb_up_alt_outlined,
                                    color: hasLiked ? Colors.blue : null,
                                  ),
                                  onPressed: () {
                                    publicationViewModel.toggleLike(
                                        widget.token, publication['_id'], hasLiked);
                                  },
                                ),
                                Text('${publication['likes']} likes'),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.comment_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentsPage(
                                          publicationId: publication['_id'],
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
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _currentIndex == 1
            ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PublicationPage(token: widget.token),
              ),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color(0xFF1B3B6D),
        )
            : null,
      ),
    );
  }
}
