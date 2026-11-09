import 'package:equatable/equatable.dart';
import '../../domain/entities/learn_item.dart';

abstract class LearnState extends Equatable {
  const LearnState();

  @override
  List<Object?> get props => [];
}

class LearnInitial extends LearnState {}

class LearnLoading extends LearnState {}

class LearnLoaded extends LearnState {
  final List<LearnItem> items;

  const LearnLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class LearnError extends LearnState {
  final String message;

  const LearnError(this.message);

  @override
  List<Object?> get props => [message];
}

