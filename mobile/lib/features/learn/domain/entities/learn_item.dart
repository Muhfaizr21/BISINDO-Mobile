import 'package:equatable/equatable.dart';

class LearnItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;

  const LearnItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, description, category];
}

