class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Mock dell'utente corrente
  bool _isAuthenticated = false;
  String? _currentUserId;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;

  Stream<bool> get authStateChanges => Stream.value(_isAuthenticated);

  Future<void> signInWithEmail(String email, String password) async {
    // Simuliamo un ritardo per l'autenticazione
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _currentUserId = 'mock_user_id';
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String faculty,
  }) async {
    // Simuliamo un ritardo per la registrazione
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _currentUserId = 'mock_user_id';
  }

  Future<void> signOut() async {
    // Simuliamo un ritardo per il logout
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _currentUserId = null;
  }
}