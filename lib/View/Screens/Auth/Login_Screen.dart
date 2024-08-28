import 'package:aichat/View/Base_widgets/Button_Widget.dart';
import 'package:aichat/View/Base_widgets/Txtfield_Round.dart';
import 'package:aichat/View/Screens/Auth/Forgotpass.dart';
import 'package:aichat/View/Screens/Auth/registeration_screen.dart';
import 'package:aichat/View/Screens/DashBoard/DashBoard.dart';
import 'package:aichat/main.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ////firebase auth ///
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final PreferenceManager preferenceManager = PreferenceManager();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            elevation: 3,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3,
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //TODO: Add text fields for email and password
                        TextField_Round(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                          maxlines: 1,
                          //
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please A Valid Email';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(Icons.title),
                        ),
                        const SizedBox(height: 15),

                        ///second text field ===Password
                        TextField_Round(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: false,
                          maxlines: 1,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          //
                          prefixIcon: const Icon(Icons.title),
                        ),

                        const SizedBox(height: 30),
                        //form submit button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 50,
                            width: 3000,
                            child: ButtonWidget(
                                btnText: "Login",
                                color: Theme.of(Get.context!)
                                    .colorScheme
                                    .secondary,
                                isloading:
                                    context.watch<ProfileProvider>().isLoading,
                                onPress: () async {
                                  Provider.of<ProfileProvider>(
                                    context,
                                    listen: false,
                                  ).login(
                                    emailController.text,
                                    passwordController.text,
                                    context,
                                  );
                                }),
                          ),
                        ),
                        //end of material button
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Utils.jumpPage(context, const ForgotPasswordView());
                          },
                          child: Text(
                            "Forgot Password?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        //TODO: sign up here or register here

                        const SizedBox(
                          height: 10,
                        ),
                        //registration page
                        ////
                        InkWell(
                          onTap: () {
                            Utils.pushReplacement(
                                context, const RegisterationScreen());
                          },
                          child: Text(
                            "Not having an account? Register here",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Utils.pushReplacement(context, const DashBoard());
                          },
                          child: Text(
                            "Conitue as guest",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
