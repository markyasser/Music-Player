import 'package:flutter/material.dart';
import 'package:music_player/business_logic/auth/auth_cubit.dart';
import 'package:music_player/business_logic/music/music_cubit.dart';
import 'package:music_player/business_logic/music/play_pause_cubit.dart';
import 'package:music_player/constants/strings.dart';
import 'package:music_player/data/model/user_model.dart';
import 'package:music_player/data/repository/auth_repo.dart';
import 'package:music_player/data/repository/music_repo.dart';
import 'package:music_player/data/web_services/auth_webservices.dart';
import 'package:music_player/data/web_services/music_webservices.dart';
import 'package:music_player/presentation/screens/auth/login.dart';
import 'package:music_player/presentation/screens/auth/signup.dart';
import 'package:music_player/presentation/screens/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/presentation/screens/upload.dart';

class AppRouter {
  // declare repository and cubit objects
  late AuthRepository authRepo;
  late AuthCubit authCubit;
  late AuthWebService authWebService;

  late MusicRepository musicRepo;
  late MusicCubit musicCubit;
  late MusicWebService musicWebService;
  late PlayPauseCubit playPauseCubit;
  AppRouter() {
    // auth
    authWebService = AuthWebService();
    authRepo = AuthRepository(authWebService);
    authCubit = AuthCubit(authRepo);
    // music
    musicWebService = MusicWebService();
    musicRepo = MusicRepository(musicWebService);
    musicCubit = MusicCubit(musicRepo);
    playPauseCubit = PlayPauseCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return UserData.isLoggedIn
            ? MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: musicCubit),
                        BlocProvider.value(value: playPauseCubit),
                      ],
                      child: const Home(),
                    ))
            : MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: authCubit,
                      child: const Login(),
                    ));
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case uploadMusicRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: musicCubit,
                  child: const Upload(),
                ));

      default:
        return null;
    }
  }
}
