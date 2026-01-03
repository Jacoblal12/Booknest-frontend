import 'package:flutter/material.dart';
import 'package:booknest_frontend/services/api_service.dart';
import 'package:booknest_frontend/models/book_request.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  late Future<List<BookRequest>> requestsFuture;

  @override
  void initState() {
    super.initState();
    requestsFuture = ApiService.getMyRequests();
  }

  Color statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Requests")),

      body: FutureBuilder<List<BookRequest>>(
        future: requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No requests yet"));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final r = requests[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: r.bookCover != null
                      ? Image.network(
                          r.bookCover!,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.book),

                  title: Text(r.bookTitle),
                  subtitle: Text("Type: ${r.requestType.toUpperCase()}"),

                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor(r.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      r.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor(r.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
