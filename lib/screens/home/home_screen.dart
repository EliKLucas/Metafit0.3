import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../models/user_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userId = authService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MetaFit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body:
          userId == null
              ? const Center(child: Text('No user logged in'))
              : StreamBuilder<UserProfile?>(
                stream: context.read<ProfileService>().profileStream(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final profile = snapshot.data;
                  if (profile == null) {
                    return const Center(child: Text('No profile found'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, ${profile.name ?? "User"}!'),
                        const SizedBox(height: 16),
                        Text(
                          'Fitness Goal: ${profile.fitnessGoal ?? "Not set"}',
                        ),
                        Text(
                          'Experience Level: ${profile.experienceLevel ?? "Not set"}',
                        ),
                        // We'll add more widgets here as we develop the app
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
