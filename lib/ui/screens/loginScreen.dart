import 'package:flutter/material.dart';
import 'package:untitled2/ui/screens/sign-up-screen.dart';
import 'package:untitled2/ui/screens/verify-with-email.dart';

import '../../data/network-utils.dart';
import '../utils/auth-utils.dart';
import '../utils/snackbar-message.dart';
import '../utils/text-styles.dart';
import '../widgets/app-elevated-button.dart';
import '../widgets/app-text-button.dart';
import '../widgets/app-text-form-field.dart';
import '../widgets/screen-Background-images.dart';
import 'main-bottom-navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool inProgress = false;

  Future<void> login() async {
    inProgress = true;
    setState(() {});
    final result = await NetworkUtils()
        .postMethod('https://task.teamrabbil.com/api/v1/login', body: {
      'email': emailTextController.text.trim(),
      'password': passwordTextController.text
    }, onUnAuthorize: () {
      showSnackBarMessage(
          context, 'Email or Password is incorrect. Try again!', true);
    });
    inProgress = false;
    setState(() {});
    if (result != null && result['status'] == 'success') {
      /// save user information
      await AuthUtils.saveUserData(
        result['data']['firstName'],
        result['data']['lastName'],
        result['token'],
        result['data']['photo'],
        result['data']['mobile'],
        result['data']['email'],
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainBottomNavBar()),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started With',
                style: screenTitleTextStyle,
              ),
              const SizedBox(
                height: 24,
              ),
              AppTextFormFieldWidget(
                hintText: 'Email',
                controller: emailTextController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              AppTextFormFieldWidget(
                obscureText: true,
                hintText: 'Password',
                controller: passwordTextController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your valid password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              if (inProgress)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                AppElevatedButton(
                  child: const Icon(Icons.arrow_forward_ios),
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyWithEmail()));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              AppTextButton(
                text1: "Don't Have an Account?",
                text2: 'Sign up',
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
