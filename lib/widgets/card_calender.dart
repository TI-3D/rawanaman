import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key}) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now(); // Tanggal saat ini
  int _currentPageIndex = 0; // Indeks halaman untuk 12 hari per halaman

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _setInitialPageIndex();
  }

  void _setInitialPageIndex() {
    // Menghitung hari dalam bulan yang sedang aktif
    DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final currentDay = _focusedDay.day;

    // Menghitung halaman yang sesuai berdasarkan hari aktif (dengan asumsi 12 hari per halaman)
    final pageIndex = ((currentDay - 1) / 12).floor();
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nama bulan dan tahun
    final monthName = DateFormat.MMMM().format(_focusedDay);
    final year = _focusedDay.year;

    // Daftar hari dalam bulan
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final List<DateTime> days = List.generate(
      daysInMonth,
      (index) => DateTime(_focusedDay.year, _focusedDay.month, index + 1),
    );

    // 12 hari per halaman
    final totalPages = (days.length / 12).ceil();
    final startIndex = _currentPageIndex * 12;
    final endIndex =
        (startIndex + 12 > days.length) ? days.length : startIndex + 12;
    final currentPageDays = days.sublist(startIndex, endIndex);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(30), // Border radius pada container luar
        boxShadow: [
          BoxShadow(
            color: Color(0xff10B982).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(4, 4),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header Kalender
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    final selectedYear = await showDialog<int>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Select Year'),
                        children: List.generate(
                          20, // Rentang tahun (10 tahun)
                          (index) => SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(
                                  context, DateTime.now().year - 10 + index);
                            },
                            child: Text(
                              '${DateTime.now().year - 10 + index}',
                            ),
                          ),
                        ),
                      ),
                    );

                    if (selectedYear != null) {
                      setState(() {
                        _focusedDay = DateTime(
                          selectedYear,
                          _focusedDay.month,
                          1,
                        );
                        _currentPageIndex = 0;
                      });
                    }
                  },
                  // Tahun
                  child: Text(
                    "$year",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final selectedMonth = await showDialog<int>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Select Month'),
                        children: List.generate(
                          _months.length,
                          (index) => SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, index + 1);
                            },
                            child: Text(_months[index]),
                          ),
                        ),
                      ),
                    );

                    if (selectedMonth != null) {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          selectedMonth,
                          1,
                        );
                        _currentPageIndex = 0;
                      });
                    }
                  },
                  // Bulan
                  child: Text(
                    monthName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),

            // Kalender
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: currentPageDays.length,
                itemBuilder: (context, index) {
                  final day = currentPageDays[index];
                  final isToday = day.day == DateTime.now().day &&
                      day.month == DateTime.now().month &&
                      day.year == DateTime.now().year;

                  // Menentukan nama hari
                  final dayName = [
                    "Sun",
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat"
                  ][day.weekday % 7]; // Nama hari berdasarkan index

                  // Logika dummy
                  // Menentukan apakah hari ini penyiraman atau pemupukan
                  final isWateringDay =
                      day.day % 2 == 0; // Contoh logika penyiraman
                  final isFertilizingDay =
                      day.day % 3 == 0; // Contoh logika pemupukan

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay = day;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background tetap putih
                        border: Border.all(
                          color: isToday
                              ? const Color(
                                  0xFF10B998) // Warna border untuk hari ini
                              : (day == _focusedDay
                                  ? Colors
                                      .blueAccent // Warna border untuk hari yang dipilih
                                  : Colors
                                      .transparent), // Tidak ada border untuk hari lainnya
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nama Hari
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // Tanggal
                            Text(
                              "${day.day}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            // Ikon Penyiraman atau Pemupukan
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isWateringDay) ...[
                                  Icon(Icons.water_drop,
                                      color: Colors.blue, size: 15),
                                  const SizedBox(width: 4),
                                ],
                                if (isFertilizingDay)
                                  Icon(Icons.agriculture,
                                      color: Colors.green, size: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tombol Navigasi Halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    if (_currentPageIndex > 0) {
                      setState(() {
                        _currentPageIndex--;
                      });
                    }
                  },
                ),
                Text(
                  "${_currentPageIndex + 1} / $totalPages",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    if (_currentPageIndex < totalPages - 1) {
                      setState(() {
                        _currentPageIndex++;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
