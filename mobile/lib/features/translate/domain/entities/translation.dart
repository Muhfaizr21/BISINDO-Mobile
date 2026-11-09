import 'package:equatable/equatable.dart';
import 'gesture.dart';

class Translation extends Equatable {
  final String text;
  final List<Gesture> gestures;
  final DateTime timestamp;

  const Translation({
    required this.text,
    required this.gestures,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [text, gestures, timestamp];
}

