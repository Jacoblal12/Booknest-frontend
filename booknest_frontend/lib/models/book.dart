class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  final String? description;
  final String? cover;
  final String availableFor;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.availableFor,
    this.description,
    this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      title: json["title"],
      author: json["author"] ?? "",
      genre: json["genre"],
      description: json["description"],
      cover: json["cover"],
      availableFor: json["available_for"],
    );
  }
}
