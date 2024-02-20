import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    String? text =
        "Video darsi izlamaya baslamamisdan avval onun adin oxuyun, maggalanin magsadi, istifada olunan lavazimat va tapsingin yerina yetirma prosesini manimsayin. Daha sonra isa öyradilan bacariqlarin manimsama gündaliyini aparin va usagin bacarigi no daracada manimsamasini lçün Gün arzinda an azi 1 saat (2 dafa 30 daqiqalik maggale) usagla darsi kegirdin. ilkin marhalada masgalalar 5 daqiqadan baslaya bilar, tadrican bu vaxt artmalidir. Darsin magsadina catmamis, murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.murakkabliyina gora daha catin olan maggalaya keçmak tövsiya olunmur.";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Haqqımızda",
            // textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.poppins,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
                fontFamily: AppFonts.poppins),
          )
        ]),
      )),
    );
  }
}
