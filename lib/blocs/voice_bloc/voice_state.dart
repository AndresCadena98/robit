part of 'voice_bloc.dart';

@immutable
abstract class VoiceState {}

class VoiceInitial extends VoiceState {
  final bool? voice;
  VoiceInitial({this.voice});
  @override
  String toString() => 'VoiceInitial';
  List<Object?> get props => [voice];

  VoiceInitial copyWith({
    bool? voice,
  }) {
    return VoiceInitial(
      voice: voice ?? this.voice,
    );
  }
}
