import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/backend/backend.dart';
import 'package:stagemuse/services/auth/auth_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _bottomNavigationBloc = context.read<BottomNavigationBloc>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(gambarLogin),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: margin),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorSecondary.withOpacity(0.3),
                colorPrimary.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // App Name
                const SizedBox(height: 90),
                Text(
                  "SM",
                  style: bold72(colorPrimary),
                ),
                Text(
                  "Stagemuse",
                  style: bold24(colorThird),
                ),
                // Form
                // Email
                textFormFieldFill(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  hintText: "Email",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.email, color: Colors.white54),
                  leftMargin: 0,
                  topMargin: 85,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Password
                textFormFieldFill(
                  controller: _pwController,
                  keyboardType: TextInputType.visiblePassword,
                  obscure: true,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  hintText: "Password",
                  onTap: null,
                  fillColor: colorSecondary.withOpacity(0.3),
                  prefix: const Icon(Icons.lock, color: Colors.white54),
                  leftMargin: 0,
                  topMargin: 16,
                  rightMargin: 0,
                  bottomMargin: 0,
                ),
                // Button Forgot Password
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // Button Sign In || Button Sign Up
                Row(
                  children: [
                    // Button Sign In
                    Expanded(
                      child: BlocSelector<BackendResponseBloc,
                          BackendResponseValue, BackendResponseValue>(
                        selector: (state) {
                          return state;
                        },
                        builder: (context, state) {
                          return flatTextButton(
                            onPress: () {
                              // Update Bloc
                              _bottomNavigationBloc.add(
                                const SetBottomNavigation(0),
                              );
                              if (_emailController.text.isNotEmpty &&
                                  _pwController.text.isNotEmpty) {
                                authServices
                                    .signIn(
                                  email: _emailController.text,
                                  password: _pwController.text,
                                  context: context,
                                )
                                    .then((message) {
                                  // When Login Status Error
                                  if (message != null) {
                                    // Show snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          message,
                                          style: medium14(colorThird),
                                        ),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                // Show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                    content: RichText(
                                      text: TextSpan(
                                        text: "You haven't filled out your ",
                                        style: medium12(colorThird),
                                        children: [
                                          TextSpan(
                                            text: "EMAIL",
                                            style: bold12(colorThird),
                                          ),
                                          TextSpan(
                                            text: " or ",
                                            style: medium12(colorThird),
                                          ),
                                          TextSpan(
                                            text: "PASSWORD",
                                            style: bold12(colorThird),
                                          ),
                                          TextSpan(
                                            text: "!",
                                            style: medium12(colorThird),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            text:
                                (state.response.status == BackEndStatus.loading)
                                    ? "Loading..."
                                    : "Sign In",
                            textColor: colorThird,
                            buttonColor: colorPrimary,
                            leftMargin: 0,
                            rightMargin: 8,
                            topMargin: 40,
                            bottomMargin: 30,
                            width: double.infinity,
                            height: null,
                          );
                        },
                      ),
                    ),
                    // Button Create new account

                    // Expanded(
                    //   child: flatTextButton(
                    //     onPress: () {
                    //       // Update Bloc
                    //       _bottomNavigationBloc
                    //           .add(const SetBottomNavigation(0));
                    //       // Navigate
                    //       Navigator.push(
                    //         context,
                    //         navigatorTo(
                    //           context: context,
                    //           screen: const CreateAccountPage1(),
                    //         ),
                    //       );
                    //     },
                    //     text: "Sign Up",
                    //     textColor: colorPrimary,
                    //     buttonColor: colorThird,
                    //     leftMargin: 8,
                    //     rightMargin: 0,
                    //     topMargin: 48,
                    //     bottomMargin: 36,
                    //     width: double.infinity,
                    //     height: null,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?',
                        style: medium12(Colors.white54)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Update Bloc
                        _bottomNavigationBloc.add(const SetBottomNavigation(0));
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: const CreateAccountPage1(),
                          ),
                        );
                      },
                      child: Text('Sign Up',
                          style: medium12(Colors.white).copyWith(
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
