import 'package:equatable/equatable.dart';
import '../../domain/entities/gesture.dart';

abstract class TranslateEvent extends Equatable {
  const TranslateEvent();

  @override
  List<Object?> get props => [];
}

class StartDetectionEvent extends TranslateEvent {}

class StopDetectionEvent extends TranslateEvent {}

class GestureDetectedEvent extends TranslateEvent {
  final Gesture gesture;

  const GestureDetectedEvent(this.gesture);

  @override
  List<Object?> get props => [gesture];
}

class ClearTranslationEvent extends TranslateEvent {}

