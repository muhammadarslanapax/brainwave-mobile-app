import 'package:aichat/View/Base_widgets/Button_Widget.dart';
import 'package:aichat/View/Base_widgets/Txtfield_Round.dart';
import 'package:aichat/View/Screens/Auth/Login_Screen.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  //const ForgotPassword({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailcontr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //backgroundColor: Colors.amber,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  child: Image.asset("images/Category/chatbot.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "We Got Your Back",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField_Round(
                  maxlines: 1,
                  //siconn: Icons.email,
                  controller: emailcontr,
                  hintText: "Email",
                  keyType: TextInputType.emailAddress,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    width: 3000,
                    child: ButtonWidget(
                        btnText: "Reset",
                        isloading: context.watch<ProfileProvider>().isLoading,
                        onPress: () async {
                          Provider.of<ProfileProvider>(
                            context,
                            listen: false,
                          ).resetPassword(emailcontr.text);
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back To Login?",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }),
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
