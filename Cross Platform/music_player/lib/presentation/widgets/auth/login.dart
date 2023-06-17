import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/business_logic/auth/auth_cubit.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _obscureText = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("token");
      if (token != null && token.isNotEmpty) {
        BlocProvider.of<AuthCubit>(context).getUser(token);
      }
    });
    super.initState();
  }

  void handleLogin() {
    String username = usernameController.text;
    String password = passwordController.text;
    // make login request
    BlocProvider.of<AuthCubit>(context).login(username, password);
  }

  Widget loginBody() {
    return Center(
      child: Column(
        children: [
          const Text("Log in",
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
              onPressed: () => handleLogin(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  }
                  return const Text('Login', style: TextStyle(fontSize: 19));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessfully) {
            Navigator.pushReplacementNamed(context, homePageRoute);
          } else if (state is GetUserSuccessfully) {
            Navigator.pushReplacementNamed(context, homePageRoute);
          }
        },
        child: loginBody());
  }
}
