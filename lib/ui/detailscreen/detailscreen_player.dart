import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailScreenPlayer extends StatelessWidget {
  final Widget player;
  const DetailScreenPlayer({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Ink(
        height: 184.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child:
            ClipRRect(borderRadius: BorderRadius.circular(8.r), child: player),
      ),
    );
  }
}
