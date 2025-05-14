import 'package:flutter/material.dart';
import '../../models/tutoring.dart';
import '../../services/database_service.dart';

class TutoringScreen extends StatefulWidget {
  const TutoringScreen({super.key});

  @override
  State<TutoringScreen> createState() => _TutoringScreenState();
}

class _TutoringScreenState extends State<TutoringScreen> {
  final DatabaseService _databaseService = DatabaseService();
  String? _selectedFaculty;
  String? _selectedSubject;
  final _searchController = TextEditingController();

  final List<String> _faculties = [
    'Tutte le facoltà',
    'Economia',
    'Ingegneria',
    'Lettere e Filosofia',
    'Medicina e Chirurgia',
    'Scienze MM.FF.NN.',
    'Giurisprudenza',
  ];

  void _showCreateTutoringDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateTutoringForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra di ricerca e filtri
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cerca materia...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // TODO: Implementare la ricerca
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedFaculty,
                  decoration: const InputDecoration(
                    labelText: 'Filtra per facoltà',
                    border: OutlineInputBorder(),
                  ),
                  items: _faculties.map((faculty) {
                    return DropdownMenuItem(
                      value: faculty == 'Tutte le facoltà' ? null : faculty,
                      child: Text(faculty),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFaculty = value == 'Tutte le facoltà' ? null : value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Lista ripetizioni
          Expanded(
            child: StreamBuilder<List<Tutoring>>(
              stream: _databaseService.getTutoringListings(
                faculty: _selectedFaculty,
                subject: _selectedSubject,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tutorings = snapshot.data ?? [];

                if (tutorings.isEmpty) {
                  return const Center(
                    child: Text('Nessuna ripetizione disponibile'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tutorings.length,
                  itemBuilder: (context, index) {
                    final tutoring = tutorings[index];
                    return TutoringCard(tutoring: tutoring);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTutoringDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CreateTutoringForm extends StatefulWidget {
  const CreateTutoringForm({super.key});

  @override
  State<CreateTutoringForm> createState() => _CreateTutoringFormState();
}

class _CreateTutoringFormState extends State<CreateTutoringForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  String _selectedFaculty = 'Economia';
  bool _isOnline = true;
  bool _isInPerson = true;
  bool _isLoading = false;

  final List<String> _faculties = [
    'Economia',
    'Ingegneria',
    'Lettere e Filosofia',
    'Medicina e Chirurgia',
    'Scienze MM.FF.NN.',
    'Giurisprudenza',
  ];

  void _submitTutoring() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final tutoring = Tutoring(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          tutorId: 'mock_user_id',
          subject: _subjectController.text,
          description: _descriptionController.text,
          pricePerHour: double.parse(_priceController.text),
          availability: [], // TODO: Implementare selezione disponibilità
          faculty: _selectedFaculty,
          isOnline: _isOnline,
          isInPerson: _isInPerson,
        );
        
        await _databaseService.createTutoringListing(tutoring);
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
                'Offri Ripetizioni',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Materia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la materia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFaculty,
                decoration: const InputDecoration(
                  labelText: 'Facoltà',
                  border: OutlineInputBorder(),
                ),
                items: _faculties.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedFaculty = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prezzo orario (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il prezzo orario';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Inserisci un prezzo valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrizione',
                  hintText: 'Descrivi la tua esperienza e il tuo metodo...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci una descrizione';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Disponibile online'),
                value: _isOnline,
                onChanged: (value) {
                  setState(() => _isOnline = value);
                },
              ),
              SwitchListTile(
                title: const Text('Disponibile in presenza'),
                value: _isInPerson,
                onChanged: (value) {
                  setState(() => _isInPerson = value);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTutoring,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Pubblica annuncio'),
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
    _subjectController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

class TutoringCard extends StatelessWidget {
  final Tutoring tutoring;

  const TutoringCard({super.key, required this.tutoring});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Implementare la vista dettagliata della ripetizione
        },
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username', // TODO: Ottenere username del tutor
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          tutoring.subject,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '€${tutoring.pricePerHour.toStringAsFixed(2)}/h',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tutoring.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tutoring.faculty,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (tutoring.isOnline)
                    const Chip(
                      label: Text('Online'),
                      backgroundColor: Colors.blue,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  if (tutoring.isOnline && tutoring.isInPerson)
                    const SizedBox(width: 8),
                  if (tutoring.isInPerson)
                    const Chip(
                      label: Text('In presenza'),
                      backgroundColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}