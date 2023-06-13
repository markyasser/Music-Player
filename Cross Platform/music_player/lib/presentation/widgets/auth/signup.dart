import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool _obscureText = true;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void handleLogin() {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    // make sign up request
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Register",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          SizedBox(
            width: 400,
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 19)),
            ),
          ),
        ],
      ),
    );
  }
}
