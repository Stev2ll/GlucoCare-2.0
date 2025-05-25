import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Alarma/widgets/reg_recordatorio.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class HomeAlarm extends StatefulWidget {
  const HomeAlarm({super.key});

  @override
  State<HomeAlarm> createState() => _HomeAlarmState();
}

class _HomeAlarmState extends State<HomeAlarm> with SingleTickerProviderStateMixin {
  late String _timeString;
  late TabController _tabController;
  Timer? _timer;

  TimeOfDay? medicationTime;
  TimeOfDay? checkupTime;
  TimeOfDay? appointmentTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _timeString = _formatDateTime(DateTime.now());
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _saveReminder(String type, TimeOfDay? time) async {
    if (time == null) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final reminder = {
      'hora': time.format(context),
      'tipo': type,
      'fechaRegistro': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'idUsuario': user.uid,
    };

    await _firestore.collection('recordatorio').add(reminder);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recordatorio de $type guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            color: isDark ? TColors.black : Theme.of(context).primaryColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(icon: Icon(Icons.access_time), text: 'Reloj'),
                Tab(icon: Icon(Icons.alarm), text: 'Recordatorios'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildClockTab(context),
            const ReminderSettingsScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildClockTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            _timeString,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceSansPro',
              color: TColors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Configurar Notificaciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildTimePickerRow('Medicación', medicationTime, (t) => setState(() => medicationTime = t)),
          _buildTimePickerRow('Chequeos', checkupTime, (t) => setState(() => checkupTime = t)),
          _buildTimePickerRow('Citas', appointmentTime, (t) => setState(() => appointmentTime = t)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              if (medicationTime == null && checkupTime == null && appointmentTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selecciona al menos una hora')),
                );
                return;
              }

              await _saveReminder('Medicación', medicationTime);
              await _saveReminder('Chequeos', checkupTime);
              await _saveReminder('Citas', appointmentTime);

              setState(() {
                medicationTime = null;
                checkupTime = null;
                appointmentTime = null;
              });
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar Recordatorios'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerRow(String label, TimeOfDay? time, Function(TimeOfDay) onTimeSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(
                time?.format(context) ?? '--:--',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: time ?? TimeOfDay.now(),
                  );
                  if (picked != null) onTimeSelected(picked);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
