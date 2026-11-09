import 'package:equatable/equatable.dart';

class Gesture extends Equatable {
  final String label;
  final double confidence;

  const Gesture({
    required this.label,
    required this.confidence,
  });

  @override
  List<Object?> get props => [label, confidence];
}

