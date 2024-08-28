import 'dart:io';

import 'package:aichat/View/Base_widgets/AppBarCustom.dart';
import 'package:aichat/View/Base_widgets/Button_Widget.dart';
import 'package:aichat/View/Base_widgets/Txtfield_Round.dart';
import 'package:aichat/main.dart';
import 'package:aichat/model/UserModel.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../Base_widgets/customsnackBar.dart';

class ProfileEdit_Screen extends StatefulWidget {
  const ProfileEdit_Screen({super.key});

  @override
  State<ProfileEdit_Screen> createState() => _ProfileEdit_ScreenState();
}

class _ProfileEdit_ScreenState extends State<ProfileEdit_Screen> {
  TextEditingController namecont = TextEditingController();
  TextEditingController phonecont = TextEditingController();
  TextEditingController emailcont = TextEditingController();
  TextEditingController passwordcont = TextEditingController();
  TextEditingController passwordcont2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (Provider.of<ProfileProvider>(Get.context!).loggedInUser != null) {
      namecont.text =
          Provider.of<ProfileProvider>(Get.context!).loggedInUser!.name ?? "";
      phonecont.text = Provider.of<ProfileProvider>(Get.context!)
              .loggedInUser!
              .phone_number ??
          "";
      emailcont.text =
          Provider.of<ProfileProvider>(Get.context!).loggedInUser!.email ?? "";
      passwordcont.text =
          Provider.of<ProfileProvider>(Get.context!).loggedInUser!.password ??
              "";
      passwordcont2.text =
          Provider.of<ProfileProvider>(Get.context!).loggedInUser!.password ??
              "";
    }
  }

  bool isVisible = true;
  bool isVisible2 = true;
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: AppBarCustom(
            title: "Edit your profile",
          ),
        ),
        //backgroundColor: ScfColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   //crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Row(
                //       children: [
                //         const SizedBox(
                //           width: 120,
                //         ),
                //         Stack(
                //           children: [
                //             //),
                //             AppConstants.loggedInUser!.image != null
                //                 ? imageFile == null
                //                     ? CircleAvatar(
                //                         radius: 50,
                //                         backgroundImage: NetworkImage(
                //                             AppConstants.loggedInUser!.image!),
                //                       )
                //                     : CircleAvatar(
                //                         radius: 50,
                //                         backgroundImage: FileImage(imageFile!),
                //                       )
                //                 : const CircleAvatar(
                //                     radius: 50,
                //                     backgroundImage: NetworkImage(
                //                         "https://e7.pngegg.com/pngimages/771/79/png-clipart-avatar-bootstrapcdn-graphic-designer-angularjs-avatar-child-face.png"),
                //                   ),
                //             Positioned(
                //               bottom: 0.2,
                //               right: 0.2,
                //               //left: 50,
                //               child: GestureDetector(
                //                 onTap: () {
                //                   showDialog(
                //                     barrierDismissible: false,
                //                     context: context,
                //                     builder: (context) => AlertDialog(
                //                       actions: <Widget>[
                //                         Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.end,
                //                           children: [
                //                             IconButton(
                //                               onPressed: (() {
                //                                 Navigator.of(context).pop();
                //                               }),
                //                               icon: const Icon(Icons.cancel),
                //                             ),
                //                           ],
                //                         ),
                //                       ],
                //                     ),
                //                   );
                //                 },
                //                 child: const Icon(
                //                   //size: 35,
                //                   Icons.camera_alt,
                //                   size: 35,
                //                   color: Colors.amber,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(
                //           width: 60,
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                TextField_Round(
                  controller: namecont,
                  hintText: "Name",
                  keyType: TextInputType.text,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person),
                  //sufixIcon: Icons.remove_red_eye,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField_Round(
                  maxlines: 1,
                  controller: emailcont,
                  hintText: "Email",
                  keyType: TextInputType.text,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email),
                  //sufixIcon: Icons.remove_red_eye,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField_Round(
                  maxlines: 1,
                  controller: phonecont,
                  hintText: "Phone Number",
                  keyType: TextInputType.phone,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.call),
                  // sufixIcon: Icons.remove_red_eye,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField_Round(
                  maxlines: 1,
                  controller: passwordcont,
                  hintText: "Password",
                  keyType: TextInputType.text,
                  obscureText: isVisible,
                  prefixIcon: const Icon(Icons.password),
                  suffixIconPress: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  sufixIcon:
                      isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField_Round(
                  maxlines: 1,
                  controller: passwordcont2,
                  hintText: "Repeat Password",
                  keyType: TextInputType.text,
                  obscureText: isVisible2,
                  prefixIcon: const Icon(Icons.password),
                  suffixIconPress: () {
                    setState(() {
                      isVisible2 = !isVisible2;
                    });
                  },
                  sufixIcon:
                      isVisible2 ? Icons.visibility : Icons.visibility_off,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    width: 3000,
                    child: ButtonWidget(
                        btnText: "Submit",
                        color: Theme.of(Get.context!).colorScheme.primary,
                        isloading: context.watch<ProfileProvider>().isLoading,
                        onPress: () async {
                          if (passwordcont.text == passwordcont2.text &&
                              namecont.text != "" &&
                              emailcont.text != "") {
                            UserModel u = UserModel();
                            u.name = namecont.text;
                            u.email = emailcont.text;
                            u.phone_number = phonecont.text;
                            u.password = passwordcont.text;
                            Provider.of<ProfileProvider>(context, listen: false)
                                .profileUpdate(
                              u,
                              context,
                            );
                          } else {
                            snackBar(context,
                                title: "Please fill all fields correctly");
                          }
                        }),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
