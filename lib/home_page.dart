import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sleep_tracker/cubit/cubit/fetchdata_cubit.dart';
import 'package:sleep_tracker/local_storage.dart';
import 'package:sleep_tracker/my_bar_chart.dart';
import 'package:sleep_tracker/widgets/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorage _localStorage = LocalStorage();

  TimeOfDay? bedTime;
  TimeOfDay? wakingTime;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyButton(
                  onPressed: () async {
                    bedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    setState(() {});
                  },
                  text: "Bed Time",
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.06,
                ),
                SizedBox(height: screenHeight * 0.02),
                MyButton(
                  onPressed: () async {
                    wakingTime = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 6, minute: 0),
                    );
                    setState(() {});
                  },
                  text: "Waking Time",
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.06,
                ),
                SizedBox(height: screenHeight * 0.02),
                MyButton(
                  onPressed: () {
                    final String dayName = DateFormat.EEEE().format(DateTime.now());
                    if (wakingTime != null && bedTime != null) {
                      double duration = calculateSleepDuration(bedTime!, wakingTime!);
                      _localStorage.save(dayName, duration);
                      context.read<FetchdataCubit>().fetchData();
                      setState(() {
                        wakingTime = null;
                        bedTime = null;
                      });
        
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            icon: Icon(Icons.error, color: Colors.red),
                            title: Text("Missing Bedtime or Waking Time"),
                            content: Text("Please enter both bed time and waking time."),
                          );
                        },
                      );
                    }
                  },
                  text: "Save",
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.06,
                ),
                SizedBox(height: screenHeight * 0.04),
                Expanded(
                  child: MyBarChart(),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Recommendations",
                  style: TextStyle(
                    color: const Color(0xFF696969),
                    fontFamily: "Arial",
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "1. Maintain a consistent sleep schedule.\n"
                    "2. Avoid caffeine and heavy meals before bed.\n"
                    "3. Create a relaxing bedtime routine.\n"
                    "4. Keep your bedroom cool, dark, and quiet.",
                    style: TextStyle(
                      color: const Color(0xFF696969),
                      fontFamily: "Arial",
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateSleepDuration(TimeOfDay bedTime, TimeOfDay wakingTime) {
    final bedTimeInMinutes = bedTime.hour * 60 + bedTime.minute;
    final wakingTimeInMinutes = wakingTime.hour * 60 + wakingTime.minute;

    final durationInMinutes = wakingTimeInMinutes >= bedTimeInMinutes
        ? wakingTimeInMinutes - bedTimeInMinutes
        : (1440 - bedTimeInMinutes) + wakingTimeInMinutes;

    return (durationInMinutes / 60).roundToDouble();
  }
}
