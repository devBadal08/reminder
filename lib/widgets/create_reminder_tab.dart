import 'package:flutter/material.dart';
import 'package:reminder/services/attachment_service.dart';

class CreateReminderTab extends StatefulWidget {
  final String name;
  final TextEditingController titleController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onCommit;
  final List<List<TextEditingController>> tableData;
  final List<String> attachmentPaths;
  final VoidCallback onPickMultipleAttachments;

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
    required this.attachmentPaths,
    required this.onPickMultipleAttachments,
  });

  @override
  State<CreateReminderTab> createState() => _CreateReminderTabState();
}

class _CreateReminderTabState extends State<CreateReminderTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F4F0),
      child: Stack(
        children: [
          // Replaced geometric sharp orange lines with a soft ambient theme-color radial glow
          Positioned(
            top: -140,
            left: -80,
            right: -80,
            child: ClipPath(
              clipper: TopGlowClipper(),
              child: Container(
                height: 290,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.25,
                    colors: [
                      const Color(0xFF8C4A32).withOpacity(0.20),
                      const Color(0xFF8C4A32).withOpacity(0.08),
                      const Color(0xFFF6F4F0),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 130.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header Section
                Stack(
                  children: [
                    // Existing header content
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Hello, ",
                                      style: TextStyle(
                                        fontSize: 26,
                                        color: Color(0xFF2D3142),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8C4A32),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " 👋",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Let's set up your reminder 🎉",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(
                                    0xFF2D3142,
                                  ).withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 95,
                              height: 95,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8C4A32).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF8C4A32,
                                ).withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Transform.rotate(
                              angle: 0.18,
                              child: const Text(
                                "🔔",
                                style: TextStyle(fontSize: 44),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xFF8C4A32),
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Title Input Card with Sketch Overlapping Design
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _bentoBox(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 36.0),
                              child: Text(
                                "Reminder Title",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: widget.titleController,
                              style: const TextStyle(
                                color: Color(0xFF2D3142),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: _inputDecoration(
                                "What do you want to remember?",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -16,
                      left: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8C4A32),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8C4A32).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Split Time & Date Tiles
                Row(
                  children: [
                    Expanded(
                      child: _bentoBox(
                        child: InkWell(
                          onTap: widget.onPickDate,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bentoLabel("Date", Icons.calendar_today_rounded),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.selectedDate == null
                                        ? "Select Date"
                                        : "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}",
                                    style: const TextStyle(
                                      color: Color(0xFF2D3142),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
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
                          onTap: widget.onPickTime,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bentoLabel("Time", Icons.access_time_rounded),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.selectedTime == null
                                        ? "Select Time"
                                        : widget.selectedTime!.format(context),
                                    style: const TextStyle(
                                      color: Color(0xFF2D3142),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Dynamic Metadata Matrix Card
                _bentoBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bentoLabel("Custom Table", Icons.table_chart_rounded),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _matrixActionButton(
                              label: "Add Column",
                              icon: Icons.add,
                              onTap: widget.onAddColumn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _matrixActionButton(
                              label: "Add Row",
                              icon: Icons.add,
                              onTap: widget.onAddRow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(widget.tableData.length, (rowIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  widget.tableData[rowIndex].length,
                                  (colIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: SizedBox(
                                        width: 110,
                                        child: TextField(
                                          controller: widget
                                              .tableData[rowIndex][colIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF2D3142),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: rowIndex == 0
                                                ? "Header ${colIndex + 1}"
                                                : "Value",
                                            hintStyle: TextStyle(
                                              color: const Color(
                                                0xFF2D3142,
                                              ).withOpacity(0.3),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFFBFBFB),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 12,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey.withOpacity(
                                                  0.15,
                                                ),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF8C4A32),
                                                width: 1.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () => widget.onRemoveRow(rowIndex),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xFF8C4A32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(
                          30,
                          (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey.withOpacity(0.3),
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _bentoBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bentoLabel("Attachment", Icons.attach_file_rounded),
                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: widget.onPickMultipleAttachments,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF8C4A32,
                                ).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(
                                    0xFF8C4A32,
                                  ).withOpacity(0.15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.upload_file,
                                    color: Color(0xFF8C4A32),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.attachmentPaths.isEmpty
                                          ? "Upload Images / PDF"
                                          : "${widget.attachmentPaths.length} files selected",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (widget.attachmentPaths.isNotEmpty) ...[
                            const SizedBox(height: 12),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.attachmentPaths.map((path) {
                                final fileName = path.split('/').last;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    fileName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: widget.onPickMultipleAttachments,
                                icon: const Icon(Icons.add),
                                label: const Text("Add More"),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Main Action Confirmation Button
                GestureDetector(
                  onTap: widget.onCommit,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAC5D3F), Color(0xFF8C4A32)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8C4A32).withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          const Text(
                            "Create Reminder",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Color(0xFF8C4A32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bentoBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _bentoLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8C4A32).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF8C4A32)),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _matrixActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF8C4A32).withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF8C4A32).withOpacity(0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF8C4A32)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8C4A32),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0xFF2D3142).withOpacity(0.35),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFFBFBFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF8C4A32), width: 1.2),
      ),
    );
  }
}

class TopGlowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 50);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
