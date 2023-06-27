import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imagesia/services/auth_services.dart';
import 'package:meta/meta.dart';



part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AuthEventStarted>(_authStarted);
    on<LogoutEvent>(_logoutEvent);
  }

  FutureOr<void> _authStarted(
      AuthEventStarted event, Emitter<AuthState> emitt) {
    if (event.user == null) {
      emitt(AuthStateUnauthenticated());
    } else {
      emitt(AuthStateAuthenticated(user: event.user!));
    }
  }

  FutureOr<void> _logoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    AuthServices().signOut();  
  }
}
