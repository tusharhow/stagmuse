import 'package:flutter/material.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Custom.back, color: colorThird),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(color: colorThird),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(gambarPassword),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Form
              // Email
              textFormFieldFill(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white54),
                hintText: "Email",
                onTap: null,
                fillColor: colorSecondary.withOpacity(0.3),
                prefix: const Icon(Icons.email, color: Colors.white54),
                leftMargin: 0,
                topMargin: 0,
                rightMargin: 0,
                bottomMargin: 0,
              ),
              const SizedBox(height: margin / 2),
              // Button Send
              flatTextButton(
                onPress: () {
                  if (_emailController.text.isNotEmpty) {
                    authServices
                        .changePassword(_emailController.text)
                        .then((success) {
                      if (success) {
                        // Show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            backgroundColor: colorPrimary,
                            content: Text(
                              "A link to change your password has been sent to your email. Please check your email",
                              style: medium12(colorThird),
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
                text: "Send",
                textColor: colorThird,
                buttonColor: colorPrimary,
                leftMargin: 0,
                rightMargin: 0,
                topMargin: 48,
                bottomMargin: 48,
                width: double.infinity,
                height: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
