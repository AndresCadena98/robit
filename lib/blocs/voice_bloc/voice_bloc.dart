import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  VoiceBloc() : super(VoiceInitial(
    voice: false
  )) {
    on<VoiceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SetVoiceEvent>(_setVoiceEvent);
    on<GetVoiceEvent>(_getVoiceEvent);
}
  FutureOr<void> _setVoiceEvent(SetVoiceEvent event, Emitter<VoiceState> emit)async{
    var currentState = state as VoiceInitial;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(event.voice!);
    prefs.setBool('voice', event.voice!);
    emit(currentState.copyWith(voice: event.voice));
  }


  FutureOr<void> _getVoiceEvent(GetVoiceEvent event, Emitter<VoiceState> emit)async{
    var currentState = state as VoiceInitial;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? voice = prefs.getBool('voice') ?? false;
    emit(currentState.copyWith(voice: voice));
  }
}