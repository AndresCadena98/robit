part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventStarted extends AuthEvent {
  final User? user;

  AuthEventStarted({this.user});
}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}