import 'dart:ui';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder/services/alarm_service.dart';
import 'package:reminder/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Page Navigation Controllers
  final PageController _pageController = PageController();
  int _currentTab = 0;

  // Form Field Controllers
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final List<Map<String, TextEditingController>> customFields = [];

  // RINGTONE CONTEXT SELECTION STREAMS
  String selectedRingtone =
      'assets/audio/alarm1.mp3'; // Default sound string fallback
  final List<Map<String, String>> ringtoneOptions = [
    {'id': 'assets/audio/alarm1.mp3', 'label': 'Alarm 1'},
    {'id': 'assets/audio/alarm2.mp3', 'label': 'Alarm 2'},
    {'id': 'assets/audio/alarm3.mp3', 'label': 'Alarm 3'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    titleController.dispose();
    for (var field in customFields) {
      field['key']?.dispose();
      field['value']?.dispose();
    }
    super.dispose();
  }

  void _addCustomField() {
    setState(() {
      customFields.add({
        'key': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void _removeCustomField(int index) {
    setState(() {
      customFields[index]['key']?.dispose();
      customFields[index]['value']?.dispose();
      customFields.removeAt(index);
    });
  }

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
    if (selectedDate == null || selectedTime == null) {
      return null;
    }

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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

          // Navigation Flow
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentTab = index),
                    children: [_buildBentoCreateTab(), _buildBentoDisplayTab()],
                  ),
                ),
              ],
            ),
          ),

          // Top Header Panel Widget
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _currentTab == 0
                            ? Icons.add_circle_outline_rounded
                            : Icons.space_dashboard_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentTab == 0 ? "Workspace" : "Reminders",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E3A8A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

  Widget _buildBentoCreateTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Welcome back,\n",
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF1E3A8A).withOpacity(0.5),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: widget.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tile 1: Title Input Card
          _bentoBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bentoLabel("REMINDER TITLE", Icons.edit_note_rounded),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration("What do you want to remember?"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Row 2: Split Time & Date Tiles
          Row(
            children: [
              Expanded(
                child: _bentoBox(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bentoLabel("DATE", Icons.calendar_today_rounded),
                        const SizedBox(height: 12),
                        Text(
                          selectedDate == null
                              ? "Select Date"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _bentoBox(
                  child: InkWell(
                    onTap: () => _pickTime(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bentoLabel("TIME", Icons.access_time_rounded),
                        const SizedBox(height: 12),
                        Text(
                          selectedTime == null
                              ? "Select Time"
                              : selectedTime!.format(context),
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tile 3: Dynamic Metadata Matrix
          _bentoBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bentoLabel(
                      "CUSTOM META FIELDS",
                      Icons.dashboard_customize_rounded,
                    ),
                    GestureDetector(
                      onTap: _addCustomField,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 14,
                              color: Color(0xFF2563EB),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Add",
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (customFields.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        "Tap Add to supply custom criteria.",
                        style: TextStyle(
                          color: const Color(0xFF1E3A8A).withOpacity(0.35),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ...List.generate(customFields.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: customFields[index]['key'],
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: _inputDecoration("Label (e.g. Price)"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: customFields[index]['value'],
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: _inputDecoration("Value data"),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeCustomField(index),
                          icon: const Icon(
                            Icons.cancel_rounded,
                            color: Color(0xFFEF4444),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Submit Commitment Action Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
            ),
            child: ElevatedButton(
              onPressed: _saveReminderToHive,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Commit Reminder",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoDisplayTab() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('reminders').listenable(),
      builder: (context, Box box, _) {
        if (box.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.widgets_rounded,
                  size: 54,
                  color: const Color(0xFF1E3A8A).withOpacity(0.15),
                ),
                const SizedBox(height: 12),
                Text(
                  "Your timeline is clear.",
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF1E3A8A).withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 110.0),
          itemCount: box.length,
          itemBuilder: (context, index) {
            final reminder = box.getAt(index);
            final Map<dynamic, dynamic>? dynFields = reminder["customFields"];
            final String ringtoneId = reminder["ringtone"] ?? "alarm1";

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.6)),
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.alarm_on_rounded,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                title: Text(
                  reminder["title"] ?? "Untitled",
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "${reminder["date"]?.toString().split(" ")[0] ?? "No Date"}  •  ${reminder["time"] ?? "No Time"}\n🎵 Sound ID: $ringtoneId",
                  style: TextStyle(
                    color: const Color(0xFF1E3A8A).withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 22,
                  ),
                  onPressed: () async {
                    try {
                      final reminder = box.getAt(index);

                      final alarmId = reminder["alarmId"];

                      print(reminder["alarmId"]);
                      await Alarm.stop(alarmId);

                      await NotificationService.notifications.cancel(alarmId);

                      await box.deleteAt(index);

                      print("Deleted alarm: $alarmId");
                    } catch (e) {
                      print("Delete Error: $e");
                    }
                  },
                ),
                children: [
                  if (dynFields != null && dynFields.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: dynFields.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key.toString(),
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF1E3A8A,
                                      ).withOpacity(0.5),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    entry.value.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF1E3A8A),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bentoBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _bentoLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF2563EB)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2563EB),
            letterSpacing: 1.2,
          ),
        ),
      ],
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
          color: isSelected
              ? const Color(0xFF1E3A8A)
              : Colors.white.withOpacity(0.85),
          border: Border.all(
            color: isSelected ? const Color(0xFFF59E0B) : Colors.white,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFF59E0B)
              : const Color(0xFF1E3A8A).withOpacity(0.5),
          size: 22,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0xFF1E3A8A).withOpacity(0.3),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC).withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
      ),
    );
  }

  Future<void> _saveReminderToHive() async {
    final box = Hive.box('reminders');
    final Map<String, String> fields = {};

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reminder title")),
      );
      return;
    }

    for (var field in customFields) {
      final key = field['key']!.text.trim();
      final value = field['value']!.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) fields[key] = value;
    }

    // 1. Commit variables to Hive along with the active ringtone selection ID
    final int uniqueAlarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    box.add({
      "alarmId": uniqueAlarmId,
      "title": titleController.text.trim(),
      "date": selectedDate?.toString(),
      "time": selectedTime?.format(context),
      "customFields": fields,
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
      customFields.clear();
      selectedRingtone =
          'assets/audio/alarm1.mp3'; // Reset dropdown selection to default
    });
  }
}
