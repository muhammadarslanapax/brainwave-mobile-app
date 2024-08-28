import 'package:aichat/View/Base_widgets/AppBarCustom.dart';
import 'package:flutter/material.dart';

class Terms_Screen extends StatefulWidget {
  const Terms_Screen({super.key});

  @override
  State<Terms_Screen> createState() => _Terms_ScreenState();
}

class _Terms_ScreenState extends State<Terms_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        title: AppBarCustom(
          title: "Terms & Conditions",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Terms & Conditions text here.....",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
