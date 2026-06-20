import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:reminder/screens/full_screen_image_page.dart';
import 'package:reminder/services/notification_service.dart';

class RemindersTab extends StatelessWidget {
  const RemindersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('reminders').listenable(),
      builder: (context, Box box, _) {
        return Stack(
          children: [
            // Elegant glowing aura backdrop instead of standard geometric circles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFFFFECE2,
                      ).withOpacity(0.85), // Soft peach core glow
                      const Color(
                        0xFFF6F4F0,
                      ), // Fades seamlessly into your page background
                    ],
                    stops: const [0.2, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -15,
              right: 20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8C4A32).withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),

            // Top Header Configuration Block
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ), // Adjusted alignment pad matching text label baseline
                        Text(
                          "Review your timeline.\nEverything is under control.",
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF2D3142).withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rendered 3D Calendar Graphic Asset Image integration layer
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0, top: 0.0),
                    child: Image.asset(
                      'assets/calendar_bell.png', // Reference target layout graphic asset path mapping keys
                      width: 120,
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("📅", style: TextStyle(fontSize: 54));
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Main Reminders Timeline Feed Content Container
            Padding(
              padding: const EdgeInsets.only(
                top: 110.0,
              ), // Pulled up lists context wrapper boundary safely
              child: box.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF8C4A32,
                                    ).withOpacity(0.06),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF8C4A32,
                                    ).withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Text(
                                  "📋",
                                  style: TextStyle(fontSize: 54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "All your reminders will\nappear here.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3142),
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8C4A32),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        16.0,
                        20.0,
                        140.0,
                      ),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final reminder = box.getAt(index);
                        print(reminder);
                        final List<dynamic>? tableData = reminder["tableData"];
                        final List<dynamic>? attachmentPaths =
                            reminder["attachmentPaths"] as List?;

                        return StatefulBuilder(
                          builder: (context, setTileState) {
                            final tileKey = ValueKey('reminder_tile_$index');

                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFF1F1F1),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.015),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                clipBehavior: Clip
                                    .none, // Allow custom corner curve painter to draw exactly over the border path line
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                        splashColor: const Color(
                                          0xFF8C4A32,
                                        ).withOpacity(0.02),
                                      ),
                                      child: ExpansionTile(
                                        key: tileKey,
                                        backgroundColor: Colors.white,
                                        collapsedBackgroundColor: Colors.white,
                                        tilePadding: const EdgeInsets.fromLTRB(
                                          16,
                                          14,
                                          12,
                                          14,
                                        ),
                                        childrenPadding: EdgeInsets.zero,
                                        leading: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF8C4A32,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.access_alarm_rounded,
                                            color: Color(0xFF8C4A32),
                                            size: 24,
                                          ),
                                        ),
                                        title: Text(
                                          reminder["title"] ?? "Untitled",
                                          style: const TextStyle(
                                            color: Color(0xFF2D3142),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 14,
                                                runSpacing: 6,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 14,
                                                        color: Color(
                                                          0xFF8C4A32,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        reminder["date"]
                                                                ?.toString()
                                                                .split(
                                                                  " ",
                                                                )[0] ??
                                                            "No Date",
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF2D3142,
                                                          ).withOpacity(0.6),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 14,
                                                        color: Color(
                                                          0xFF8C4A32,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        reminder["time"] ??
                                                            "No Time",
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              if (tableData != null &&
                                                  tableData.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 12.0,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Tap to see more",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF8C4A32,
                                                          ),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        size: 14,
                                                        color: const Color(
                                                          0xFF8C4A32,
                                                        ).withOpacity(0.8),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF8C4A32,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color(0xFF8C4A32),
                                                  size: 20,
                                                ),
                                              ),
                                              onPressed: () async {
                                                try {
                                                  final reminderData = box
                                                      .getAt(index);
                                                  final alarmId =
                                                      reminderData["alarmId"];
                                                  await Alarm.stop(alarmId);
                                                  await NotificationService
                                                      .notifications
                                                      .cancel(alarmId);
                                                  await box.deleteAt(index);
                                                } catch (e) {
                                                  debugPrint(
                                                    "Delete Error: $e",
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        children: [
                                          if (tableData != null &&
                                              tableData.isNotEmpty) ...[
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                              ),
                                              child: Divider(
                                                color: Color(0xFFF1F1F1),
                                                height: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                14.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFBFBFB,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE5E5E5,
                                                    ),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6.0,
                                                          ),
                                                      child: Table(
                                                        defaultColumnWidth:
                                                            const FixedColumnWidth(
                                                              120.0,
                                                            ),
                                                        children: List.generate(tableData.length, (
                                                          rowIndex,
                                                        ) {
                                                          final row =
                                                              tableData[rowIndex]
                                                                  as List;
                                                          final bool isHeader =
                                                              rowIndex == 0;

                                                          return TableRow(
                                                            children: List.generate(row.length, (
                                                              colIndex,
                                                            ) {
                                                              return Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                margin:
                                                                    const EdgeInsets.all(
                                                                      2,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      isHeader
                                                                      ? const Color(
                                                                          0xFF8C4A32,
                                                                        ).withOpacity(
                                                                          0.08,
                                                                        )
                                                                      : Colors
                                                                            .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                  border: Border.all(
                                                                    color:
                                                                        isHeader
                                                                        ? const Color(
                                                                            0xFF8C4A32,
                                                                          ).withOpacity(
                                                                            0.15,
                                                                          )
                                                                        : const Color(
                                                                            0xFFEFEFEF,
                                                                          ),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  row[colIndex]
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        rowIndex ==
                                                                            0
                                                                        ? FontWeight
                                                                              .w800
                                                                        : FontWeight
                                                                              .w500,
                                                                    color: const Color(
                                                                      0xFF2D3142,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],

                                          if (attachmentPaths != null &&
                                              attachmentPaths.isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    16,
                                                    12,
                                                    16,
                                                    8,
                                                  ),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFBFBFB,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE5E5E5,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Attachments",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF8C4A32,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),

                                                    ...attachmentPaths.map((
                                                      path,
                                                    ) {
                                                      final String filePath =
                                                          path.toString();
                                                      final bool isPdf =
                                                          filePath
                                                              .toLowerCase()
                                                              .endsWith(".pdf");

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 12,
                                                            ),
                                                        child: isPdf
                                                            ? InkWell(
                                                                onTap: () {
                                                                  OpenFilex.open(
                                                                    filePath,
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .picture_as_pdf_rounded,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 34,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        filePath
                                                                            .split(
                                                                              '/',
                                                                            )
                                                                            .last,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .open_in_new,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (_) => FullScreenImagePage(
                                                                        imagePath:
                                                                            filePath,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(
                                                                      0xFFF7F7F7,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                    border: Border.all(
                                                                      color: const Color(
                                                                        0xFFE5E5E5,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .image_rounded,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          filePath
                                                                              .split(
                                                                                '/',
                                                                              )
                                                                              .last,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .open_in_full,
                                                                        size:
                                                                            18,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Repositioned Custom Paint block outside the clipped layout view to align precisely on the container border frame
                                  Positioned(
                                    bottom:
                                        -0.6, // Nudges the custom painter line to sit exactly flush on top of the 1.2px frame outline
                                    left: -0.6,
                                    child: CustomPaint(
                                      size: const Size(
                                        26,
                                        26,
                                      ), // Match path radius
                                      painter: CornerCurvePainter(
                                        color: const Color(
                                          0xFF8C4A32,
                                        ), // Keeps your bright highlighted designer asset accent intact
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top:
                                        0.6, // Nudges the custom painter line to sit exactly flush on top of the 1.2px frame outline
                                    right: 0.6,
                                    child: CustomPaint(
                                      size: const Size(
                                        26,
                                        26,
                                      ), // Match path radius
                                      painter: TopCornerCurvePainter(
                                        color: const Color(
                                          0xFF8C4A32,
                                        ), // Keeps your bright highlighted designer asset accent intact
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class CornerCurvePainter extends CustomPainter {
  final Color color;
  CornerCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap
          .round // Smooth outer edge terminators matching original image design asset layer
      ..strokeWidth =
          3.5; // Thicker weight footprint matches card outer border line perfectly

    final path = Path()
      ..moveTo(0, size.height - 24) // Sweep start matches corner radius arcs
      ..quadraticBezierTo(0, size.height, 24, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TopCornerCurvePainter extends CustomPainter {
  final Color color;

  TopCornerCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path()
      ..moveTo(size.width - 24, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 24);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
