import 'package:chatify/controller/auth_controller.dart';
import 'package:chatify/view/screen/bottombar_screen.dart';
import 'package:chatify/view/screen/register_screen.dart';
import 'package:chatify/view/widget/app_text.dart';
import 'package:chatify/view/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown, Color.fromARGB(255, 19, 11, 111)],
          ),
        ),
        child: Consumer<AuthController>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    name: 'Welcome Back',
                    fontsize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  CustomTextfield(
                    controller: email,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email is required'
                        : null,
                  ),

                  const SizedBox(height: 15),
                  CustomTextfield(
                    controller: password,
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    validator: (value) => value == null || value.length < 6
                        ? 'Minimum 6 characters'
                        : null,
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: value.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final success = await value.signIn(
                                email.text.trim(),
                                password.text.trim(),
                              );

                              if (!mounted)
                                return; // ✅ Check if widget is still active

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BottombarScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: AppText(
                                      name: 'Invalid email or password',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: value.isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : AppText(name: 'Submit'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        name: 'Not registered?',
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: const AppText(
                          name: 'Register',
                          color: Colors.blue,
                          fontsize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
