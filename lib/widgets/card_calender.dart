import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  int _currentPageIndex = 0;

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

  final Map<DateTime, bool> _wateringStatus =
      {}; // Untuk menyimpan status penyiraman

  @override
  void initState() {
    super.initState();
    _setInitialPageIndex();
  }

  void _setInitialPageIndex() {
    final currentDay = _focusedDay.day;
    final pageIndex = ((currentDay - 1) / 7).floor();
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  int _getTotalWeeksInMonth(DateTime date) {
    final totalDays = DateUtils.getDaysInMonth(date.year, date.month);
    return (totalDays / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final monthName = DateFormat.MMMM().format(_focusedDay);
    final year = _focusedDay.year;
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final List<DateTime> days = List.generate(
      daysInMonth,
      (index) => DateTime(_focusedDay.year, _focusedDay.month, index + 1),
    );

    final totalPages = (days.length / 7).ceil();
    final startIndex = _currentPageIndex * 7;
    final endIndex =
        (startIndex + 7 > days.length) ? days.length : startIndex + 7;
    final currentPageDays = days.sublist(startIndex, endIndex);

    final totalWeeks = _getTotalWeeksInMonth(_focusedDay);
    final currentWeek = _currentPageIndex + 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 26.0),
        child: Column(
          children: [
            SizedBox(height: isSmallScreen ? 5 : 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final selectedYear = await showDialog<int>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Select Year'),
                        children: List.generate(
                          20,
                          (index) => SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(
                                  context, DateTime.now().year - 10 + index);
                            },
                            child: Text('${DateTime.now().year - 10 + index}'),
                          ),
                        ),
                      ),
                    );

                    if (selectedYear != null) {
                      setState(() {
                        _focusedDay =
                            DateTime(selectedYear, _focusedDay.month, 1);
                        _currentPageIndex = 0;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$year",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FontAwesomeIcons.caretDown,
                        size: 14,
                      )
                    ],
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
                            child: Text(
                              _months[index],
                            ),
                          ),
                        ),
                      ),
                    );

                    if (selectedMonth != null) {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, selectedMonth, 1);
                        _currentPageIndex = 0;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FontAwesomeIcons.caretDown,
                        size: 14,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Week $currentWeek", //ganti
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: currentPageDays.length,
                      itemBuilder: (context, index) {
                        final day = currentPageDays[index];

                        final isToday = day.year == DateTime.now().year &&
                            day.month == DateTime.now().month &&
                            day.day == DateTime.now().day;

                        // Logika apakah hari ini adalah hari penyiraman
                        final isWateringDay = day.day % 2 == 0;
                        final isWatered = _wateringStatus[day] ?? false;

                        return GestureDetector(
                          onTap: () {
                            if (isWateringDay) {
                              setState(() {
                                _focusedDay = day;
                              });
                              _showWateringDialog(context,
                                  day); // Tampilkan pop-up hanya jika hari penyiraman
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: isToday
                                    ? const Color(0xFF10B998)
                                    : (day == _focusedDay
                                        ? Colors.blueAccent
                                        : Colors.transparent),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat.E().format(day),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 15 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${day.day}",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 15 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Ikon Penyiraman
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isWateringDay) ...[
                                        Icon(
                                          isWatered
                                              ? Icons.eco
                                              : Icons.water_drop,
                                          color: isWatered
                                              ? Colors.green
                                              : Colors.blue,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
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
                ],
              ),
            ),
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
                  "Week $currentWeek of $totalWeeks",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15 : 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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

  void _showWateringDialog(BuildContext context, DateTime day) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    // List of plant names that need to be watered
    List<String> plantNames = ['Aloe Vera', 'Cactus', 'Fern', 'Spider Plant'];
    // Ambil status penyiraman tanaman untuk hari tersebut
    Map<String, bool> plantWateringStatus = _plantWateringStatus[day] ??
        {for (var plant in plantNames) plant: false};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int wateredCount = plantWateringStatus.values
                .where((status) => status == true)
                .length;

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Peringatan Menyiram",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 15,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$wateredCount dari ${plantNames.length} tanaman sudah disiram.",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...plantNames.map((plant) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent
                            .shade100, // Warna latar belakang biru muda
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plant,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .green.shade100, // Background hijau muda
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      plantWateringStatus[plant] = true;
                                    });
                                  },
                                  child: const Text(
                                    "Sudah",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .red.shade100, // Background merah muda
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      plantWateringStatus[plant] = false;
                                    });
                                  },
                                  child: const Text(
                                    "Belum",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Simpan status penyiraman ke _plantWateringStatus dan _wateringStatus
                    _updateWateringStatus(day, plantWateringStatus);
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Map<DateTime, Map<String, bool>> _plantWateringStatus = {}; // Per-tanaman
  //Map<DateTime, bool> _wateringStatus = {}; // Status harian

  void _updateWateringStatus(
      DateTime day, Map<String, bool> plantWateringStatus) {
    // Hitung apakah semua tanaman telah disiram
    bool allWatered =
        plantWateringStatus.values.every((status) => status == true);

    setState(() {
      // Simpan status penyiraman tanaman
      _plantWateringStatus[day] = plantWateringStatus;

      // Simpan status harian
      _wateringStatus[day] = allWatered;
    });
  }
}
