import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  int _currentPageIndex = 0;

  // Status penyiraman tanaman
  final Map<DateTime, List<bool>> _wateringStatus = {};

  @override
  void initState() {
    super.initState();
    _initializeWateringStatus();
  }

  void _initializeWateringStatus() {
    // Contoh inisialisasi status penyiraman untuk bulan ini
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );

    for (int i = 1; i <= daysInMonth; i++) {
      _wateringStatus[DateTime(_focusedDay.year, _focusedDay.month, i)] = [
        false,
        false,
        false
      ]; // Tiga tanaman, semua belum disiram
    }
  }

  void _toggleWateringStatus(DateTime date, int index) {
    setState(() {
      _wateringStatus[date]![index] = !_wateringStatus[date]![index];
    });
  }

  void _showWateringSheet(BuildContext context, DateTime selectedDate) {
    final List<bool> status = _wateringStatus[selectedDate]!;
    final List<String> plantNames = ["Plant 1", "Plant 2", "Plant 3"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Watering Status - ${DateFormat('EEE, MMM d').format(selectedDate)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: status.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      status[index]
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: status[index] ? Colors.green : Colors.grey,
                    ),
                    title: Text(plantNames[index]),
                    trailing: IconButton(
                      icon: Icon(
                        status[index] ? Icons.check : Icons.close,
                        color: status[index] ? Colors.green : Colors.red,
                      ),
                      onPressed: () {
                        _toggleWateringStatus(selectedDate, index);
                        Navigator.pop(context); // Tutup pop-up setelah update
                        _showWateringSheet(context, selectedDate); // Refresh
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Daftar hari dalam bulan
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final List<DateTime> days = List.generate(
      daysInMonth,
      (index) => DateTime(_focusedDay.year, _focusedDay.month, index + 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Calendar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isToday = day.day == DateTime.now().day &&
                day.month == DateTime.now().month &&
                day.year == DateTime.now().year;

            return GestureDetector(
              onTap: () {
                _showWateringSheet(context, day);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color:
                        isToday ? const Color(0xFF10B998) : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${day.day}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _wateringStatus[day]!.contains(true)
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _wateringStatus[day]!.contains(true)
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
