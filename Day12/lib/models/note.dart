class Note {
  final int? id;
  final String title;
  final String content;
  final int? categoryId;

  Note({this.id, required this.title, required this.content, this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category_id': categoryId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      categoryId: map['category_id'] as int?,
    );
  }
}
