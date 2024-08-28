import 'package:aichat/View/Base_widgets/AppBarCustom.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy_Screen extends StatefulWidget {
  const PrivacyPolicy_Screen({super.key});

  @override
  State<PrivacyPolicy_Screen> createState() => _PrivacyPolicy_ScreenState();
}

class _PrivacyPolicy_ScreenState extends State<PrivacyPolicy_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        title: AppBarCustom(
          title: "Privacy Policy",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            """Privacy Policy for BrainWave

This Privacy Policy describes how your personal information is collected, used, and shared when you use our app, BrainWave.

Information We Collect

When you use the BrainWave app, we may collect certain information about you:

Usage Information: We collect information about how you interact with the app, such as the features you use, the content you access, and your preferences.

Device Information: We collect information about the device you use to access the app, including device type, operating system, unique device identifiers, and mobile network information.

Log Information: We automatically collect certain information and store it in log files, including your IP address, browser type, operating system, and timestamps.

User Input: If you engage in chat interactions or use any input features within the app, we may collect the content of your messages or input, as well as associated metadata (e.g., timestamps).

How We Use Your Information

We use the information we collect for various purposes, including:

Providing and maintaining the app's functionality.
Improving and optimizing the user experience.
Personalizing your experience within the app.
Responding to your inquiries, requests, and feedback.
Communicating with you about updates, promotions, and other news related to the app.
Detecting, preventing, and addressing technical issues and security vulnerabilities.
Sharing Your Information

We may share your information with third parties in the following circumstances:

Service Providers: We may engage third-party companies and individuals to perform services on our behalf, such as hosting, analytics, customer support, and advertising. These third parties may have access to your information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.

Legal Compliance: We may disclose your information to comply with applicable laws, regulations, legal processes, or governmental requests.

Business Transfers: If we are involved in a merger, acquisition, asset sale, or other business transaction, your information may be transferred as part of that transaction. In such cases, we will notify you before your information is transferred and becomes subject to a different privacy policy.

Data Retention

We will retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.

Security

We are committed to protecting the security of your information and take reasonable measures to prevent unauthorized access, disclosure, alteration, or destruction of your information.

Your Choices

You can choose not to provide certain information, but this may limit your ability to use certain features of the app.

Changes to This Privacy Policy

We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. We will notify you of any material changes by posting the new Privacy Policy on this page.

Contact Us

If you have any questions or concerns about this Privacy Policy or our practices, you may contact us at contact@example.com.

This Privacy Policy was last updated on [insert date].""",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
