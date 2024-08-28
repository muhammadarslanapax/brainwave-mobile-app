import 'package:aichat/View/Screens/subscription/ReusableTextField.dart';
import 'package:aichat/provider/SubscriptionProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../model/subscription_plan_model.dart';
import '../../../provider/PayPalPayment.dart';
import '../../../provider/ProfileProvider.dart';

class StripeScreen extends StatefulWidget {
  SubscriptionPlanModel plan;
  StripeScreen({super.key, required this.plan});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountController.text = ((widget.plan.offerPrice ?? 0)).toString();
  }

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
          // convert string to double
          amount: (amountController.text),
          currency: selectedCurrency,
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text);
      if (data != null) {
        // 2. initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Set to true for custom flow
            customFlow: false,
            // Main params
            merchantDisplayName: 'Test Merchant',
            paymentIntentClientSecret: data['client_secret'],
            // Customer keys
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['id'],

            style: ThemeMode.dark,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      // rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You have successfully bought a ${widget.plan.duration} days plan.",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "We appreciate your support...",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          child: const Text(
                            "Back to main",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Complete Your information.",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                    formkey: formkey,
                                    controller: amountController,
                                    isNumber: true,
                                    isReadOnly: true,
                                    title: "Amount",
                                    hint: ((widget.plan.offerPrice ?? 0))
                                        .toString()),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownMenu<String>(
                                enabled: false,
                                enableSearch: true,
                                inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                initialSelection: currencyList.first,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.

                                  selectedCurrency = value!;
                                },
                                dropdownMenuEntries: currencyList
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            formkey: formkey1,
                            title: "Name",
                            hint: "Ex. John Doe",
                            controller: nameController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            formkey: formkey2,
                            title: "Address Line",
                            hint: "Ex. 123 Main St",
                            controller: addressController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey3,
                                    title: "City",
                                    hint: "Ex. Islamabad",
                                    controller: cityController,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey4,
                                    title: "State",
                                    hint: "Ex. Punjab",
                                    controller: stateController,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey5,
                                    title: "Country (Short Code)",
                                    hint: "Ex. IN for India",
                                    controller: countryController,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey6,
                                    title: "Pincode",
                                    hint: "Ex. 123456",
                                    controller: pincodeController,
                                    isNumber: true,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary),
                              child: const Text(
                                "Proceed to Pay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (formkey.currentState!.validate() &&
                                    formkey1.currentState!.validate()) {
                                  await initPaymentSheet();

                                  try {
                                    await Stripe.instance.presentPaymentSheet();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Done",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
                                    Provider.of<ProfileProvider>(Get.context!,
                                            listen: false)
                                        .updatePlan(widget.plan);
                                    setState(() {
                                      hasDonated = true;
                                    });
                                    nameController.clear();
                                    addressController.clear();
                                    cityController.clear();
                                    stateController.clear();
                                    countryController.clear();
                                    pincodeController.clear();
                                  } catch (e) {
                                    print("payment sheet failed");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Failed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                }
                              },
                            ),
                          )
                        ])),
          ],
        ),
      ),
    );
  }
}
