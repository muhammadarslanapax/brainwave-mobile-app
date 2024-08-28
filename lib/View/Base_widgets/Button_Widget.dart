import 'package:aichat/main.dart';
import 'package:flutter/material.dart';

import 'Animation/Loading_Animation.dart';

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final VoidCallback onPress;
  Color? color = Theme.of(Get.context!).primaryColor;
  bool? isloading = false;

  ButtonWidget({
    super.key,
    required this.btnText,
    required this.onPress,
    this.isloading,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shadowColor: const Color.fromARGB(255, 237, 137, 144),
        //primary: Theme.of(context).secondaryHeaderColor,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: isloading!
          ? const SpinKitWave(
              color: Colors.white,
              type: SpinKitWaveType.start,
              size: 20,
            )
          : Text(
              btnText.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
    );
  }
}
