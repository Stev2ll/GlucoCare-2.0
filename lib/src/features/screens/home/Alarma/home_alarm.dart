import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Alarma/widgets/reg_recordatorio.dart';
import 'package:gluco_care/src/features/screens/home/Alarma/widgets/shapes_painter.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class HomeAlarm extends StatefulWidget {
  const HomeAlarm({super.key});

  @override
  State<HomeAlarm> createState() => _HomeAlarmState();
}

class _HomeAlarmState extends State<HomeAlarm>
    with SingleTickerProviderStateMixin {
  late String _timeString;
  late TabController _tabController;
  Timer? _timer;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? medicationTime;
  TimeOfDay? checkupTime;
  TimeOfDay? appointmentTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);

    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        _updateTime();
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  Future<void> _saveReminder(String type, TimeOfDay? time) async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        time == null) return;

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final user = _auth.currentUser;
    if (user == null) return;

    final reminder = {
      'titulo': _titleController.text,
      'descripcion': _descriptionController.text,
      'hora': time.format(context),
      'tipo': type,
      'fechaRegistro': formattedDate,
      'idUsuario': user.uid,
    };
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recordatorio guardado')),
      );
    await _firestore.collection('recordatorio').add(reminder);

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            color: isDarkTheme ? TColors.black : Theme.of(context).primaryColor,
            child: TabBar(
              labelColor: TColors.white,
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3.0,
              tabs: const [
                Tab(icon: Icon(Icons.access_time), text: 'Reloj'),
                Tab(icon: Icon(Icons.alarm), text: 'Recordatorios'),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          color: TColors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: ShapesPainter(),
                        child: Container(
                          height: 115,
                        ),
                      ),
                    ),
                    Text(
                      _timeString,
                      style: const TextStyle(
                        color: TColors.black,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                    const Text(
                      'Configurar Notificaciones',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                    ),
                    const SizedBox(height: 8),
                    _buildTimePickerRow('Medicación', medicationTime, (time) {
                      setState(() {
                        medicationTime = time;
                      });
                    }),
                    _buildTimePickerRow('Chequeos', checkupTime, (time) {
                      setState(() {
                        checkupTime = time;
                      });
                    }),
                    _buildTimePickerRow('Citas', appointmentTime, (time) {
                      setState(() {
                        appointmentTime = time;
                      });
                    }),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        onPressed: () async {
                          await _saveReminder('Medicación', medicationTime);
                          await _saveReminder('Chequeos', checkupTime);
                          await _saveReminder('Citas', appointmentTime);
                          _titleController.clear();
                          _descriptionController.clear();
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
              const ReminderSettingsScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerRow(
      String label, TimeOfDay? time, Function(TimeOfDay) onTimeSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(time?.format(context) ?? '--:--'),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context, time, onTimeSelected),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }
}
