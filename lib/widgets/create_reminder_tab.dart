import 'package:flutter/material.dart';

class CreateReminderTab extends StatelessWidget {
  final String name;
  final TextEditingController titleController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onCommit;
  final List<List<TextEditingController>> tableData;

  final VoidCallback onAddColumn;
  final VoidCallback onAddRow;
  final Function(int) onRemoveRow;

  const CreateReminderTab({
    super.key,
    required this.name,
    required this.titleController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onPickDate,
    required this.onPickTime,
    required this.onCommit,
    required this.tableData,
    required this.onAddColumn,
    required this.onAddRow,
    required this.onRemoveRow,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 110.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Hello, ",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xFF1E3A8A).withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const TextSpan(text: " 👋", style: TextStyle(fontSize: 25)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Title Input Card
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
                    decoration: _inputDecoration(
                      "What do you want to remember?",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Split Time & Date Tiles
            Row(
              children: [
                Expanded(
                  child: _bentoBox(
                    child: InkWell(
                      onTap: onPickDate,
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
                      onTap: onPickTime,
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

            // Dynamic Metadata Matrix
            _bentoBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bentoLabel("CUSTOM TABLE", Icons.table_chart_rounded),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: onAddColumn,
                            child: const Text("Add Column"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: onAddRow,
                            child: const Text("Add Row"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      ...List.generate(tableData.length, (rowIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ...List.generate(tableData[rowIndex].length, (
                                colIndex,
                              ) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: TextField(
                                      controller: tableData[rowIndex][colIndex],
                                      decoration: InputDecoration(
                                        hintText: rowIndex == 0
                                            ? "Header ${colIndex + 1}"
                                            : "Value",
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              IconButton(
                                onPressed: () => onRemoveRow(rowIndex),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
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
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD97706).withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onCommit,
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
      ),
    );
  }

  Widget _bentoBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // 1. Made container color solid opaque white for structural definition
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // 2. Changed border to a subtle tint of blue instead of transparent white
        border: Border.all(
          color: const Color(0xFF2563EB).withOpacity(0.12),
          width: 1.5,
        ),
        // 3. Added a clean dual-shadow drop to provide depth/separation from background
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0xFF1E3A8A).withOpacity(0.3),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF2563EB).withOpacity(0.06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
      ),
    );
  }
}
