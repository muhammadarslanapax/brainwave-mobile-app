import 'package:aichat/View/Base_widgets/AppBarCustom.dart';
import 'package:aichat/View/Screens/subscription/Premium_plans_screen.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  Duration? remainTime;
  List<String>? initialPackageService;
  List<int>? mainPackageService;
  List<String> nameList = [
    'Limited Questions And Answers',
    'Low Word Limit',
    'Ads',
    'Limited Duration'
  ];
  List<String> imageList = [
    'images/sp1.png',
    'images/sp4.png',
    'images/sp2.png',
    'images/sp3.png',
  ];
  String constUserId = '';

  @override
  void initState() {
    // checkSubscriptionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: AppBarCustom(
                title: "Your Package",
              )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Free Plan",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  "You are using ",
                                  style: TextStyle(fontSize: 12),
                                ),
                                FittedBox(
                                  child: Text(
                                    Provider.of<ProfileProvider>(context)
                                                .loggedInUser ==
                                            null
                                        ? ''
                                        : Provider.of<ProfileProvider>(context)
                                                    .loggedInUser!
                                                    .pId !=
                                                "0"
                                            ? 'Free Package'
                                            : 'Premium Package',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // const Spacer(),
                        Container(
                          height: 63,
                          width: 63,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            '${Provider.of<ProfileProvider>(context).loggedInUser == null ? '' : (DateTime.parse(Provider.of<ProfileProvider>(context).loggedInUser!.endDate!).difference(DateTime.now()).inDays.abs()).abs()} \nDays Left',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          )),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  // .visible(Subscription.customersActivePlan.subscriptionName ==
                  //     'Free'),

                  const SizedBox(height: 20),
                  const Text(
                    "Package Features",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                      itemCount: nameList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              color: Theme.of(context).colorScheme.primary,
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  leading: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image(
                                      image: AssetImage(imageList[i]),
                                    ),
                                  ),
                                  title: Text(
                                    nameList[i],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      // await Provider.of<SubscriptionPlanProvider>(context,
                      //         listen: false)
                      //     .savePlans(plans);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PurchasePremiumPlanScreen(
                              isCameBack: true,
                            ),
                          ));
                      // const PurchasePremiumPlanScreen(
                      //   isCameBack: true,
                      // ).launch(context);
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: const Center(
                        child: Text(
                          "Update Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // .visible(Subscription.customersActivePlan.duration != -202),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
