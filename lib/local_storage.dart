import 'dart:math';

import 'package:hive/hive.dart';

class LocalStorage {
  final Box<Map<dynamic,dynamic>> _box = Hive.box<Map<dynamic,dynamic>>("sleep");


   Future<void> initializeData() async {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    for (int i = 0; i < days.length; i++) {
      if (!_box.containsKey(days[i])) {
        await _box.put(days[i], {"day":i,"duration":(Random().nextDouble()*24).floorToDouble()});
      }
    }
  }
  Future<void> save(String dayName,double duration)async{
    Map<String,int> days ={
      "Sunday":0,
      "Monday":1,
      "Tuesday":2,
      "Wednesday":3,
      "Thursday" : 4,
      "Friday":5,
      "Saturday":6
    };
    await _box.put(dayName, {"day":days[dayName],"duration":duration});
  }

  Map<dynamic,dynamic>? getDayData(String day){
    return _box.get(day);
  }

  List<Map<String,dynamic>> getAllValues(){
    print(_box.values.toList());
    var data =  _box.values
      .map((e) => Map<String, dynamic>.from(e)) // Explicitly cast each map
      .toList();

    data.sort((a,b)=>a["day"]?.compareTo(b["day"]));
    return data;
  }

  Future<void> deleteData()async{
    await _box.clear();
  }
}