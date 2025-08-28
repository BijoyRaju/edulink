import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/model/announcement_model.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ViewAnnouncement extends StatelessWidget {
  final AnnouncementModel announcement;
  final String role; 
  const ViewAnnouncement({super.key, required this.announcement,required this.role});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnnouncementController>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: customText(text: "Announcement",fontWeight: FontWeight.w500,fontSize: 20.sp),
        centerTitle: true,
        actions: [
          if(role == "admin")
           IconButton(
            onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Announcement"),
                    content: const Text("Are you sure you want to delete this announcement?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await controller.deleteAnnouncement(announcement.announcementId);
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnackBarMessage(context, "Announcement deleted Successfully");
                  }
                }
              },
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              announcement.description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
