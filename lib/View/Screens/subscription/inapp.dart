import 'package:aichat/View/Screens/subscription/StripScreen.dart';
import 'package:aichat/main.dart';
import 'package:aichat/packages/flutter_paypal_checkout/flutter_paypal_checkout.DART';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/View/Base_widgets/customsnackBar.dart';
import 'package:aichat/model/subscription_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GooglePay_ApplePay extends StatefulWidget {
  final SubscriptionPlanModel plan;

  const GooglePay_ApplePay({
    super.key,
    required this.plan,
  });

  @override
  State<GooglePay_ApplePay> createState() => _GooglePay_ApplePayState();
}

class _GooglePay_ApplePayState extends State<GooglePay_ApplePay> {
  late Widget applePayButton;
  late Widget googlePayButton;

  @override
  void initState() {
    super.initState();
  }

  doPaypalPayment() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckout(
        sandboxMode: true,
        cancelURL: 'success.snippetcoder.com',
        returnURL: 'cancel.snippetcoder.com',
        clientId: Provider.of<ProfileProvider>(Get.context!, listen: false)
                .keysModel!
                .PAYPAL_CLIENT_ID ??
            '',
        secretKey: Provider.of<ProfileProvider>(Get.context!, listen: false)
                .keysModel!
                .PAYPAL_SECRET_ID ??
            '',
        transactions: [
          {
            "amount": {
              "total": widget.plan.offerPrice.toString(),
              "currency": "USD",
              "details": {
                "subtotal": widget.plan.offerPrice.toString(),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": widget.plan.description ?? '',
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            "item_list": {
              "items": [
                {
                  "name": widget.plan.description ?? "",
                  "quantity": 1,
                  "price": widget.plan.offerPrice.toString(),
                  "currency": "USD"
                },
              ],

              // Optional
              //   "shipping_address": {
              //     "recipient_name": "Tharwat samy",
              //     "line1": "tharwat",
              //     "line2": "",
              //     "city": "tharwat",
              //     "country_code": "EG",
              //     "postal_code": "25025",
              //     "phone": "+00000000",
              //     "state": "ALex"
              //  },
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          snackBar(context, title: "onSuccess: $params");
          Provider.of<ProfileProvider>(context, listen: false)
              .updatePlan(widget.plan);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onError: (error) {
          snackBar(context, title: "onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          snackBar(context, title: 'cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
    setState(() {
      clicked = -1;
    });
  }

  int clicked = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Center(
            //   child: Platform.isIOS
            //       ? ApplePayButton(
            //           paymentConfiguration:
            //               PaymentConfiguration.fromJsonString(defaultApplePay),
            //           paymentItems: [
            //             PaymentItem(
            //               label: widget.plan.subscriptionName!,
            //               amount: (widget.plan.subscriptionPrice! -
            //                       widget.plan.offerPrice!)
            //                   .toString(),
            //               status: PaymentItemStatus.final_price,
            //             )
            //           ],
            //           style: ApplePayButtonStyle.black,
            //           width: MediaQuery.of(context).size.width * 0.8,
            //           height: 50,
            //           type: ApplePayButtonType.buy,
            //           margin: const EdgeInsets.only(top: 15.0),
            //           onPaymentResult: (result) {
            //             if (result['status'] == 'SUCCESS') {
            //               Provider.of<ProfileProvider>(context, listen: false)
            //                   .updatePlan(widget.plan);
            //             } else {
            //               // Payment failed or was cancelled
            //               // You can display an error message, retry payment, etc.
            //             }
            //             snackBar(context, title: 'Payment Result $result');
            //             Navigator.pop(context);
            //             // snackBar(context, title: result.)
            //           },
            //           loadingIndicator: const Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //         )
            //       : GooglePayButton(
            //           onError: (error) {
            //             PlatformException ex = error as PlatformException;
            //             snackBar(context, title: ex.message.toString());
            //             // Navigator.pop(context);
            //           },
            //           width: MediaQuery.of(context).size.width * 0.8,
            //           paymentConfiguration:
            //               PaymentConfiguration.fromJsonString(defaultGooglePay),
            //           paymentItems: [
            //             PaymentItem(
            //               label: widget.plan.subscriptionName ?? '',
            //               amount: (widget.plan.subscriptionPrice! -
            //                       (widget.plan.offerPrice ?? 0))
            //                   .toString(),
            //               status: PaymentItemStatus.final_price,
            //             )
            //           ],
            //           type: GooglePayButtonType.pay,
            //           margin: const EdgeInsets.only(top: 15.0),
            //           onPaymentResult: (result) {
            //             if (result['status'] == 'SUCCESS') {
            //               Provider.of<ProfileProvider>(context, listen: false)
            //                   .updatePlan(widget.plan);
            //             } else {
            //               // Payment failed or was cancelled
            //               // You can display an error message, retry payment, etc.
            //             }
            //             snackBar(context, title: 'Payment Result $result');
            //             Navigator.pop(context);
            //             // snackBar(context, title: result.)
            //           },
            //           loadingIndicator: const Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //         ),
            // ),

            getButtonWidget('images/paypalLogo.png', 0),
            getButtonWidget('images/stripeLogo.png', 1),
          ],
        ),
      ),
    );
  }

  Widget getButtonWidget(String logo, int index) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (clicked == -1) {
            setState(() {
              clicked = index;
            });
            double m = ((widget.plan.offerPrice ?? 0).toDouble() * 100);
            if (clicked == 0) {
              doPaypalPayment();
            } else {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StripeScreen(plan: widget.plan),
                  ));

              setState(() {
                clicked = -1;
              });
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white54)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              clicked == index
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Image.asset(logo),
            ],
          ),
        ),
      ),
    );
  }
}
