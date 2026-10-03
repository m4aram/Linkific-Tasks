/// Immutable model: to "change" a todo we create a new one with copyWith.
/// Riverpod 3 compares states with ==, so immutable data is the right fit.
class Todo {
  final int id;
  final String title;
  final bool done;

  const Todo({required this.id, required this.title, this.done = false});

  Todo copyWith({bool? done}) => Todo(id: id, title: title, done: done ?? this.done);
}
