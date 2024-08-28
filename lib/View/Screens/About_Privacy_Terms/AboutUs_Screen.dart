import 'package:aichat/View/Base_widgets/AppBarCustom.dart';
import 'package:flutter/material.dart';

class AboutUs_Screen extends StatefulWidget {
  const AboutUs_Screen({super.key});

  @override
  State<AboutUs_Screen> createState() => _AboutUs_ScreenState();
}

class _AboutUs_ScreenState extends State<AboutUs_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        title: AppBarCustom(
          title: "About Us",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "About Us text here.....",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
