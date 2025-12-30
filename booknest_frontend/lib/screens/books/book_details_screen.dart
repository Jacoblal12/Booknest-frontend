import 'package:flutter/material.dart';
import 'package:booknest_frontend/models/book.dart';
// ignore: unused_import
import 'package:booknest_frontend/services/api_service.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  void showRequestSheet(BuildContext context, Book book) {
    final TextEditingController messageController = TextEditingController();
    final String requestType = book.availableFor;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Request Book",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // Show request type (read-only)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Request Type: ${requestType.toUpperCase()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Message (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await ApiService.sendBookRequest(
                      bookId: book.id,
                      requestType: requestType,
                      message: messageController.text,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Request sent successfully"
                              : "Failed to send request",
                        ),
                      ),
                    );
                  },
                  child: const Text("Send Request"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title), elevation: 1),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // BOOK COVER IMAGE
            // =====================
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                image: book.cover != null
                    ? DecorationImage(
                        image: NetworkImage("${book.cover}"),
                        fit: BoxFit.scaleDown,
                      )
                    : const DecorationImage(
                        image: AssetImage("assets/images/book_placeholder.png"),
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // =====================
            // TITLE + AUTHOR
            // =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                book.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                book.author,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),

            const SizedBox(height: 12),

            // =====================
            // AVAILABILITY SECTION
            // =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      book.availableFor.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =====================
            // DESCRIPTION
            // =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                book.description.trim().isNotEmpty == true
                    ? book.description
                    : "No description provided.",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
              ),
            ),

            const SizedBox(height: 30),

            // =====================
            // REQUEST ACTION BUTTON
            // =====================
            ElevatedButton(
              onPressed: () => showRequestSheet(context, book),
              child: const Text("Request Book"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
