import 'package:aichat/View/Base_widgets/Txtfield_Round.dart';
import 'package:aichat/View/Screens/Auth/Login_Screen.dart';
import 'package:aichat/model/UserModel.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  //instatiate shared prefs

  // final PreferenceManager prefsManager = PreferenceManager();

  //formkey
  final _formKey = GlobalKey<FormState>();

  //initialize firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Your Details To Register An Account',
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 20,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.bold,
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
                        height: 40,
                      ),
                      //TODO: Add text fields for email and password
                      TextField_Round(
                        hintText: "Name",
                        obscureText: false,
                        maxlines: 1,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                        controller: userNameController,
                        prefixIcon: const Icon(Icons.title),
                      ),
                      const SizedBox(height: 15),
                      TextField_Round(
                        hintText: "Email",
                        obscureText: false,
                        keyType: TextInputType.emailAddress,
                        maxlines: 1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please A Valid Email';
                          }
                          return null;
                        },
                        controller: emailController,
                        prefixIcon: const Icon(Icons.title),
                      ),
                      const SizedBox(height: 15),
                      TextField_Round(
                        controller: phoneController,
                        hintText: "Phone Number",
                        obscureText: false,
                        maxlines: 1,
                        keyType: TextInputType.phone,
                        // validator: (value) {
                        //   if (value!.isEmpty || value.length < 6) {
                        //     return '''Passowrd lenght should be more than 6 characters''';
                        //   }
                        //   return null;
                        // },
                        prefixIcon: const Icon(Icons.title),
                      ),
                      const SizedBox(height: 15),

                      ///second text field ===Password
                      TextField_Round(
                        hintText: "Password",
                        obscureText: false,
                        maxlines: 1,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        prefixIcon: const Icon(Icons.title),
                      ),
                      // confirm password textfield
                      const SizedBox(height: 15),
                      TextField_Round(
                        controller: confirmController,
                        hintText: "Repeat Password",
                        obscureText: false,
                        maxlines: 1,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return '''Passowrd lenght should be more than 6 characters''';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.title),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            UserModel user = UserModel(
                              name: userNameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              endDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 180)
                                  .toString(),
                              startDate: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day)
                                  .toString(),
                              status: true,
                            );
                            Provider.of<ProfileProvider>(context, listen: false)
                                .signUp(user, context);
                          }
                        },
                        child: Text(
                          "Register An Account",
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Utils.pushReplacement(context, const LoginScreen());
                        },
                        child: Text(
                          "Already having an account? Login here",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
