import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SmartAlarmDialog extends StatefulWidget {
  final Map<String, dynamic> task;

  const SmartAlarmDialog({super.key, required this.task});

  @override
  State<SmartAlarmDialog> createState() => _SmartAlarmDialogState();
}

class _SmartAlarmDialogState extends State<SmartAlarmDialog> {
  late bool tempEnabled;
  late int offsetDays;
  late bool isRelativeAfter;
  late TimeOfDay selectedTime;
  late DateTime currentResultDate;
  late DateTime today;
  late DateTime calendarFocusDate;
  late Key calendarKey;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    tempEnabled = (widget.task['isAlarmEnabled'] ?? false) as bool;
    offsetDays = 0;
    isRelativeAfter = true;
    currentResultDate = (widget.task['alarmDate'] ?? DateTime.now());
    selectedTime = TimeOfDay.fromDateTime(currentResultDate);
    calendarFocusDate = currentResultDate;
    calendarKey = UniqueKey();
  }

  void _updateDateByOffset() {
    DateTime base = isRelativeAfter ? DateTime.now() : widget.task['dueDate'];
    int direction = isRelativeAfter ? 1 : -1;
    currentResultDate = DateTime(
      base.year,
      base.month,
      base.day + (offsetDays * direction),
      selectedTime.hour,
      selectedTime.minute,
    );
    if (tempEnabled) {
      calendarFocusDate = currentResultDate;
      calendarKey = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    bool isTodayAlarm = tempEnabled && isSameDay(currentResultDate, today);

    return AlertDialog(
      title: const Text("알람 상세 설정", textAlign: TextAlign.center),
      content: SizedBox(
        width: 850,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildSettingsPanel()),
            const VerticalDivider(width: 40),
            Expanded(flex: 1, child: _buildCalendarPanel(isTodayAlarm)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'isEnabled': tempEnabled,
            'date': currentResultDate,
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          child: const Text("저장 및 반영"),
        ),
      ],
    );
  }

  // --- 기존 main_backup.dart의 UI 컴포넌트들 ---
  Widget _buildSettingsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.power_settings_new, size: 18),
              const SizedBox(width: 10),
              const Text(
                "알람 기능 활성화",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                value: tempEnabled,
                onChanged: (v) => setState(() {
                  tempEnabled = v;
                  calendarKey = UniqueKey();
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: tempEnabled ? 1.0 : 0.3,
          child: AbsorbPointer(
            absorbing: !tempEnabled,
            child: Column(
              children: [
                ToggleButtons(
                  isSelected: [isRelativeAfter, !isRelativeAfter],
                  onPressed: (index) => setState(() {
                    isRelativeAfter = index == 0;
                    _updateDateByOffset();
                  }),
                  borderRadius: BorderRadius.circular(8),
                  constraints: const BoxConstraints(
                    minHeight: 35,
                    minWidth: 100,
                  ),
                  children: const [Text("오늘 후"), Text("마감 전")],
                ),
                const SizedBox(height: 20),
                _buildOffsetControls(),
                const SizedBox(height: 20),
                _buildTimeAndDateDisplay(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffsetControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOffsetBtn("-10", -10),
        const SizedBox(width: 4),
        _buildOffsetBtn("-1", -1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "$offsetDays 일",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildOffsetBtn("+1", 1),
        const SizedBox(width: 4),
        _buildOffsetBtn("+10", 10),
      ],
    );
  }

  Widget _buildOffsetBtn(String label, int val) {
    return SizedBox(
      width: 48,
      child: OutlinedButton(
        onPressed: () => setState(() {
          offsetDays = (offsetDays + val).clamp(0, 100);
          _updateDateByOffset();
        }),
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  Widget _buildTimeAndDateDisplay() {
    return Column(
      children: [
        ListTile(
          title: const Text("기본 시각"),
          trailing: OutlinedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (time != null)
                setState(() {
                  selectedTime = time;
                  _updateDateByOffset();
                });
            },
            child: Text(
              "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.indigo.shade100),
          ),
          child: Column(
            children: [
              const Text(
                "최종 설정 일시",
                style: TextStyle(fontSize: 10, color: Colors.indigo),
              ),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(currentResultDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarPanel(bool isTodayAlarm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavBtn(
              Icons.today,
              "오늘",
              Colors.red,
              () => setState(() {
                calendarFocusDate = today;
                calendarKey = UniqueKey();
              }),
            ),
            const SizedBox(width: 15),
            _buildNavBtn(
              Icons.notifications_active,
              "알람 예정",
              Colors.indigo,
              tempEnabled
                  ? () => setState(() {
                      calendarFocusDate = currentResultDate;
                      calendarKey = UniqueKey();
                    })
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              primary: Colors.indigo,
            ),
            datePickerTheme: DatePickerThemeData(
              todayBorder: BorderSide(
                color: Colors.red,
                width: isTodayAlarm ? 3.0 : 2.0,
              ),
              todayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) => isTodayAlarm ? Colors.indigo : Colors.red.shade50,
              ),
              todayForegroundColor: WidgetStateProperty.resolveWith(
                (states) => isTodayAlarm ? Colors.white : Colors.red.shade900,
              ),
            ),
          ),
          child: SizedBox(
            height: 330,
            child: CalendarDatePicker(
              key: calendarKey,
              initialDate: calendarFocusDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              currentDate: today,
              onDateChanged: (date) {
                if (tempEnabled)
                  setState(() {
                    currentResultDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    calendarFocusDate = currentResultDate;
                    calendarKey = UniqueKey();
                  });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBtn(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return TextButton.icon(
      icon: Icon(icon, size: 16, color: onTap == null ? Colors.grey : color),
      label: Text(
        label,
        style: TextStyle(
          color: onTap == null ? Colors.grey : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onTap,
    );
  }
}
