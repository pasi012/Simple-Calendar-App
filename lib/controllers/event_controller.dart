import 'package:get/get.dart';
import 'package:simple_calendar/db/db_helper.dart';
import 'package:simple_calendar/models/event.dart';

class EventController extends GetxController {

  @override
  void onReady() {
    super.onReady();
  }

  var eventList = <Event>[].obs;

  Future<int> addEvent({Event? event}) async {
    return await DBHelper.insert(event);
  }

  void getEvents() async {
    List<Map<String, dynamic>> events = await DBHelper.query();
    eventList.assignAll(events.map((data) => Event.fromJson(data)).toList());
  }

  void delete(Event event){
    DBHelper.delete(event);
    getEvents();
  }

  void markEventCompleted(int id) async {
    await DBHelper.update(id);
    getEvents();
  }

}