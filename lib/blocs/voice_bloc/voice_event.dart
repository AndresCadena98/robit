part of 'voice_bloc.dart';

@immutable
abstract class VoiceEvent {}

class SetVoiceEvent extends VoiceEvent {
  final bool? voice;
  SetVoiceEvent({this.voice});
  @override
  String toString() => 'SetVoiceEvent';
  List<Object?> get props => [voice];

  SetVoiceEvent copyWith({
    bool? voice,
  }) {
    return SetVoiceEvent(
      voice: voice ?? this.voice,
    );
  }
}

class GetVoiceEvent extends VoiceEvent {}
