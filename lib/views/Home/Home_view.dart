// home_view.dart
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final String token;

  const HomeView({Key? key, required this.token}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final publicationViewModel =
    Provider.of<PublicationViewModel>(context, listen: false);
    publicationViewModel.fetchPublications(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final publicationViewModel = Provider.of<PublicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  publicationViewModel.createPublication(
                    widget.token,
                    title,
                    content,
                  );
                }
              },
              child: const Text('Create Publication'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: publicationViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: publicationViewModel.publications.length,
                itemBuilder: (context, index) {
                  final publication =
                  publicationViewModel.publications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(publication['title']),
                      subtitle: Text(publication['content']),
                    ),
                  );
                },
              ),
            ),
            if (publicationViewModel.errorMessage.isNotEmpty)
              Text(
                publicationViewModel.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
