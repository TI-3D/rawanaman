import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Map<DateTime, List<String>> _plantNames = {};

  Future<void> _fetchPlant(List<dynamic> myplantsRef) async {
    for (var plantRef in myplantsRef) {
      DocumentSnapshot plantDoc = await plantRef.get();
      if (plantDoc.exists) {
        DateTime nextSiram = (plantDoc['nextSiram'] as Timestamp).toDate();
        DateTime normalizedNextSiram =
            DateTime(nextSiram.year, nextSiram.month, nextSiram.day);
        String plantName = plantDoc['name'];
        // Store the nextSiram date for the plant
        _plantWateringStatus[normalizedNextSiram] ??= {};
        if (!_plantWateringStatus[normalizedNextSiram]!
            .containsKey(plantDoc.id)) {
          _plantWateringStatus[normalizedNextSiram]![plantDoc.id] = false;
        }

        if (!_plantNames.containsKey(normalizedNextSiram)) {
          _plantNames[normalizedNextSiram] = [];
        }
        if (!_plantNames[normalizedNextSiram]!.contains(plantName)) {
          _plantNames[normalizedNextSiram]!.add(plantName);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((userDoc) {
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            _fetchPlant(userData['myplants']);
          }
        }
      });
    }

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
                        DateTime normalizedDay =
                            DateTime(day.year, day.month, day.day);

                        final isToday = day.year == DateTime.now().year &&
                            day.month == DateTime.now().month &&
                            day.day == DateTime.now().day;

                        // Logika apakah hari ini adalah hari penyiraman
                        final isWateringDay =
                            _plantWateringStatus.containsKey(normalizedDay);
                        final isWatered = _plantWateringStatus[normalizedDay]
                                ?.values
                                .any((status) => status) ??
                            false;

                        return GestureDetector(
                          onTap: () {
                            if (isWateringDay) {
                              setState(() {
                                _focusedDay = day;
                              });
                              _showWateringDialog(context,
                                  normalizedDay); // Tampilkan pop-up hanya jika hari penyiraman
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
    List<String> plantNames = _plantNames[day] ?? [];
    // Ambil status penyiraman tanaman untuk hari tersebut
    Map<String, bool> tempPlantWateringStatus = {};
    for (var plantName in plantNames) {
      tempPlantWateringStatus[plantName] =
          _plantWateringStatus[day]?[plantName] ?? false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int wateredCount =
                tempPlantWateringStatus.values.where((status) => status).length;

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Plant to water today",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 15,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  ...plantNames.asMap().entries.map((entry) {
                    int index = entry.key + 1; // Start numbering from 1
                    String plantName = entry.value;

                    return Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            '$index. $plantName', // Add number before plant name
                            textAlign: TextAlign.left, // Align text to start
                          ),
                          Expanded(child: SizedBox())
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                  child: const Text(
                    "Close",
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
}
