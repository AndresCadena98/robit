part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {
  
}

class SearchLoadingState extends SearchState {}

class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState({required this.message});

  @override
  String toString() => 'SearchErrorState';

  List<Object> get props => [message];
  SearchErrorState copyWith({
    String? message,
  }) {
    return SearchErrorState(
      message: message ?? this.message,
    );
  }
}

class SearchCompletedState extends SearchState {
  final String text;
  final ChatGPT chatGpt;
  final Completion completion;
  final Images? images;
  bool imagesBool = false;
  SearchCompletedState({required this.text, required this.chatGpt, required this.completion,   this.images, this.imagesBool = false});

  @override
  String toString() => 'SearchCompletedState';

  List<Object> get props => [text, chatGpt, completion, imagesBool];
  SearchCompletedState copyWith({
    String? text,
    ChatGPT? chatGpt,
    Completion? completion,
    Images ? images,
    bool? imagesBool,
  }) {
    return SearchCompletedState(
      text: text ?? this.text,
      chatGpt: chatGpt ?? this.chatGpt,
      completion: completion ?? this.completion,
      images: images ?? this.images,
      imagesBool: imagesBool ?? this.imagesBool,
    );
  }
}

class SearchImagesState extends SearchState {
  final Images? images;
  SearchImagesState({this.images});

  @override
  String toString() => 'SearchImagesState';
  SearchImagesState copyWith({
    Images? images,
  }) {
    return SearchImagesState(
      images: images ?? this.images,
    );
  }
}

class SendMessagesState extends SearchState {
  final ChatMessage? messages;
  SendMessagesState({this.messages});

  @override
  String toString() => 'SendMessagesState';
  SendMessagesState copyWith({
    ChatMessage? messages,
  }) {
    return SendMessagesState(
      messages: messages ?? this.messages,
    );
  }
}
