import 'package:flutter/material.dart';
import 'package:rawanaman/widgets/card_calender.dart';
import 'package:rawanaman/widgets/card_instructions.dart';
import 'package:rawanaman/widgets/header_widget.dart';
import 'package:rawanaman/widgets/recommendations_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAFBF2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: HeaderWidget(
                  onNavigate: (routeName, arguments) {
                    Navigator.pushNamed(
                      context,
                      routeName,
                      arguments: arguments,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Tutorial Scan Tanaman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const CardInstructions(),
              const SizedBox(height: 40),
              const SizedBox(
                height: 450,
                child: CustomCalendar(),
              ),
              const SizedBox(height: 30),
              const RecommendationsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
