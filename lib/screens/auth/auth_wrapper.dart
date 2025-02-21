import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../home/home_screen.dart';
import '../profile/profile_setup_screen.dart';
import 'sign_in_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) {
          return const SignInScreen();
        }

        // Check if user has completed profile setup
        return StreamBuilder(
          stream: context.read<ProfileService>().profileStream(
            auth.currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final hasProfile = snapshot.hasData;
            if (!hasProfile) {
              return const ProfileSetupScreen();
            }

            return const HomeScreen();
          },
        );
      },
    );
  }
}
