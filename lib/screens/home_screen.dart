import 'package:date_time_line/date_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/controllers/event_controller.dart';
import 'package:simple_calendar/models/event.dart';
import 'package:simple_calendar/services/notification_services.dart';
import 'package:simple_calendar/services/theme_services.dart';
import 'package:simple_calendar/ui/theme.dart';
import 'package:simple_calendar/screens/add_event_screen.dart';
import 'package:simple_calendar/ui/widgets/button.dart';

import '../ui/widgets/event_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static DateTime _selectedDate = DateTime.now();

  final _eventController = Get.put(EventController());

  var noty;

  final double iconPercentage = 7;

  @override
  void initState() {
    super.initState();
    noty = NotifyHelper();
    noty.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showEvents(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: DateTimeLine(
        width: MediaQuery.of(context).size.width,
        color: Colors.lightGreen,
        hintText: "",
        onSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: headingStyle,
              ),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Event",
            onTap: () async {
              await Get.to(() => const AddEventScreen());
              _eventController.getEvents();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    double iconSize = MediaQuery.of(context).size.width * iconPercentage / 100;

    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();

          noty.displayNotification(
              title: "Simple Calendar",
              body: Get.isDarkMode
                  ? "Activated Light Mode"
                  : "Activated Dark Mode");

        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: iconSize,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: const Center(child: Text('Simple Calendar', style: TextStyle(fontWeight: FontWeight.bold),)),
    );
  }

  _showEvents() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(

            itemCount: _eventController.eventList.length,

            itemBuilder: (_, index) {

              Event event = _eventController.eventList[index];

              _reminderConditionCheck(index, event);

              if(event.date == DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(context, event);
                              },
                              child: EventTile(event),
                            )
                          ],
                        ),
                      ),
                    ));
              }else{
                return Container();
              }

            });
      }),
    );
  }

  _reminderConditionCheck(int index, Event event){

    if(event.remind == '15 mins'){

      DateTime date = DateFormat.jm().parse(event.startTime.toString()).subtract(const Duration(minutes: 15));
      var myTime = DateFormat("HH:mm").format(date);
      var scheduledNotification = noty.scheduledNotification(
          int.parse(myTime.toString().split(":")[0]),
          int.parse(myTime.toString().split(":")[1]),
          event
      );

      print(scheduledNotification);

      return AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, event);
                    },
                    child: EventTile(event),
                  )
                ],
              ),
            ),
          ));

    }else if(event.remind == '1 hour'){

      DateTime date = DateFormat.jm().parse(event.startTime.toString()).subtract(const Duration(hours: 1));
      var myTime = DateFormat("HH:mm").format(date);
      noty.scheduledNotification(
          int.parse(myTime.toString().split(":")[0]),
          int.parse(myTime.toString().split(":")[1]),
          event
      );

      return AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, event);
                    },
                    child: EventTile(event),
                  )
                ],
              ),
            ),
          ));

    }else if(event.remind == '1 day'){

      DateTime date = DateFormat.jm().parse(event.startTime.toString()).subtract(const Duration(days: 1));
      var myTime = DateFormat("HH:mm").format(date);
      noty.scheduledNotification(
          int.parse(myTime.toString().split(":")[0]),
          int.parse(myTime.toString().split(":")[1]),
          event
      );

      return AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, event);
                    },
                    child: EventTile(event),
                  )
                ],
              ),
            ),
          ));

    }else {

      DateTime date = DateFormat.jm().parse(event.startTime.toString());
      var myTime = DateFormat("HH:mm").format(date);
      noty.scheduledNotification(
          int.parse(myTime.toString().split(":")[0]),
          int.parse(myTime.toString().split(":")[1]),
          event
      );

      return AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, event);
                    },
                    child: EventTile(event),
                  )
                ],
              ),
            ),
          ));

    }
  }

  _showBottomSheet(BuildContext context, Event event) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        width: Get.width * 1,
        height: Get.height * 0.3,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            const Spacer(),
            event.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Event Completed",
                    onTap: () {
                      _eventController.markEventCompleted(event.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context),
            const SizedBox(
              height: 3,
            ),
            _bottomSheetButton(
                label: "Delete Event",
                onTap: () {
                  _eventController.delete(event);
                  Get.back();
                },
                clr: Colors.red[300]!,
                context: context),
            const SizedBox(
              height: 30,
            ),
            _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.grey[300]!,
                isClose: true,
                context: context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Get.isDarkMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

}
