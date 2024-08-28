import 'dart:io';

import 'package:aichat/View/Base_widgets/ProfileCard/ProfileCard.dart';
import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/View/Screens/About_Privacy_Terms/AboutUs_Screen.dart';
import 'package:aichat/View/Screens/About_Privacy_Terms/PrivacyPolicy_Sceen.dart';
import 'package:aichat/View/Screens/About_Privacy_Terms/Terms&Condition.dart';
import 'package:aichat/View/Screens/Auth/Login_Screen.dart';
import 'package:aichat/View/Screens/ProfileUpdate/ProfileUpdate.dart';
import 'package:aichat/View/Screens/subscription/package_screen.dart';
import 'package:aichat/main.dart';
import 'package:aichat/provider/Chatgpt.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/provider/theme_provider.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:aichat/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:app_feedback/app_feedback.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({super.key});

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  //
  //FeedBack Code Starts
  AppFeedback feedbackForm = AppFeedback.instance;

  UserFeedback? feedback;

  void launchAppFeedback() {
    feedbackForm.display(
      context,
      option: Option(
        isDismissible: false,
        //shape: const StarBorder.polygon(),
        hideRatingBottomText: true,
        maxRating: 5,
        ratingButtonTheme: RatingButtonThemeData.outlinedBorder(),
      ),
      onSubmit: (feedback) async {
        this.feedback = feedback;
        if (feedback.rating == null) {
          snackBar(context, title: 'Select rating');
        } else {
          String url =
              "https://wa.me/${923203608044}?text=${Uri.encodeComponent('Rating: ${feedback.rating}/5 \nReview: ${feedback.review}')}";
          await launchUrl(Uri.parse(url));
        }
      },
    );
  }

  @override
  void initState() {
    //FeedBack Code Starts
    feedbackForm.init(
      FeedbackConfig(
        duration: const Duration(seconds: 10),
        displayLogs: true,
      ),
    );
    //FeedBack Code Ends
    super.initState();
  }

  bool isCopying = false;
  final TextEditingController keyTextEditingController =
      TextEditingController();
  final TextEditingController urlTextEditingController =
      TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
    }
  }

  // User? u;
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 249, 242, 242),
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Consumer<ProfileProvider>(
          builder: (context, profile, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  // user card
                  BigUserCard(
                    cardRadius: 20,
                    backgroundMotifColor:
                        const Color.fromRGBO(255, 255, 255, 1),
                    userName: profile.loggedInUser != null
                        ? profile.loggedInUser!.name
                        : 'Guest',
                    userProfilePic: profile.loggedInUser == null
                        ? "https://e7.pngegg.com/pngimages/771/79/png-clipart-avatar-bootstrapcdn-graphic-designer-angularjs-avatar-child-face.png"
                        : profile.loggedInUser!.image != null &&
                                profile.loggedInUser!.image != ""
                            ? profile.loggedInUser!.image
                            : "https://e7.pngegg.com/pngimages/771/79/png-clipart-avatar-bootstrapcdn-graphic-designer-angularjs-avatar-child-face.png",
                    popupWidget: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Change Profile",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (file != null) {
                                imageFile = File(file.path);
                                Provider.of<ProfileProvider>(
                                  Get.context!,
                                  listen: false,
                                ).uploadPic(imageFile!);
                              }
                              Navigator.of(
                                Get.context!,
                              ).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 8,
                                bottom: 10,
                                left: 8,
                              ),
                              child: Text(
                                "Gallery",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );
                              if (file != null) {
                                imageFile = File(file.path);
                                Provider.of<ProfileProvider>(
                                  Get.context!,
                                  listen: false,
                                ).uploadPic(imageFile!);
                              }

                              Navigator.of(Get.context!).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 8,
                                bottom: 10,
                                left: 8,
                              ),
                              child: Text(
                                "Camera",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    userMoreInfo: Text(
                      profile.loggedInUser == null
                          ? ''
                          : profile.loggedInUser!.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    cardActionWidget: profile.loggedInUser == null
                        ? null
                        : SettingsItem(
                            onTap: () async {
                              profile.loggedInUser!.name != "Guest"
                                  ? Utils.jumpPage(
                                      context,
                                      const ProfileEdit_Screen(),
                                    )
                                  : await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          scrollable: true,
                                          title: Text(
                                            "Please login to update the profile",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'Cancel',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Login',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              onPressed: () {
                                                Utils.jumpPage(context,
                                                    const LoginScreen());
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                            icons: CupertinoIcons.pencil,
                            iconStyle: IconStyle(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            title: 'Update',
                            subtitle: "Tap here to change your data",
                          ),
                  ),
                  SettingsGroup(
                    items: [
                      SettingsItem(
                        onTap: () {},
                        icons: Provider.of<ThemeProvider>(context).darkTheme
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          backgroundColor: Colors.red,
                        ),
                        title: 'Theme',
                        subtitle: "Change theme style.",
                        trailing: Switch.adaptive(
                          inactiveTrackColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          inactiveThumbColor:
                              const Color.fromARGB(255, 246, 195, 195),
                          //enableFeedback: true,
                          activeColor: Theme.of(context).hintColor,
                          value: Provider.of<ThemeProvider>(context).darkTheme,
                          onChanged: (bool isActive) =>
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(),
                        ),
                      ),

                      SettingsItem(
                        onTap: () {
                          Utils.jumpPage(
                            context,
                            const PrivacyPolicy_Screen(),
                          );
                        },
                        icons: Icons.privacy_tip,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.orange,
                        ),
                        title: 'Privacy Policy',
                        subtitle: "Learn more about us",
                      ),
                      // SettingsItem(
                      //   onTap: () {
                      //     Utils.jumpPage(
                      //       context,
                      //       const Terms_Screen(),
                      //     );
                      //   },
                      //   icons: Icons.info_outline_rounded,
                      //   iconStyle: IconStyle(
                      //     backgroundColor: Colors.deepPurple,
                      //   ),
                      //   title: 'Terms & Conditions',
                      //   subtitle: "Learn more about us",
                      // ),
                      SettingsItem(
                        onTap: () {
                          launchAppFeedback();
                        },
                        icons: CupertinoIcons.chat_bubble_fill,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.amber,
                        ),
                        title: 'Send Feedback',
                        subtitle:
                            "Let us know how we can improve our applicaton",
                      ),
                    ],
                  ),
                  SettingsGroup(
                    settingsGroupTitle: "Account",
                    items: [
                      SettingsItem(
                        onTap: () async {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .signOut();
                          Utils.jumpPage(context, const LoginScreen(),
                              ignorrRoute: true);
                        },
                        icons: Icons.exit_to_app_rounded,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                        title:
                            profile.loggedInUser == null ? 'LogIn' : "Log Out",
                        subtitle: profile.loggedInUser == null
                            ? 'You will be loggedIn'
                            : "You will be logged out.",
                      ),

                      // SettingsItem(
                      //   onTap: () {},
                      //   icons: CupertinoIcons.repeat,
                      //   title: "Change email",
                      // ),
                      if (profile.loggedInUser != null)
                        SettingsItem(
                          onTap: () {
                            //Dialog
                            showDialog(
                              //useSafeArea: true,
                              //To disable alert background
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Theme.of(context).cardColor,
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: (() {
                                              Navigator.of(context).pop();
                                            }),
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Do you want to delete your account?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icons: CupertinoIcons.delete_solid,
                          iconStyle: IconStyle(
                            backgroundColor: Colors.redAccent,
                          ),
                          title: "Delete account",
                          titleStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: "Your data will be be removed.",
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
