class BookRequest {
  final int id;
  final String requestType;
  final String status;
  final String bookTitle;
  final String? bookCover;
  final DateTime createdAt;

  BookRequest({
    required this.id,
    required this.requestType,
    required this.status,
    required this.bookTitle,
    this.bookCover,
    required this.createdAt,
  });

  factory BookRequest.fromJson(Map<String, dynamic> json) {
    return BookRequest(
      id: json['id'],
      requestType: json['request_type'],
      status: json['status'],
      bookTitle: json['book']['title'],
      bookCover: json['book']['cover'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
