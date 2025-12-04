import 'package:flutter/material.dart';
import 'package:booknest_frontend/services/api_service.dart';
import 'package:booknest_frontend/models/book.dart';
import 'package:booknest_frontend/widgets/book_card.dart'; // <-- FIXED

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<List<Book>> allBooksFuture;
  late Future<List<Book>> myBooksFuture;

  @override
  void initState() {
    super.initState();
    allBooksFuture = ApiService.getBooks();
    myBooksFuture = ApiService.getMyBooks();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text("Books"),
          bottom: const TabBar(
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "All Books"),
              Tab(text: "My Books"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            _buildBooksGrid(allBooksFuture),
            _buildBooksGrid(myBooksFuture),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksGrid(Future<List<Book>> future) {
    return FutureBuilder<List<Book>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No books found"));
        }

        final books = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 260,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookCard(book: books[index]);
          },
        );
      },
    );
  }
}
