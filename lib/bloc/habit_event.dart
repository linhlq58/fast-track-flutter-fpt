import 'package:equatable/equatable.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class HabitAdded extends HabitEvent {
  final String title;

  const HabitAdded(this.title);

  @override
  List<Object?> get props => [title];
}

class HabitToggled extends HabitEvent {
  final String id;

  const HabitToggled(this.id);

  @override
  List<Object?> get props => [id];
}

class HabitRemoved extends HabitEvent {
  final String id;

  const HabitRemoved(this.id);

  @override
  List<Object?> get props => [id];
}
