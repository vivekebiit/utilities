import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutTimeCalculator extends StatefulWidget {
  const OutTimeCalculator({Key? key}) : super(key: key);

  @override
  State<OutTimeCalculator> createState() => _OutTimeCalculatorState();
}

class _OutTimeCalculatorState extends State<OutTimeCalculator> {
  final inTimeController = TextEditingController();
  final outTimeController = TextEditingController();

  final _formGlobalKey = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();
  final now = DateTime.now();

  var selectedDateTime;
  var outTime = "", inTime = "";
  bool isTimeSelected = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
        final now = DateTime.now();
        final temp = DateTime(now.year, now.month, now.day, selectedTime.hour,
                selectedTime.minute)
            .add(const Duration(hours: 9, minutes: 30));

        selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);

        inTime = DateFormat("h:mm a").format(selectedDateTime);
        outTime = DateFormat("h:mm a").format(temp);

        inTimeController.text = DateFormat("h:mm a").format(selectedDateTime);
        outTimeController.text = outTime;
        isTimeSelected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isTimeSelected = false;
    setState(() {
      inTimeController.text = DateFormat("h:mm a")
          .format(DateTime(now.year, now.month, now.day, now.hour, now.minute));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Out Time Calculator')),
      body: isTimeSelected
          ? Container(
              width: double.infinity,
              color: Colors.white,
              child: SizedBox(
                height: 110,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Out Time',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                outTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Checked In ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(inTime,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            )
          : Container(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Select Time'),
        onPressed: () {
          _selectTime(context);
        },
        icon: const Icon(Icons.timer),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Form inputs() {
    return Form(
      key: _formGlobalKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: inTimeController,
                keyboardType: TextInputType.number,
                readOnly: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Hour is required';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'In Time',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Flexible(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                readOnly: true,
                controller: outTimeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Minutes is required';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    labelText: 'Out Time',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
