import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Alarma/widgets/home_alarm.dart';
import 'package:gluco_care/src/utils/theme/theme.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home:  const HomeAlarm()
    );
  }
}