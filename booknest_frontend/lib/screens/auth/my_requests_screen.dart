import 'package:flutter/material.dart';
import 'package:booknest_frontend/services/api_service.dart';
import 'package:booknest_frontend/models/book_request.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Requests")),
      body: FutureBuilder<List<BookRequest>>(
        future: ApiService.getMyRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(child: Text("No requests found"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _RequestCard(request: requests[index]);
            },
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BookRequest request;

  const _RequestCard({required this.request});

  bool get isRequester =>
      request.requesterUsername == ApiService.currentUsername;

  bool get isOwner => request.bookOwnerUsername == ApiService.currentUsername;

  bool get isPending => request.status == "pending";

  bool get isApproved => request.status == "approved";

  @override
  Widget build(BuildContext context) {
    print("DEBUG REQUEST:");
    print("requesterUsername = ${request.requesterUsername}");
    print("bookOwnerUsername = ${request.bookOwnerUsername}");
    print("currentUser = ${ApiService.currentUsername}");

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.bookTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text("Requested by: ${request.requesterUsername}"),

            const SizedBox(height: 6),

            _StatusChip(status: request.status),

            const SizedBox(height: 12),

            // 👇 ACTION BUTTONS
            if (isPending) ...[
              // OWNER ACTIONS
              if (isOwner)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(context, "approved"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Approve"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(context, "rejected"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Reject"),
                      ),
                    ),
                  ],
                ),

              // REQUESTER ACTION
              if (isRequester && !isOwner)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _cancelRequest(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Cancel Request"),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    final success = await ApiService.updateRequestStatus(
      requestId: request.id,
      status: newStatus,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Request $newStatus" : "Failed to update request",
        ),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  Future<void> _cancelRequest(BuildContext context) async {
    final success = await ApiService.cancelRequest(request.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Request cancelled" : "Failed to cancel request",
        ),
      ),
    );

    if (success) {
      Navigator.pop(context); // TEMP (we’ll fix refresh next)
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "approved":
        color = Colors.green;
        break;
      case "rejected":
        color = Colors.red;
        break;
      case "pending":
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
