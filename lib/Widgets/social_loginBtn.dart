import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Models/enum/button_type.dart';

class SocialLoginBtn extends StatelessWidget {
  const SocialLoginBtn({
    super.key,
    required this.btnTitle,
    required this.buttonType,
    this.onPressed,
  });

  final String btnTitle;
  final ButtonType buttonType;
  final VoidCallback? onPressed;

  // Static map for button styling configuration
  static final Map<ButtonType, _ButtonStyle> _buttonStyles = {
    ButtonType.google: const _ButtonStyle(
      icon: Icons.g_mobiledata_sharp,
      textColor: Colors.white,
      iconColor: Colors.white,
    ),
    ButtonType.facebook: const _ButtonStyle(
      icon: Icons.facebook,
      // buttonColor: Colors.blue,
      textColor: Colors.white,
      iconColor: Colors.white,
      // borderColor: Colors.blue,
    ),
    ButtonType.apple: const _ButtonStyle(
      icon: Icons.apple,
      // buttonColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.white,
      // borderColor: Colors.black,
    ),
    ButtonType.free: const _ButtonStyle(
      buttonColor: Colors.green,
      textColor: Color.fromARGB(255, 10, 10, 10),
      iconColor: Colors.white,
      borderColor: Colors.green,
    ),
    ButtonType.login: const _ButtonStyle(
      // buttonColor: Colors.transparent,
      textColor: Colors.white,
      iconColor: Colors.white,
      // borderColor: Colors.white,
    ),
  };

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: _buildButton(context),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final style = _buttonStyles[buttonType] ?? const _ButtonStyle();
    final buttonContent = _buildButtonContent(style);

    return switch (buttonType) {
      ButtonType.google || ButtonType.facebook || ButtonType.apple => 
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: style.borderColor),
            backgroundColor: style.buttonColor.withOpacity(0.1),
          ),
          child: buttonContent,
        ),
      ButtonType.free => 
        FilledButton(
          onPressed: onPressed ,
          style: FilledButton.styleFrom(
            backgroundColor: style.buttonColor,
            side: BorderSide(color: style.borderColor),
          ),
          child: buttonContent,
        ),
      _ => 
      TextButton(onPressed: onPressed, child: buttonContent)
    };
  }

  Widget _buildButtonContent(_ButtonStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (style.icon != null) ...[
          Icon(
            style.icon,
            color: style.iconColor,
            size: 24,
          ),
           SizedBox(width: 12.w),
        ],
        Expanded(
          child: Text(
            btnTitle,
            style: TextStyle(
              color: style.textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Helper class to store button styling properties
class _ButtonStyle {
  const _ButtonStyle({
    this.icon,
    this.buttonColor = Colors.grey,
    this.textColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.borderColor = Colors.grey,
  });

  final IconData? icon;
  final Color buttonColor;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;
}