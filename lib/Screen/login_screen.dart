import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Models/enum/button_type.dart';
import 'package:media_flow/features/auth/screens/signUp_email_screen.dart';
import 'package:media_flow/Widgets/social_loginBtn.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(66, 87, 86, 86),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                'assets/images/login_bg.png',
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
             SizedBox(height: 20.h),
            SocialLoginBtn(
              btnTitle: "Sign Up for free",
              buttonType: ButtonType.free,
              onPressed: () => _handleNavigation(context, ButtonType.free),
            ),
            SocialLoginBtn(
              btnTitle: "Continue with google",
              buttonType: ButtonType.google,
              onPressed: () => _handleNavigation(context, ButtonType.google),
            ),
            SocialLoginBtn(
              btnTitle: "Continue with Facebook",
              buttonType: ButtonType.facebook,
              onPressed: () => _handleNavigation(context, ButtonType.facebook),
            ),
            SocialLoginBtn(
              btnTitle: "Continue with Apple",
              buttonType: ButtonType.apple,
              onPressed: () => _handleNavigation(context, ButtonType.apple),
            ),
            SocialLoginBtn(
              btnTitle: "Login",
              buttonType: ButtonType.login,
              onPressed: () => _handleNavigation(context, ButtonType.login),
            ),
          ],
        ),
      ),
    );
  }


   void _handleNavigation(BuildContext context, ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.free:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpEmailScreen(title: "Email"),
          ),
        );
        break;
      case ButtonType.google:
       
        break;
      case ButtonType.facebook:
        
        break;
      case ButtonType.apple:
       
        break;
      case ButtonType.login:
        
        break;
    }
  }

}