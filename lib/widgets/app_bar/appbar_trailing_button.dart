import 'package:aLive/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:aLive/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTrailingButton extends StatelessWidget {
  AppbarTrailingButton({
    Key? key,
    this.margin,
    this.onTap,
    required this.onPressed,
  }) : super(key: key);

  EdgeInsetsGeometry? margin;
  Function()? onTap;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomElevatedButton(
          width: 88.h,
          text: "more",
          buttonStyle: CustomButtonStyles.fillBlueGray,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
