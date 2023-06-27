part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthStateAuthenticated extends AuthState {
  final User user;

  AuthStateAuthenticated({required this.user});
}

class AuthStateUnauthenticated extends AuthState {
  AuthStateUnauthenticated();
}