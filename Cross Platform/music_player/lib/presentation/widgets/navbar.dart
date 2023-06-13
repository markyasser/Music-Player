import 'package:flutter/material.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  Widget NotAuthButtons(context) {
    return Row(
      //login button
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, loginRoute),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(' Login ',
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              )),
        ),
        const SizedBox(width: 10),
        // sign up button
        ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, signupRoute),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: Colors.red,
              // fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget authButtons(context) {
    return Row(
      //Upload button
      children: [
        ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, uploadMusicRoute),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(' Upload ',
              style: TextStyle(
                fontSize: 17,
                // fontWeight: FontWeight.bold,
              )),
        ),
        const SizedBox(width: 10),
        // username
        Text(UserData.user!.username!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //title
        GestureDetector(
          onTap: () => UserData.isLoggedIn
              ? Navigator.pushReplacementNamed(context, homePageRoute)
              : Navigator.pushReplacementNamed(context, loginRoute),
          child: Text(
            "iMusic",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Colors.red, Colors.yellow],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(const Rect.fromLTWH(0, 0, 100, 0)),
            ),
          ),
        ),
        UserData.isLoggedIn ? authButtons(context) : NotAuthButtons(context),
      ],
    );
  }
}
