import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/widgets/announcement/announcement_widgets.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({super.key});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {

  final AnnouncementController controller = AnnouncementController();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Announcement"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            announcementCaution(),
            SizedBox(height: 20.h),
            customTextField(controller: controller.titleController, label: "Announcement Title"),
            customTextField(controller: controller.descriptionController , label: "Enter Details...",maxline: 10),
            SizedBox(height: 20.h),
            customButton(text: "Announce", onPressed: ()async{
              await controller.addAnnouncements();
              if(context.mounted) Navigator.pop(context);
            })

          ],
        ),
      ),
    );
  }
}
