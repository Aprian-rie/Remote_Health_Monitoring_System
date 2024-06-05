import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class RoundGradientButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const RoundGradientButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2, offset: Offset(0, 2)
            )
          ]
        ),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.maxFinite,
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textColor: AppColors.primaryColor1,
          child: Text(title,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
