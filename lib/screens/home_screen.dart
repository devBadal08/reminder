import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminder/screens/name_screen.dart';
import 'package:reminder/services/alarm_service.dart';
import 'package:reminder/services/attachment_service.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:reminder/widgets/create_reminder_tab.dart';
import 'package:reminder/widgets/reminders_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> attachmentPaths = [];

  Future<void> pickMultipleAttachments() async {
    final paths = await AttachmentService.pickAndSaveFiles(allowMultiple: true);

    if (paths.isNotEmpty) {
      setState(() {
        attachmentPaths.addAll(paths);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    titleController.dispose();
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

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8C4A32),
            onPrimary: Colors.white,
            onSurface: Color(0xFF2D3142),
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
            primary: Color(0xFF8C4A32),
            onPrimary: Colors.white,
            onSurface: Color(0xFF2D3142),
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

  Future<void> _saveReminder() async {
    FocusScope.of(context).unfocus();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print("SAVE TOKEN: $token");

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login again")));
      return;
    }

    final List<List<String>> table = tableData
        .map((row) => row.map((c) => c.text.trim()).toList())
        .toList();

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter reminder title")),
      );
      return;
    }

    final reminderDateTime = getReminderDateTime();

    print("Date: $selectedDate");
    print("Time: $selectedTime");
    print("DateTime: $reminderDateTime");

    final int uniqueAlarmId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final response = await http.post(
      Uri.parse('http://192.168.1.2:8000/api/reminders'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "title": titleController.text.trim(),
        "reminder_datetime": reminderDateTime?.toIso8601String(),
        "table_data": table,
        "attachment_paths": attachmentPaths,
        "alarm_id": uniqueAlarmId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (reminderDateTime != null) {
        await AlarmService.scheduleAlarm(
          id: uniqueAlarmId,
          title: titleController.text.trim(),
          dateTime: reminderDateTime,
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reminder saved")));

      setState(() {
        titleController.clear();
        selectedDate = null;
        selectedTime = null;
        attachmentPaths.clear();

        for (var row in tableData) {
          for (var controller in row) {
            controller.dispose();
          }
        }

        tableData = [
          [TextEditingController(), TextEditingController()],
        ];
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'] ?? "Save failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4F0).withOpacity(0.6),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          color: const Color(0xFF8C4A32),
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
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8C4A32),
            letterSpacing: -0.4,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Navigation PageView content screen workspace area
          SafeArea(
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
                        onCommit: _saveReminder,
                        tableData: tableData,
                        onAddColumn: addColumn,
                        onAddRow: addRow,
                        onRemoveRow: removeRow,
                        attachmentPaths: attachmentPaths,
                        onPickMultipleAttachments: pickMultipleAttachments,
                      ),
                      const RemindersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Glassmorphic Floating Pill Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 34.0,
                left: 24.0,
                right: 24.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double totalWidth = constraints.maxWidth;
                        final double tabWidth = totalWidth / 2;

                        return Stack(
                          children: [
                            // Sliding highlighted active capsule background slider
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutQuint,
                              left: _currentTab == 0 ? 0 : tabWidth,
                              width: tabWidth,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8C4A32),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8C4A32,
                                      ).withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Interactive text and icon buttons row layer
                            Row(
                              children: [
                                // Tab 1: Create Trigger Block
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _navigateToPage(0),
                                    behavior: HitTestBehavior.opaque,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_task_rounded,
                                            color: _currentTab == 0
                                                ? Colors.white
                                                : const Color(
                                                    0xFF2D3142,
                                                  ).withOpacity(0.5),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Create",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: _currentTab == 0
                                                  ? Colors.white
                                                  : const Color(
                                                      0xFF2D3142,
                                                    ).withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Tab 2: Reminders Trigger Block
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _navigateToPage(1),
                                    behavior: HitTestBehavior.opaque,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.folder_open_rounded,
                                            color: _currentTab == 1
                                                ? Colors.white
                                                : const Color(
                                                    0xFF2D3142,
                                                  ).withOpacity(0.5),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Reminders",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: _currentTab == 1
                                                  ? Colors.white
                                                  : const Color(
                                                      0xFF2D3142,
                                                    ).withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutQuint,
    );
  }
}
