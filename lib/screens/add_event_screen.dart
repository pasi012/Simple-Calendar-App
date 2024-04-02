import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar/controllers/event_controller.dart';
import 'package:simple_calendar/models/event.dart';
import 'package:simple_calendar/ui/theme.dart';
import 'package:simple_calendar/ui/widgets/button.dart';
import 'package:simple_calendar/ui/widgets/input_field.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  final EventController _eventController = Get.put(EventController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final double iconPercentage = 7;

  DateTime _selectDate = DateTime.now();
  String _endTime = "9.30 AM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  List<String> remindList = [
    "15 mins",
    "1 hour",
    "1 day",
    "At That Time",
  ];

  String _selectedRemind = "15 mins";

  String _selectedRepeat = "None";

  int _selectedColor = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.backgroundColor,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyInputField(title: "Title", hint: "Enter Your Title", controller: _titleController,),
              MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectDate),
                  widget: IconButton(
                    onPressed: (){
                      _getDateFromUser();
                    }, icon: Icon(Icons.calendar_month_rounded, color: Get.isDarkMode?Colors.white:Colors.black,),
                  ),
              ),
              Row(
                children: [
                  Expanded(child: MyInputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Get.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ),),
                  const SizedBox(width: 10,),
                  Expanded(child: MyInputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Get.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ),),
                ],
              ),
              MyInputField(title: "Note", hint: "Enter Your Note", controller: _noteController,),
              MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind before",
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Get.isDarkMode?Colors.white:Colors.black,),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    items: remindList.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    underline: Container(height: 0,),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = newValue!;
                      });
                    },
                  ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalete(),
                  MyButton(label: "Add Event", onTap: ()=>_validateDate())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _colorPalete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle,),
        const SizedBox(height: 5,),
        Wrap(
          children: List<Widget>.generate(
            3,
                (int index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                    child: _selectedColor == index?Icon(Icons.done):Container(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _appBar(BuildContext context) {

    double iconSize = MediaQuery.of(context).size.width * iconPercentage / 100;

    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: iconSize,
          color: Get.isDarkMode ? Colors.white:Colors.black,),
      ),
      title: Center(child: Text("Add Event", style: headingStyle,)),
    );

  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030)
    );

    if(_pickerDate!=null){

      setState(() {
        _selectDate = _pickerDate;
      });

    }

  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickTime = await _showTimePicker();

    String formattedTime = pickTime.format(context);

    if(pickTime==null){
      print('time out');
    }else if(isStartTime==true){
      setState(() {
        _startTime = formattedTime;
      });
    }else if(isStartTime==false){
      setState(() {
        _endTime = formattedTime;
      });
    }

  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _validateDate(){

    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){

      _addTaskToDB();

      Get.back();

    } else if(_titleController.text.isEmpty || _noteController.text.isNotEmpty){

      Get.snackbar(
        "Required",
        "All Fields are Required !",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.warning_amber_rounded)
      );

    }

  }

  _addTaskToDB() async {
    int value = await _eventController.addEvent(
        event:Event(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );

    print("my Id is "+ "$value");

  }

}
