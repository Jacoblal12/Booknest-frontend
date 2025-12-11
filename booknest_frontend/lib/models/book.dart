class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  final String description;
  final String? cover;
  final String availableFor;
  final String owner; // <-- FIXED (string username)

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.availableFor,
    required this.description,
    this.cover,
    required this.owner,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    print("📗 Parsing book JSON: $json");

    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      cover: json['cover'], // API already gives full URL
      genre: json['genre'] ?? '',
      availableFor: json['available_for'] ?? '',
      owner: json["owner"] ?? '', // FIXED TYPE
    );
  }
}
