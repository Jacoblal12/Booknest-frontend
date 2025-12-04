import 'package:flutter/material.dart';
import 'package:booknest_frontend/models/book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Center(
              child: Container(
                height: 240,
                width: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: book.cover != null
                      ? DecorationImage(
                          image: NetworkImage(book.cover!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage(
                            "assets/images/book_placeholder.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Author
            Text(
              "by ${book.author}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Availability
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(50),
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

            const SizedBox(height: 20),

            // Description
            Text(
              book.description?.trim().isNotEmpty == true
                  ? book.description!
                  : "No description provided.",
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 24),

            // Request Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: send book request
                },
                child: Text("Request ${book.availableFor}"),
              ),
            ),

            const SizedBox(height: 12),

            // Wishlist Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: add to wishlist API
                },
                child: const Text("Add to Wishlist"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
