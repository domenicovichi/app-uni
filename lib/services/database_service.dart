import 'mock_database_service.dart';
import '../models/spotted.dart';
import '../models/event.dart';
import '../models/book.dart';
import '../models/tutoring.dart';

class DatabaseService {
  final MockDatabaseService _mockDb = MockDatabaseService();

  // Spotted
  Stream<List<Spotted>> getSpottedPosts() => _mockDb.getSpottedPosts();
  Future<void> createSpotted(Spotted spotted) => _mockDb.createSpotted(spotted);

  // Eventi
  Stream<List<Event>> getEvents() => _mockDb.getEvents();
  Future<void> createEvent(Event event) => _mockDb.createEvent(event);

  // Libri
  Stream<List<Book>> getBooks({String? faculty}) => _mockDb.getBooks(faculty: faculty);
  Future<void> createBookListing(Book book) => _mockDb.createBookListing(book);

  // Ripetizioni
  Stream<List<Tutoring>> getTutoringListings({String? faculty, String? subject}) =>
      _mockDb.getTutoringListings(faculty: faculty, subject: subject);
  Future<void> createTutoringListing(Tutoring tutoring) =>
      _mockDb.createTutoringListing(tutoring);
}