part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetUserEvent extends UserEvent {
  SetUserEvent();
  

}

class GetUserEvent extends UserEvent {
  GetUserEvent();
}

