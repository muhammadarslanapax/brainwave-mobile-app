import 'package:aichat/View/Base_widgets/Animation/Loading_Animation.dart';
import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/View/Screens/Auth/Login_Screen.dart';
import 'package:aichat/View/Screens/DashBoard/DashBoard.dart';
import 'package:aichat/View/Screens/subscription/inapp.dart';
import 'package:aichat/main.dart';
import 'package:aichat/model/subscription_plan_model.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/provider/SubscriptionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasePremiumPlanScreen extends StatefulWidget {
  const PurchasePremiumPlanScreen({super.key, required this.isCameBack});

  final bool isCameBack;

  @override
  State<PurchasePremiumPlanScreen> createState() =>
      _PurchasePremiumPlanScreenState();
}

class _PurchasePremiumPlanScreenState extends State<PurchasePremiumPlanScreen> {
  String selectedPayButton = 'Paypal';
  int selectedPackageValue = 0;

  List<String> imageList = [
    'images/sp1.png',
    'images/sp2.png',
    'images/sp3.png',
    'images/sp4.png',
    //   'images/sp5.png',
    //   'images/sp6.png',
  ];

  List<String> titleListData = [
    'Unlimited Questions And Answers',
    'High Word Limit',
    'Ads Free Experience',
    'Extended Duration'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SubscriptionPlanProvider>(Get.context!, listen: false)
            .getPlans());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Purchase Premium Plan",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.isCameBack
                              ? Navigator.pop(context)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashBoard(),
                                  ),
                                );
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: imageList.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {},
                              child: ListTile(
                                leading: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image(
                                    image: AssetImage(imageList[i]),
                                  ),
                                ),
                                title: Text(
                                  titleListData[i],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                // trailing:
                                //     const Icon(FeatherIcons.alertCircle),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Buy premium Plan",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Consumer<SubscriptionPlanProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading!) {
                        // Show loading indicator while data is fetching
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: SpinKitWave(
                            color: Theme.of(context).iconTheme.color,
                            type: SpinKitWaveType.start,
                            size: 20,
                          ),
                        );
                      } else if (provider.products.isNotEmpty) {
                        // Plans list is available, display it
                        // List<ProductDetails>? plans = providerproducts.;
                        return SizedBox(
                          height: (MediaQuery.of(context).size.height * .46),
                          child: ListView.builder(
                            itemCount: provider.products.length,
                            itemBuilder: (context, index) {
                              SubscriptionPlanModel plan =
                                  provider.products[index];
                              double subscriptionPrice =
                                  plan.subscriptionPrice!.toDouble();
                              double percent =
                                  ((subscriptionPrice - plan.offerPrice!) /
                                          plan.offerPrice!) *
                                      100;
                              String percentage = percent.toStringAsFixed(0);
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  // right: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    // snackBar(context, title: 'here');
                                    // SnackBar(content: content,tit);
                                    if (Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .loggedInUser ==
                                        null) {
                                      await showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog.adaptive(
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen(),
                                                      ),
                                                      (route) => false);
                                                },
                                                child: const Text('Login'))
                                          ],
                                          content: const Text(
                                              'You are not logged in.'),
                                          icon: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.cancel)),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            GooglePay_ApplePay(
                                          plan: plan,
                                        ),

                                        // UsePaypal(
                                        //   sandboxMode: true,
                                        //   clientId:
                                        //       "Ac2kL8ru4N79mZ5Sq1FT6phpPjTNOTFbpzSxSD5sPR8APOrNypy9ESYka5Yx5r450lImxqSk0wDX3-2f",
                                        //   secretKey:
                                        //       "EMH2Q1EuusBit-xAdMlMWNEizKfkRn32p2Qg3-ArdVs7wdbyR4e-UZBjQoEf6cvdwf3qwQ5rAorQKPUa",
                                        //   returnURL:
                                        //       "https://samplesite.com/return",
                                        //   cancelURL:
                                        //       "https://samplesite.com/cancel",
                                        //   transactions: [
                                        //     {
                                        //       "amount": {
                                        //         "total": plan.subscriptionPrice
                                        //             .toString(),
                                        //         "currency": "USD",
                                        //         "details": {
                                        //           "subtotal":
                                        //               (plan.subscriptionPrice! -
                                        //                       plan.offerPrice!)
                                        //                   .toString(),
                                        //           "shipping": '0',
                                        //           "shipping_discount": 0
                                        //         }
                                        //       },
                                        //       "item_list": {
                                        //         "items": [
                                        //           {
                                        //             "name":
                                        //                 plan.subscriptionName,
                                        //             "quantity": 1,
                                        //             "price": plan
                                        //                 .subscriptionPrice
                                        //                 .toString(),
                                        //             "currency": "USD"
                                        //           }
                                        //         ],
                                        //       }
                                        //     }
                                        //   ],
                                        //   note:
                                        //       "Contact us for any questions on your order.",
                                        //   onSuccess: (Map<String, dynamic>
                                        //       params) async {
                                        //     print("onSuccess: $params");
                                        //     snackBar(
                                        //       context,
                                        //       title: "Purchase successful.",
                                        //     );
                                        //   },
                                        //   onError: (dynamic error) {
                                        //     // Handle error
                                        //     print("onError: $error");
                                        //   },
                                        //   onCancel:
                                        //       (Map<String, dynamic> params) {
                                        //     // Handle cancellation
                                        //     print('cancelled: $params');
                                        //   },
                                        // ),

                                        //
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: (MediaQuery.of(context).size.width /
                                            3) -
                                        20,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                plan.subscriptionName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(plan.description ?? ''),
                                              const SizedBox(height: 5),
                                              FittedBox(
                                                child: Text(
                                                  '\$: ${plan.subscriptionPrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        decorationThickness: 3,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .tertiary,
                                                      ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  '\$: ${plan.offerPrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            width: 60,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("$percentage% Off"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        // Handle any other states if necessary
                        return const Center(child: Text("No Plans available"));
                      }
                    },
                  ),
                  // // const SizedBox(height: 10),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     height: 60,
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.primary,
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(50)),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         "Continue",
                  //         style: Theme.of(context).textTheme.bodyLarge,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // .visible(Subscription.customersActivePlan.subscriptionName !=
                  // //     selectedPlan.subscriptionName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
