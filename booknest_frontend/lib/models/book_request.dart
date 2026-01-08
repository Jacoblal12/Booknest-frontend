class BookRequest {
  final int id;
  final String requestType;
  final String status;

  // Book info
  final String bookTitle;
  final String? bookCover;

  // User info (NEW)
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

      bookTitle: json['book']['title'],
      bookCover: json['book']['cover'],

      requesterUsername: json['requester']['username'],
      bookOwnerUsername: json['book']['owner']['username'],

      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
