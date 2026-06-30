import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstYear = DateTime.now().year - 10;
    final lastYear = DateTime.now().year + 10;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCalendar(view: CalendarView.month),
    );
  }
}
