import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder/services/notification_service.dart';

class RemindersTab extends StatelessWidget {
  const RemindersTab({super.key});

  @override
  Widget build(BuildContext context) {
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
            final List<dynamic>? tableData = reminder["tableData"];
            bool isExpanded =
                false; // Tracks the interactive collapse state locally

            return StatefulBuilder(
              builder: (context, setTileState) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withOpacity(0.12),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: const Color(0xFF2563EB).withOpacity(0.03),
                      ),
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        tilePadding: const EdgeInsets.fromLTRB(20, 12, 14, 12),
                        onExpansionChanged: (expanding) {
                          setTileState(() {
                            isExpanded = expanding;
                          });
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.alarm_on_rounded,
                            color: Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        title: Text(
                          reminder["title"] ?? "Untitled",
                          style: const TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            letterSpacing: -0.3,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 12,
                                    color: const Color(
                                      0xFF1E3A8A,
                                    ).withOpacity(0.4),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    reminder["date"]?.toString().split(
                                          " ",
                                        )[0] ??
                                        "No Date",
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF1E3A8A,
                                      ).withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 12,
                                    color: const Color(
                                      0xFF1E3A8A,
                                    ).withOpacity(0.4),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    reminder["time"] ?? "No Time",
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF1E3A8A,
                                      ).withOpacity(0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // --- "TAP TO SEE MORE" IMPLEMENTATION ---
                              if (tableData != null && tableData.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isExpanded
                                            ? "Tap to close"
                                            : "Tap to see more",
                                        style: TextStyle(
                                          color: isExpanded
                                              ? const Color(
                                                  0xFFEF4444,
                                                ).withOpacity(0.7)
                                              : const Color(0xFFF59E0B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        size: 14,
                                        color: isExpanded
                                            ? const Color(
                                                0xFFEF4444,
                                              ).withOpacity(0.7)
                                            : const Color(0xFFF59E0B),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final reminderData = box.getAt(index);
                              final alarmId = reminderData["alarmId"];

                              await Alarm.stop(alarmId);
                              await NotificationService.notifications.cancel(
                                alarmId,
                              );
                              await box.deleteAt(index);
                            } catch (e) {
                              print("Delete Error: $e");
                            }
                          },
                        ),
                        children: [
                          if (tableData != null && tableData.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Divider(
                                color: Color(0xFFF1F5F9),
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Table(
                                        defaultColumnWidth:
                                            const FixedColumnWidth(130.0),
                                        children: List.generate(tableData.length, (
                                          rowIndex,
                                        ) {
                                          final row =
                                              tableData[rowIndex] as List;
                                          final bool isHeader = rowIndex == 0;

                                          return TableRow(
                                            children: List.generate(row.length, (
                                              colIndex,
                                            ) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isHeader
                                                      ? const Color(
                                                          0xFF2563EB,
                                                        ).withOpacity(0.08)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: isHeader
                                                        ? const Color(
                                                            0xFF2563EB,
                                                          ).withOpacity(0.15)
                                                        : const Color(
                                                            0xFFE2E8F0,
                                                          ),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  row[colIndex].toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: isHeader
                                                        ? FontWeight.w800
                                                        : FontWeight.w500,
                                                    color: isHeader
                                                        ? const Color(
                                                            0xFF1D4ED8,
                                                          )
                                                        : const Color(
                                                            0xFF1E3A8A,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
