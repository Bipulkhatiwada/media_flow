import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyScreen extends StatelessWidget {

  final String title;
  final IconData displayIcon;
  final String? descriptionText;

  const EmptyScreen({
    super.key, 
    required this.title, 
    required this.displayIcon,
    this.descriptionText
    });
    

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                color: const Color(0xFF1DB954),
                size: 80,
              ),
            ),
             SizedBox(height: 24.h),
             Text(
              title,
              style:  TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
             SizedBox(height: 12.h),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                descriptionText ?? "",
                style:  TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                  height: 1.5.h,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}