// import 'package:flutter/material.dart';

// class CustomSwitchButton extends StatefulWidget {
//   @override
//   _CustomSwitchButtonState createState() => _CustomSwitchButtonState();
// }

// class _CustomSwitchButtonState extends State<CustomSwitchButton> {
//   bool _isSwitched = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _isSwitched = !_isSwitched; // Toggle the switch state
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(6),
//         width: MediaQuery.of(context).size.width, // Set width for the button
//         height: 40,
//         decoration: BoxDecoration(
//           color: _isSwitched
//               ? Colors.green
//               : Colors.grey, // Change color based on switch state
//           borderRadius: BorderRadius.circular(10), // Rounded corners
//         ),
//         child: const Row(
//           children: [
//             Card(
//               margin: EdgeInsets.all(2),
//               child: Text('Based on your plant'),
//             ),
//             Card(
//               margin: EdgeInsets.all(2),
//               child: Text('Other Plant'),
//             ),
//           ],
//         ),
//         // alignment: Alignment.center, // Center the text
//         // child: Text(
//         //   _isSwitched ? 'ON' : 'OFF', // Text inside the button
//         //   style: TextStyle(
//         //     color: Colors.white, // Text color
//         //     fontWeight: FontWeight.bold, // Bold text
//         //   ),
//         // ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SlideButton extends StatelessWidget {
  final VoidCallback onPressed0;
  final VoidCallback onPressed1;
  final String selectedMenu;

  const SlideButton(
      {Key? key,
      required this.onPressed0,
      required this.onPressed1,
      required this.selectedMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(122, 191, 165, 0.3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            // Animation
            child: AnimatedContainer(
              margin: EdgeInsets.all(3),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () => onPressed0(),
                child: Text(
                  'Based on Your Plant',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: selectedMenu == '0' ? 4 : 0,
                  shadowColor: Color.fromRGBO(217, 217, 217, 0.3),
                  foregroundColor: selectedMenu == '0'
                      ? Colors.black
                      : Color.fromRGBO(63, 86, 78, 1.0),
                  backgroundColor:
                      selectedMenu == '0' ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () => onPressed1(),
                child: Text(
                  'Common Plant Disease',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: selectedMenu == '1' ? 4 : 0,
                  shadowColor: Color.fromRGBO(217, 217, 217, 0.3),
                  foregroundColor: selectedMenu == '1'
                      ? Colors.black
                      : Color.fromRGBO(63, 86, 78, 1.0),
                  backgroundColor:
                      selectedMenu == '1' ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
