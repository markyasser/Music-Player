import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/business_logic/auth/auth_cubit.dart';
import 'package:music_player/constants/strings.dart';

class VerifyOTPWidget extends StatefulWidget {
  String userId;
  String email;
  VerifyOTPWidget({super.key, required this.userId, required this.email});

  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget> {
  final otpController = TextEditingController();
  void handleVerify() {
    String otp = otpController.text;
    // make sign up request
    BlocProvider.of<AuthCubit>(context).verifyOTP(widget.userId, otp);
  }

  Widget body() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Text('Verify Your Email !',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('we have sent you an email with a verification code',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          SizedBox(
            width: 400,
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'OTP verification code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () => handleVerify(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is VerifyOTPLoading) {
                    return const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  }
                  return const Text('Verify', style: TextStyle(fontSize: 19));
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // resend otp
                  BlocProvider.of<AuthCubit>(context)
                      .resendOTPverification(widget.userId, widget.email);
                },
                child: const Text('Resend OTP',
                    style: TextStyle(fontSize: 14, color: Colors.red)),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is ResendOTPLoading) {
                    return const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyOTPSuccessfully) {
          Navigator.pushReplacementNamed(context, homePageRoute);
        }
      },
      child: body(),
    );
  }
}
