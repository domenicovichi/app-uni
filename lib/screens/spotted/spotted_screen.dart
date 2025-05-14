import 'package:flutter/material.dart';
import '../../models/spotted.dart';
import '../../services/database_service.dart';

class SpottedScreen extends StatefulWidget {
  const SpottedScreen({super.key});

  @override
  State<SpottedScreen> createState() => _SpottedScreenState();
}

class _SpottedScreenState extends State<SpottedScreen> {
  final DatabaseService _databaseService = DatabaseService();

  void _showCreateSpottedDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateSpottedForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Spotted>>(
        stream: _databaseService.getSpottedPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data ?? [];
          
          if (posts.isEmpty) {
            return const Center(
              child: Text('Non ci sono ancora spotted. Sii il primo a pubblicarne uno!'),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return SpottedCard(post: post);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateSpottedDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateSpottedForm extends StatefulWidget {
  const CreateSpottedForm({super.key});

  @override
  State<CreateSpottedForm> createState() => _CreateSpottedFormState();
}

class _CreateSpottedFormState extends State<CreateSpottedForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isAnonymous = true;
  bool _isLoading = false;

  void _submitSpotted() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final spotted = Spotted(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _textController.text,
          authorId: 'mock_user_id',
          isAnonymous: _isAnonymous,
          createdAt: DateTime.now(),
          likes: [],
          comments: [],
        );
        
        await _databaseService.createSpotted(spotted);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nuovo Spotted',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Il tuo messaggio',
                  hintText: 'Scrivi il tuo spotted...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci un messaggio';
                  }
                  if (value.length < 10) {
                    return 'Il messaggio deve essere di almeno 10 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Pubblica anonimamente'),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() => _isAnonymous = value);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSpotted,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Pubblica'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class SpottedCard extends StatelessWidget {
  final Spotted post;

  const SpottedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Text(
                  post.isAnonymous ? 'Anonimo' : 'Username', // TODO: Ottenere username reale
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.text),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // TODO: Implementare i like
                  },
                ),
                Text(
                  '${post.likes}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}g fa';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h fa';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m fa';
    } else {
      return 'Ora';
    }
  }
}