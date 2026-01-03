import 'package:flutter/material.dart';

// Import screens (create these one by one if not done yet)
import '../books/my_books_screen.dart';
import 'my_requests_screen.dart';
// import 'my_transactions_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), elevation: 1),

      body: ListView(
        children: [
          const SizedBox(height: 16),

          /// PROFILE HEADER
          Center(
            child: Column(
              children: const [
                CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 8),
                Text(
                  "Welcome 👋",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          /// MY BOOKS
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("My Books"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBooksScreen()),
              );
            },
          ),

          /// MY REQUESTS
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text("My Requests"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
              );
            },
          ),

          /// MY TRANSACTIONS
          // ListTile(
          //   leading: const Icon(Icons.swap_horiz),
          //   title: const Text("My Transactions"),
          //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const MyTransactionsScreen()),
          //     );
          //   },
          // ),
          const Divider(),

          /// LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: clear token + navigate to login
            },
          ),
        ],
      ),
    );
  }
}
