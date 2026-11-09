import 'package:equatable/equatable.dart';
import '../../domain/entities/gesture.dart';

abstract class TranslateState extends Equatable {
  const TranslateState();

  @override
  List<Object?> get props => [];
}

class TranslateInitial extends TranslateState {}

class TranslateDetecting extends TranslateState {
  final List<Gesture> detectedGestures;
  final String translatedText;

  const TranslateDetecting({
    this.detectedGestures = const [],
    this.translatedText = '',
  });

  TranslateDetecting copyWith({
    List<Gesture>? detectedGestures,
    String? translatedText,
  }) {
    return TranslateDetecting(
      detectedGestures: detectedGestures ?? this.detectedGestures,
      translatedText: translatedText ?? this.translatedText,
    );
  }

  @override
  List<Object?> get props => [detectedGestures, translatedText];
}

class TranslateStopped extends TranslateState {
  final String finalTranslation;

  const TranslateStopped({this.finalTranslation = ''});

  @override
  List<Object?> get props => [finalTranslation];
}

class TranslateError extends TranslateState {
  final String message;

  const TranslateError(this.message);

  @override
  List<Object?> get props => [message];
}

