import 'package:firestore_record/screens/mainHome/record/signin/sign_in_widgets/sign_in-widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app_providers/authentication_provider.dart';
import '../../../../core/common/app_utility.dart';
import '../../../../dependency_injection.dart';
import '../../../../route/routeString.dart';
import '../widgets/process_loading_light.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController(text: "@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: '12345678');
  final _formKey = GlobalKey<FormState>();
  final authProvider = sl<AuthenticationProvider>();

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    authProvider.signIn(context, email: emailController.text, password: passwordController.text).then((success){

      emailController.clear();
      passwordController.clear();
    });


  }

  @override
  Widget build(BuildContext context) {
    TextStyle forgotPass = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      decoration: TextDecoration.underline,
      decorationThickness: 1,
    );
    TextStyle buttonStyle = const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Consumer<AuthenticationProvider>(
          builder: (context, authState, child) {
            return Stack(
              children: [
                Scaffold(
                backgroundColor: Colors.white,
                appBar: authAppBar("Log In"),
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08),
                          formFieldTitle("Email"),
                          formField(
                            hintText: "Enter your email address",
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onValidator: (value) =>
                                AppUtility.validateEmail(context, value?.trim()),
                            textInputAction: TextInputAction.next,
                          ),
                          formFieldTitle("Password"),
                          formField(
                            hintText: "Enter your Password",
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            onValidator: (value) => AppUtility.validatePassword(
                                context, value?.trim(), 'Please enter password'),
                            textInputAction: TextInputAction.done,

                          ),
                          const SizedBox(height: 40),
                          button(buttonStyle.copyWith(color: Colors.white),
                            Colors.indigo.withOpacity(0.9), "Log In", () {
                              _onLoginPressed();
                            },),
                          button(buttonStyle, Colors.white, "Sign Up", () {
                            Navigator.pushNamed(context, RouteString.signUpRoute);
                          },),
                        ],
                      ),
                    ),
                  ),
                )),
                if(authState.signInStatus == AuthStatus.loading)
                  const ProcessLoadingLight()
              ],
            );
      })),
    );

  }
}

