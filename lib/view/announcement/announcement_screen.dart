import 'package:edu_link/controller/announcement_controller.dart';
import 'package:edu_link/view/announcement/add_announcement.dart';
import 'package:edu_link/view/drawer/drawer.dart';
import 'package:edu_link/widgets/announcement/announcement_widgets.dart';
import 'package:edu_link/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatefulWidget {
  final String role;
  const AnnouncementScreen({super.key, required this.role});


  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {

@override
  void initState() {
    super.initState();
    Future.microtask((){
      if(mounted){
      Provider.of<AnnouncementController>(context,listen: false).fetchAnnouncement();
      }
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnnouncementController>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: customDrawer(context, widget.role),
      floatingActionButton: widget.role == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddAnnouncement()));
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/home_appBar.png",
                width: double.infinity,
                fit: BoxFit.fill,
                height: 215.h,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu_sharp,
                            size: 40.sp, color: Colors.white),
                      ),
                      SizedBox(height: 15.sp),
                      customText(
                          text: "Welcome to Edu Link",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 10),
                        child: customText(
                            text: "Where things are managed smartly",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD7DEDA)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: controller.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : controller.errorMessage != null
              ? Center(child: Text(controller.errorMessage!))
              : ListView.builder(
                  itemCount: controller.announcements.length,
                  itemBuilder: (context,index){
                    final announcement = controller.announcements[index];
                    return AnnouncementTile(title: announcement.title, description: announcement.description);
                  }),
          ),
        ],
      ),
    );
  }
}