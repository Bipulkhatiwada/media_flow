import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_flow/Data/SecuredStorage/secure_storage.dart';
import 'package:media_flow/Models/enum/secure_torage_keys.dart';
import 'package:media_flow/core/Navigation/navigation_service.dart';

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key, required this.title});

  final String title;

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'example@domain.com',
                    hintStyle: TextStyle(color: Colors.white70),
                    helperText: "You need to confirm your mail later",
                    helperStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 251, 252, 251)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-mail is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid e-mail address';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: 16.h),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                       SecureStorage().saveSecureData(SecureStorageKey.email, _emailController.text);
                      NavigationService.navigateToSetupPassword(context);
                  }
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
