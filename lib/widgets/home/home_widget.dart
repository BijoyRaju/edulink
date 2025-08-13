import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget homeScreenContainerOne(double height,double width,Color colors,String text1, String text2){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customText(text: text1,color: Color(0xFF043427),fontSize: 16.sp,fontWeight: FontWeight.bold),
        SizedBox(height: 10.h),
        customText(text: text2,fontSize: 32.sp,fontWeight: FontWeight.bold)
     ],
    ),
  );
}


Widget homeScreenContainerTwo(double height,double width,Color colors,String text1, String text2){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customText(text: text1,color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.bold),
        SizedBox(height: 5.h),
        customText(text: text2,fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white)
     ],
    ),
  );
}

Widget customTile(String title, String subtitle,String trailing){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      height: 66.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.6),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white
      ),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customText(text: "Name : ",fontWeight: FontWeight.bold,fontSize: 14.sp),
                    customText(text: title,fontSize: 14.sp),
                  ],
                ),
                Row(
                  children: [
                    customText(text: "Phone : ",fontSize: 14.sp,fontWeight: FontWeight.bold),
                    customText(text: subtitle, fontSize: 14.sp)
                  ],
                ),
              ],
            ),
            Row(
              children: [
                customText(text: "Subject : ",fontSize: 14.sp,fontWeight: FontWeight.bold),
                customText(text: trailing,fontSize: 14.sp)
              ],
            )
          ],
        ),
      ),
    ),
  );
}