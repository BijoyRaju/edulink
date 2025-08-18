import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnnouncementTile extends StatefulWidget {
  final String title;
  final String description;

  const AnnouncementTile({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<AnnouncementTile> createState() => _AnnouncementTileState();
}

class _AnnouncementTileState extends State<AnnouncementTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: isExpanded ? null : 133.h, 
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.6),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: "📢  ${widget.title}",
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
              SizedBox(height: 5.sp),
              Text(
                widget.description,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color.fromARGB(255, 55, 55, 55),
                ),
              ),
              if (widget.description.length > 60) 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      isExpanded ? "Read less" : "Read more...",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget announcementCaution(){
  return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.shade700),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info, color: Colors.amber.shade700, size: 28.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "Announcements made here will notify everyone in the institution. "
                "Please make sure the information is accurate before publishing.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}