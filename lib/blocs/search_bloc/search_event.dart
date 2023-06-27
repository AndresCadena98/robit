part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchFullTextEvent extends SearchEvent {
  final String text;
  final ChatGPT chatGpt;
  final ChatUser? userRobot;
  SearchFullTextEvent({required this.text, required this.chatGpt, this.userRobot});

  @override
  String toString() => 'SearchFullTextEvent';

  List<Object> get props => [text, chatGpt];
  SearchFullTextEvent copyWith({
    String? text,
    ChatGPT? chatGpt,
    ChatUser? userRobot,
  }) {
    return SearchFullTextEvent(
      text: text ?? this.text,
      chatGpt: chatGpt ?? this.chatGpt,
      userRobot: userRobot ?? this.userRobot,
    );
  }
}

class SearchImagesEvent extends SearchEvent {
  final String text;
  final ChatGPT chatGpt;
  SearchImagesEvent({required this.text, required this.chatGpt});

  @override
  String toString() => 'SearchImagesEvent';

  List<Object> get props => [text, chatGpt];
  SearchImagesEvent copyWith({
    String? text,
    ChatGPT? chatGpt,
  }) {
    return SearchImagesEvent(
      text: text ?? this.text,
      chatGpt: chatGpt ?? this.chatGpt,
    );
  }
}

class SendMessagesEvent extends SearchEvent {
  final String text;

  final ChatUser user;
  SendMessagesEvent({required this.text,  required this.user});
  @override
  String toString() => 'SendMessagesEvent';
  List<Object> get props => [text, user];
  SendMessagesEvent copyWith({
    String? text,
    ChatUser? user,
  }) {
    return SendMessagesEvent(
      text: text ?? this.text,
      user: user ?? this.user,

    );
  }
}
