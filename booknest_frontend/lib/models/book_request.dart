class BookRequest {
  final int id;
  final String requestType;
  final String status;
  final String bookTitle;
  final String? bookCover;
  final String requesterUsername;
  final String bookOwnerUsername;
  final DateTime createdAt;

  BookRequest({
    required this.id,
    required this.requestType,
    required this.status,
    required this.bookTitle,
    this.bookCover,
    required this.requesterUsername,
    required this.bookOwnerUsername,
    required this.createdAt,
  });

  factory BookRequest.fromJson(Map<String, dynamic> json) {
    return BookRequest(
      id: json['id'],
      requestType: json['request_type'],
      status: json['status'],
      bookTitle: json['book_title'],
      bookCover: json['book_cover'],
      requesterUsername: json['requester_username'],
      bookOwnerUsername: json['book_owner_username'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
