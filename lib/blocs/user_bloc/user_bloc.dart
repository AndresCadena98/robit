import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_gpt_api/app/chat_gpt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imagesia/services/auth_services.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc()
      : super(ReadyInfoUser(
          uid: '',
          email: '',
          displayName: '',
          photoURL: '',
          emailVerified: false,
        )) {
    on<UserEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SetUserEvent>(_setUserEvent);
  }

  FutureOr<void> _setUserEvent(
      SetUserEvent event, Emitter<UserState> emit) async {
    var currentState = state as ReadyInfoUser;
    AuthServices().user.listen((User? user) {
      if (user == null) {
        
      } else {
        emit(currentState.copyWith(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName!,
            photoURL: user.photoURL!,
            emailVerified: user.emailVerified
        ));
      }
    });
  }
}
