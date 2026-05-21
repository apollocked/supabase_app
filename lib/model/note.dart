class Note {
  int? id;

  String content;

  Note({this.id, required this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'content': content};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], content: map['content']);
  }
}
