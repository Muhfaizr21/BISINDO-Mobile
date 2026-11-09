import 'package:equatable/equatable.dart';

abstract class LearnEvent extends Equatable {
  const LearnEvent();

  @override
  List<Object?> get props => [];
}

class LoadLearnMaterialsEvent extends LearnEvent {}

