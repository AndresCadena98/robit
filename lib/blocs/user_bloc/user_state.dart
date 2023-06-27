part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {
}

class ReadyInfoUser extends UserState {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final bool emailVerified;
  ReadyInfoUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.emailVerified,
  });

  List<Object> get props => [uid, email, displayName, photoURL, emailVerified ];

  ReadyInfoUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
  }) {
    return ReadyInfoUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
  @override
  String toString() {
    return 'UserInitial(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, emailVerified: $emailVerified)';
  }
}
