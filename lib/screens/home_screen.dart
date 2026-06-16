import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:reminder/screens/name_screen.dart';
import 'package:reminder/services/alarm_service.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:reminder/widgets/create_reminder_tab.dart';
import 'package:reminder/widgets/reminders_tab.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentTab = 0;

  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<List<TextEditingController>> tableData = [
    [TextEditingController(), TextEditingController()],
  ];

  String selectedRingtone = 'assets/audio/alarm1.mp3';

  @override
  void dispose() {
    _pageController.dispose();
    titleController.dispose();
    // for (var field in customFields) {
    //   field['key']?.dispose();
    //   field['value']?.dispose();
    // }
    super.dispose();
  }

  void addColumn() {
    setState(() {
      for (var row in tableData) {
        row.add(TextEditingController());
      }
    });
  }

  void addRow() {
    setState(() {
      tableData.add(
        List.generate(tableData.first.length, (_) => TextEditingController()),
      );
    });
  }

  void removeRow(int index) {
    setState(() {
      for (var controller in tableData[index]) {
        controller.dispose();
      }

      tableData.removeAt(index);
    });
  }

  // void _removeCustomField(int index) {
  //   setState(() {
  //     customFields[index]['key']?.dispose();
  //     customFields[index]['value']?.dispose();
  //     customFields.removeAt(index);
  //   });
  // }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1D4ED8),
            onPrimary: Colors.white,
            onSurface: Color(0xFF1E3A8A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1D4ED8),
            onPrimary: Colors.white,
            onSurface: Color(0xFF1E3A8A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  DateTime? getReminderDateTime() {
    if (selectedDate == null || selectedTime == null) return null;
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  Future<void> _saveReminderToHive() async {
    final box = Hive.box('reminders');
    final List<List<String>> table = tableData
        .map((row) => row.map((controller) => controller.text.trim()).toList())
        .toList();

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reminder title")),
      );
      return;
    }

    // for (var field in customFields) {
    //   final key = field['key']!.text.trim();
    //   final value = field['value']!.text.trim();
    //   if (key.isNotEmpty && value.isNotEmpty) fields[key] = value;
    // }

    final int uniqueAlarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print(table);
    box.add({
      "alarmId": uniqueAlarmId,
      "title": titleController.text.trim(),
      "date": selectedDate?.toString(),
      "time": selectedTime?.format(context),
      "tableData": table,
      "ringtone": selectedRingtone,
    });

    final reminderDateTime = getReminderDateTime();

    if (reminderDateTime != null && reminderDateTime.isAfter(DateTime.now())) {
      await NotificationService.scheduleNotification(
        id: uniqueAlarmId,
        title: titleController.text.trim(),
        body: "Reminder Time",
        scheduledDate: reminderDateTime,
      );

      await AlarmService.scheduleAlarm(
        id: uniqueAlarmId,
        title: titleController.text.trim(),
        dateTime: reminderDateTime,
      );
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.offline_pin_rounded, color: Color(0xFFD97706)),
              SizedBox(width: 12),
              Text(
                "Saved to timeline!",
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    titleController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
      // customFields.clear();
      tableData = [
        [TextEditingController(), TextEditingController()],
      ];
      selectedRingtone = 'assets/audio/alarm1.mp3';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.45),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70.0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF1E3A8A),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const NameScreen()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          _currentTab == 0 ? "Create Reminder" : "My Reminders",
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
            letterSpacing: -0.4,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF1E3A8A).withOpacity(0.12),
            height: 1.0,
          ),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          // Background Vector Auras
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: screenSize.width * 0.9,
              height: screenSize.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2563EB).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.3,
            left: -screenSize.width * 0.4,
            child: Container(
              width: screenSize.width * 1.1,
              height: screenSize.width * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFF59E0B).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Navigation Flow PageView
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentTab = index),
                    children: [
                      CreateReminderTab(
                        name: widget.name,
                        titleController: titleController,
                        selectedDate: selectedDate,
                        selectedTime: selectedTime,
                        onPickDate: () => _pickDate(context),
                        onPickTime: () => _pickTime(context),
                        onCommit: _saveReminderToHive,
                        tableData: tableData,
                        onAddColumn: addColumn,
                        onAddRow: addRow,
                        onRemoveRow: removeRow,
                      ),
                      const RemindersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Navigation Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularNavButton(index: 0, icon: Icons.create_rounded),
                  const SizedBox(width: 28),
                  _buildCircularNavButton(
                    index: 1,
                    icon: Icons.folder_special_rounded,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularNavButton({required int index, required IconData icon}) {
    final bool isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutQuint,
      ),
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // 1. Swapped unselected background from glassy white opacity to sharp solid white
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
          border: Border.all(
            // 2. Swapped unselected white border for a subtle themed blue border outline tint
            color: isSelected
                ? const Color(0xFFF59E0B)
                : const Color(0xFF2563EB).withOpacity(0.12),
            width: isSelected ? 2.5 : 1.5,
          ),
          // 3. Added premium drop shadows to make buttons float clearly above background vectors
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF1E3A8A).withOpacity(0.25)
                  : const Color(0xFF1E3A8A).withOpacity(0.08),
              blurRadius: isSelected ? 16 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFF59E0B)
              : const Color(0xFF1E3A8A).withOpacity(0.6),
          size: 22,
        ),
      ),
    );
  }
}
