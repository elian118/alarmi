import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // bool get isLoggedIn => user != null;
  // bool get isLoggedIn => false;
  bool get isLoggedIn => true;
  // 유저 로그인 상태 변경
  // Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
}

final authRepo = Provider((ref) => AuthenticationRepository());

// final authState = StreamProvider((ref) {
//   final repos = ref.read(authRepo);
//   return repos.authStateChanges();
// });
