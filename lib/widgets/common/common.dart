import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Form Field
Widget customTextFormField({
  required String text,
  required TextEditingController controller,
  String? Function(String?)? validator,
  bool obscureText = false,
  }){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF73B18F),
        hintText: text,
        hintStyle: TextStyle(color: Color(0xFFEAF9F1),fontSize: 14.sp,fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none
        )
      ),
    ),
  );
}

// Text
Widget customText({
  required String text,
  Color color = Colors.black,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal
  }){
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight
    ),
  );
}

// Button
Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color backgroundColor = const Color(0xFF254F43), 
  Color textColor = Colors.white,
  double borderRadius = 20,
  double paddingV = 10,
  double paddingH = 24,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.bold,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: paddingV.h,
            horizontal: paddingH.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 4,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
          ),
        ),
      ),
    ),
  );
}


// Scafold Messenger
void showSnackBarMessage(BuildContext context, String message, ) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Widget customTextField({required TextEditingController controller,required String label,int maxline = 1,bool obscureText = false}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      obscureText: obscureText,
      maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2.0
            )
          ),
        )
      ),
  );
}