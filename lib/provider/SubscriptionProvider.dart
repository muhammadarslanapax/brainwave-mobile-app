import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../model/subscription_plan_model.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionPlanProvider with ChangeNotifier {
  List<SubscriptionPlanModel>? _products;
  List<SubscriptionPlanModel> get products => _products ?? [];
  Offerings? _offerings;
  Offerings? get offerings => _offerings;

  bool _isLoading = false;
  bool? get isLoading => _isLoading;
  String? errorMessage;
  Future<void> getPlans() async {
    try {
      _isLoading = true;
      notifyListeners();
      var res = await FirebaseFirestore.instance.collection('Plan').get();
      _products = res.docs.map((e) {
        SubscriptionPlanModel subscriptionPlanModel =
            SubscriptionPlanModel.fromMap(e.data());
        subscriptionPlanModel.pId = e.id;
        return subscriptionPlanModel;
      }).toList();
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
