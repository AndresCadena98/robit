import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_gpt_api/chat_gpt.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc()
      : super(SearchInitial()) {
    on<SearchEvent>((event, emit)async{
      // TODO: implement event handler
    });

    on<SearchFullTextEvent>(_searchFullTextEvent);
    on<SendMessagesEvent>(_sendMessagesEvent);
    on<SearchImagesEvent>(_searchImagesEvent);
    
  }

  FutureOr<void> _searchFullTextEvent(
      SearchFullTextEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      String? prompt = event.text;
      SearchLoadingState();
      
      
      Completion? completion = await event.chatGpt.textCompletion(
            request: CompletionRequest(
          prompt: prompt,
          maxTokens: 256,
          temperature: 0.5,
          topP: 1,
          n: 1,
        ));
        emit(SearchCompletedState(
            text: event.text,
            chatGpt: event.chatGpt,
            completion: completion!,
            imagesBool: false,
            images: Images()
            ));
    } catch (e) {
      emit(SearchErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _sendMessagesEvent(
      SendMessagesEvent event, Emitter<SearchState> emitt) {
      
    ChatMessage? message = ChatMessage(
      text: event.text,
      user: event.user,
      createdAt: DateTime.now(),
    );

    emitt(SendMessagesState(
      messages: message,
    ));
  }

  FutureOr<void> _searchImagesEvent(SearchImagesEvent event, Emitter<SearchState> emit)async{
    emit(SearchLoadingState());
    try {
      String? prompt = event.text;
      SearchLoadingState();
      
      
      if (prompt.contains('imagen')) {
        Images? images = await event.chatGpt.generateImage(
          request: ImageRequest(
            prompt: prompt,
          ),
        );
        print(images!.data!.last.url!);
        emit(SearchImagesState(
          images: images,
        ));
      } 
    } catch (e) {
      emit(SearchErrorState(message: e.toString()));
    }
  }
}
