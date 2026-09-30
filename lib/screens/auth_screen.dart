import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../constants/app_sizes.dart';
import 'home_screen.dart';
import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool loading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

 Future<void> authenticate() async {
  if (mounted) {
    setState(() => loading = true);
  }

try {
  print("Starting authentication...");

  if (isLogin) {
    print("Logging in...");

    final response = await supabase.auth.signInWithPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    print(response.user);
  } else {
    print("Creating account...");

    final response = await supabase.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      data: {
        'name': nameController.text.trim(),
      },
    );

    print(response.user);

    if (response.user != null) {
      print("Saving profile...");

      await supabase.from('profiles').upsert({
        'id': response.user!.id,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
      });

      print("Profile saved.");
    }
  }

  print("Authentication successful.");

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const AuthGate(),
    ),
  );
}
catch (e, stack) {
  print(e);
  print(stack);

  showMessage(e.toString());
}

  if (mounted) {
    setState(() => loading = false);
  }
}
      

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      const Icon(
                        Icons.self_improvement,
                        size: 75,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        isLogin
                            ? "Welcome Back 🌿"
                            : "Create Account",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Your peaceful space begins here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      if (!isLogin)
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),

                      if (!isLogin)
                        const SizedBox(height: 16),

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon:
                              const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword =
                                    !obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed:
                            loading ? null : authenticate,
                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isLogin
                                    ? "LOGIN"
                                    : "CREATE ACCOUNT",
                              ),
                      ),

                      const SizedBox(height: 15),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Create a new account"
                              : "Already have an account?",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}