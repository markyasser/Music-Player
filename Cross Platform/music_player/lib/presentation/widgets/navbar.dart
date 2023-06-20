import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/business_logic/auth/auth_cubit.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  Widget notAuthButtons(context) {
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

  void _showMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Size screenSize = MediaQuery.of(context).size;
    final RelativeRect position = RelativeRect.fromLTRB(
      screenSize.width - button.size.width,
      kToolbarHeight,
      0,
      0,
    );
    final result = await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 1,
          onTap: () {
            BlocProvider.of<AuthCubit>(context).logout();
          },
          child: const Text('Log out'),
        ),
      ],
    );
    if (result != null) {
      // Handle menu item selection
    }
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
          child: Row(
            children: const [
              Text(' Upload ',
                  style: TextStyle(
                    fontSize: 17,
                    // fontWeight: FontWeight.bold,
                  )),
              Icon(Icons.file_upload_outlined)
            ],
          ),
        ),
        const SizedBox(width: 10),
        // username
        InkWell(
          onTap: () => _showMenu(context),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 15,
                    backgroundImage: UserData.user!.profilePicture == ''
                        ? null
                        : NetworkImage(UserData.user!.profilePicture!),
                    child: UserData.user!.profilePicture == ''
                        ? const Icon(Icons.person)
                        : null),
                const SizedBox(width: 5),
                Text(
                  UserData.user!.username!,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
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
        UserData.isLoggedIn
            ? BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LogoutSuccessfully) {
                    Navigator.pushReplacementNamed(context, loginRoute);
                  }
                },
                child: authButtons(context),
              )
            : notAuthButtons(context),
      ],
    );
  }
}
