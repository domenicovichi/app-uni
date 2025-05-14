import 'package:rxdart/rxdart.dart';
import '../models/spotted.dart';
import '../models/event.dart';
import '../models/book.dart';
import '../models/tutoring.dart';

class MockDatabaseService {
  // Simuliamo i dati in memoria
  final List<Spotted> _spotted = [];
  final List<Event> _events = [];
  final List<Book> _books = [];
  final List<Tutoring> _tutoring = [];

  // Controllers per emettere gli aggiornamenti
  final _spottedController = BehaviorSubject<List<Spotted>>();
  final _eventsController = BehaviorSubject<List<Event>>();
  final _booksController = BehaviorSubject<List<Book>>();
  final _tutoringController = BehaviorSubject<List<Tutoring>>();

  // Singleton pattern
  static final MockDatabaseService _instance = MockDatabaseService._internal();
  factory MockDatabaseService() => _instance;
  MockDatabaseService._internal() {
    // Inizializziamo subito i dati mock
    addMockData();
  }

  void addMockData() {
    // Aggiungi spotted mock
    _spotted.add(
      Spotted(
        id: '1',
        text: 'Ho visto una persona carina in biblioteca...',
        authorId: 'user1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: [],
        comments: [],
        isAnonymous: true,
      ),
    );
    _spotted.add(
      Spotted(
        id: '2',
        text: 'Chi vuole un caffè alla macchinetta?',
        authorId: 'user2',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: [],
        comments: [],
        isAnonymous: false,
      ),
    );

    // Aggiungi eventi mock
    _events.add(
      Event(
        id: '1',
        title: 'Seminario su Flutter',
        description: 'Impariamo a sviluppare app cross-platform con Flutter',
        date: DateTime.now().add(const Duration(days: 2)),
        location: 'Aula 1 - Ingegneria',
        organizerId: 'user1',
        participants: [],
        eventType: 'Accademici',
      ),
    );
    _events.add(
      Event(
        id: '2',
        title: 'Aperitivo Universitario',
        description: 'Vieni a conoscere i tuoi colleghi!',
        date: DateTime.now().add(const Duration(days: 5)),
        location: 'Bar del Campus',
        organizerId: 'user2',
        participants: [],
        eventType: 'Sociali',
      ),
    );

    // Aggiungi libri mock
    _books.add(
      Book(
        id: '1',
        title: 'Analisi Matematica 1',
        author: 'Mario Rossi',
        sellerId: 'user1',
        price: 25.0,
        condition: 'Buono',
        description: 'Libro di testo per il corso di Analisi 1',
        images: [],
        subject: 'Matematica',
        faculty: 'Ingegneria',
      ),
    );
    _books.add(
      Book(
        id: '2',
        title: 'Fisica 1',
        author: 'Giuseppe Verdi',
        sellerId: 'user2',
        price: 20.0,
        condition: 'Come nuovo',
        description: 'Libro di testo per il corso di Fisica 1',
        images: [],
        subject: 'Fisica',
        faculty: 'Ingegneria',
      ),
    );

    // Aggiungi ripetizioni mock
    _tutoring.add(
      Tutoring(
        id: '1',
        tutorId: 'user1',
        subject: 'Analisi Matematica',
        description: 'Laureando in Ingegneria offre ripetizioni',
        pricePerHour: 15.0,
        availability: [],
        faculty: 'Ingegneria',
        isOnline: true,
        isInPerson: true,
      ),
    );
    _tutoring.add(
      Tutoring(
        id: '2',
        tutorId: 'user2',
        subject: 'Programmazione',
        description: 'Esperto di Java e Python offre supporto',
        pricePerHour: 20.0,
        availability: [],
        faculty: 'Ingegneria',
        isOnline: true,
        isInPerson: false,
      ),
    );

    // Emettiamo i dati iniziali
    _spottedController.add(_spotted);
    _eventsController.add(_events);
    _booksController.add(_books);
    _tutoringController.add(_tutoring);
  }

  // Spotted
  Stream<List<Spotted>> getSpottedPosts() {
    return _spottedController.stream;
  }

  Future<void> createSpotted(Spotted spotted) async {
    _spotted.insert(0, spotted);
    _spottedController.add(_spotted);
  }

  // Eventi
  Stream<List<Event>> getEvents() {
    return _eventsController.stream;
  }

  Future<void> createEvent(Event event) async {
    _events.add(event);
    _events.sort((a, b) => a.date.compareTo(b.date));
    _eventsController.add(_events);
  }

  // Libri
  Stream<List<Book>> getBooks({String? faculty}) {
    if (faculty != null) {
      final filteredBooks = _books.where((book) => book.faculty == faculty).toList();
      _booksController.add(filteredBooks);
    } else {
      _booksController.add(_books);
    }
    return _booksController.stream;
  }

  Future<void> createBookListing(Book book) async {
    _books.add(book);
    _booksController.add(_books);
  }

  // Ripetizioni
  Stream<List<Tutoring>> getTutoringListings({String? faculty, String? subject}) {
    var filtered = _tutoring;
    
    if (faculty != null) {
      filtered = filtered.where((t) => t.faculty == faculty).toList();
    }
    
    if (subject != null) {
      filtered = filtered.where((t) => t.subject.toLowerCase().contains(subject.toLowerCase())).toList();
    }
    
    _tutoringController.add(filtered);
    return _tutoringController.stream;
  }

  Future<void> createTutoringListing(Tutoring tutoring) async {
    _tutoring.add(tutoring);
    _tutoringController.add(_tutoring);
  }

  void dispose() {
    _spottedController.close();
    _eventsController.close();
    _booksController.close();
    _tutoringController.close();
  }
}