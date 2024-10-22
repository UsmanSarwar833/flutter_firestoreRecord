import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_providers/authentication_provider.dart';
import '../../../../core/common/app_utility.dart';
import '../../../../dependency_injection.dart';
import '../signin/sign_in_widgets/sign_in-widget.dart';
import '../widgets/process_loading_light.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'usman');
  final TextEditingController emailController =
      TextEditingController(text: '@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '12345678');
  final TextEditingController confirmPasswordController =
      TextEditingController(text: '12345678');
  final _formKey = GlobalKey<FormState>();
  final authProvider = sl<AuthenticationProvider>();

  void _onSignUpPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await authProvider.signUp(
      context,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );


    if (response != null) {
      await authProvider
          .addUser(
              userModel: UserProfileModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        uId: response,
      ))
          .then((success) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    TextStyle descriptionStyle =
        TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500);
    return Consumer<AuthenticationProvider>(
        builder: (context, authState, child) {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.white,
              appBar: authAppBar("Sign Up"),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text("Enter your details below & free sign up",
                              style: descriptionStyle),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        formFieldTitle("User name"),
                        formField(
                          hintText: "Enter your name",
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          onValidator: (value) => AppUtility.validateName(
                              context, value.trim(), "Enter your name"),
                          textInputAction: TextInputAction.next,
                        ),
                        formFieldTitle("Email"),
                        formField(
                          hintText: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          onValidator: (value) => AppUtility.validateEmail(
                            context,
                            value.trim(),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        formFieldTitle("Password"),
                        formField(
                          hintText: "Enter your Password",
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          onValidator: (value) => AppUtility.validatePassword(
                              context, value.trim(), "Enter your Password"),
                          textInputAction: TextInputAction.next,
                        ),
                        formFieldTitle("Confirm Password"),
                        formField(
                          hintText: "Enter your Confirm Password",
                          keyboardType: TextInputType.text,
                          controller: confirmPasswordController,
                          onValidator: (value) =>
                              AppUtility.validateConfirmPassword(
                                  context,
                                  value.trim(),
                                  passwordController.text,
                                  "Please enter confirm password"),
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        button(
                          buttonStyle.copyWith(color: Colors.white),
                          Colors.indigo.withOpacity(0.9),
                          "Sign Up",
                          () {
                            _onSignUpPressed();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          if (authState.signUpStatus == AuthStatus.loading ||
              authState.addUserStatus == AuthStatus.loading)
            const ProcessLoadingLight()
        ],
      );
    });
  }
}
