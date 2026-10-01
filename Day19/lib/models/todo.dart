class Todo {
  final int id;
  final String title;
  final bool done;

  const Todo({required this.id, required this.title, this.done = false});

  Todo copyWith({bool? done}) => Todo(id: id, title: title, done: done ?? this.done);
}
