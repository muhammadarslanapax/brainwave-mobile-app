import 'dart:convert';
import 'dart:io';
import 'package:aichat/View/Screens/DashBoard/DashBoard.dart';
import 'package:aichat/main.dart';
import 'package:aichat/model/UserModel.dart';
import 'package:aichat/model/subscription_plan_model.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../View/Base_widgets/customsnackBar.dart';
import '../model/KeysModel.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;
  bool? _isLoading;
  bool get isLoading => _isLoading ?? false;
  KeysModel? _keysModel;
  KeysModel? get keysModel => _keysModel;

  Future<void> uploadPic(File f) async {
    try {
      String userId = _loggedInUser!.user_id.toString();
      String imageName = 'user_$userId.jpg';
      if (_loggedInUser!.image != null && _loggedInUser!.image!.isNotEmpty) {
        Reference referenceToDelete =
            FirebaseStorage.instance.refFromURL(_loggedInUser!.image!);
        try {
          await referenceToDelete.delete();
        } catch (deleteError) {
          ////
        }
      }
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref('user_images/$imageName')
          .putFile(f);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_loggedInUser!.user_id)
            .update({
          'image': downloadURL,
        }).then((val) async {
          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(_loggedInUser!.user_id)
              .get();
          if (docSnapshot.exists) {
            Map<String, dynamic> userData =
                docSnapshot.data() as Map<String, dynamic>;
            _loggedInUser = UserModel(
              user_id: userData['user_id'],
              name: userData['name'] ?? "",
              email: userData['email'] ?? "",
              password: "",
              image: userData['image'] ?? "",
              endDate: userData['endDate'],
              startDate: userData['startDate'],
              phone_number: userData['phone_number'] ?? "",
              status: userData['status'] ?? false,
            );
            await setUserFromSharedPreferences(_loggedInUser);
          }
        }).catchError((e) {
          // snackBar(Get.context!,
          //     title: "An error occurred during sign up. Please try again.$e");
        });
        notifyListeners();
      } catch (e) {
        // snackBar(Get.context!, title: "An error occurred: $e");
      }
      snackBar(Get.context!, title: "Image uploaded successfully");
      notifyListeners();
    } catch (e) {
      snackBar(Get.context!,
          title: "An error occurred during profile update. Please try again.");
      notifyListeners(); // Notify listeners of error
    }
  }

  getCredentials() async {
    try {
      var res =
          await FirebaseFirestore.instance.collection('Credentials').get();
      if (res.docs.isNotEmpty) {
        _keysModel = KeysModel.fromMap(res.docs[0].data());
        _keysModel!.id = res.docs[0].id;
        notifyListeners();
      }
    } catch (e) {}
  }

  bool checkIfPlannotExists() {
    try {
      if (_loggedInUser == null) {
        return true;
      }
      if (_loggedInUser!.startDate != null) {
        if (DateTime.parse(_loggedInUser!.startDate!)
            .isBefore(DateTime.parse(_loggedInUser!.endDate!))) {
          return false;
        }
      }
    } catch (e) {
      return true;
    }
    return true;
  }

  signOut() async {
    try {
      _loggedInUser = null;
      await prefs.remove('loggedInUser');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  updatePlan(SubscriptionPlanModel plan) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_loggedInUser!.user_id!)
          .update({
        "startDate": DateTime.now().toString(),
        "endDate":
            DateTime.now().add(Duration(days: plan.duration ?? 0)).toString(),
      });
      _loggedInUser!.startDate = DateTime.now().toString();
      _loggedInUser!.endDate =
          DateTime.now().add(Duration(days: plan.duration ?? 0)).toString();
      setUserFromSharedPreferences(loggedInUser);
    } catch (e) {}
    notifyListeners();
  }

  Future<void> profileUpdate(UserModel u, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_loggedInUser!.user_id)
          .update({
        'name': u.name,
        'email': u.email,
        'phone_number': u.phone_number,
        'password': u.password,
      }).then((val) async {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_loggedInUser!.user_id)
            .get();
        if (docSnapshot.exists) {
          Map<String, dynamic> userData =
              docSnapshot.data() as Map<String, dynamic>;
          _loggedInUser = UserModel(
            user_id: userData['user_id'],
            name: userData['name'] ?? "",
            email: userData['email'] ?? "",
            password: "",
            image: userData['image'] ?? "",
            endDate: userData['endDate'],
            startDate: userData['startDate'],
            phone_number: userData['phone_number'] ?? "",
            status: userData['status'] ?? false,
          );
          snackBar(Get.context!,
              title: "Your profile is updated successfully.");
          await setUserFromSharedPreferences(_loggedInUser);
          Utils.jumpPage(
            Get.context!,
            const DashBoard(),
          );
        }
      }).catchError((e) {
        print("Error occurred during sign up: $e");
        snackBar(context,
            title: "An error occurred during sign up. Please try again.$e");
      });
      notifyListeners();
    } catch (e) {
      snackBar(Get.context!, title: "An error occurred: $e");
    }
  }

  late SharedPreferences prefs;
  Future<void> setUserFromSharedPreferences(loggedInUser) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInUser', jsonEncode(loggedInUser!.toMap()));
    notifyListeners();
  }

  Future<void> getUserFromSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('loggedInUser');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);

      _loggedInUser = UserModel.fromMap(userMap);
      notifyListeners();
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (docSnapshot.exists) {
          Map<String, dynamic> userData =
              docSnapshot.data() as Map<String, dynamic>;
          _loggedInUser = UserModel(
            user_id: userData['user_id'],
            name: userData['name'] ?? "",
            email: userData['email'] ?? "",
            password: "",
            image: userData['image'] ?? "",
            endDate: userData['endDate'],
            startDate: userData['startDate'],
            phone_number: userData['phone_number'] ?? "",
            status: userData['status'] ?? false,
            pId: userData['pId'] ?? "0",
          );

          setUserFromSharedPreferences(_loggedInUser);
          Utils.jumpPage(Get.context!, const DashBoard(), ignorrRoute: true);
          return;
        }
      }
      snackBar(Get.context!,
          title: "Failed to log in. Please check your credentials.");
    } catch (e) {
      snackBar(Get.context!, title: "An error occurred: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(UserModel user, BuildContext context) async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    )
        .then((userCredential) {
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'user_id': uid,
          'name': user.name,
          'email': user.email,
          'phone_number': user.phone_number,
          'image': user.image,
          // 'startDate': user.startDate,
          // 'endDate': user.endDate,
          'password': user.password,
          'status': true,
          'pId': "0",
        }).then((_) async {
          snackBar(context, title: "Your account is created successfully.");
          await login(user.email!, user.password!, context);
        });
      } else {
        snackBar(context, title: "Failed to create account. Please try again.");
      }
    }).catchError((e) {
      snackBar(context, title: e.toString().split(']').last);
    });
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        snackBar(Get.context!, title: "Reset link is sent to you email.");
      } else {
        snackBar(Get.context!, title: "No user found with this email.");
      }
    } catch (e) {
      print('Error checking email existence: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
