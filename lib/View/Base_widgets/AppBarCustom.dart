// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  String? title;
  AppBarCustom({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: () {
        // loadAdd();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              width: 18,
              image: const AssetImage('images/back_icon.png'),
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Text(
              title!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
