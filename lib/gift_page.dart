import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To format the date
import 'package:hedeyati/app_theme.dart';

class GiftPage extends StatefulWidget {
  late int giftIdx;
  GiftPage({super.key, required this.giftIdx});

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  DateTime? selectedDate;
  bool isPledged = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isPledged = true; // Change the pledged state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 70, 0),
            child: Center(child: Text('Gift Details'))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://img.freepik.com/free-photo/3d-render-blue-gift-box-with-ribbon-male-package_107791-16197.jpg?t=st=1729882225~exp=1729885825~hmac=46d8dc7b187a6f6c2f54a83998c82ef659c83dd324e5b903b35c44c7db4bd99c&w=1060',
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Gift Description',
                style: myTheme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'This is a wonderful gift that you can pledge for your loved one.',
                style: myTheme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: \$49.99',
              style: myTheme.textTheme.bodyMedium,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPledged ? Colors.pink.shade100 : Colors.pink, // Lighter pink when pledged
                  foregroundColor: Colors.black, // Black text color
                ),
                onPressed: isPledged ? null : () => _selectDate(context), // Disable button if pledged
                child: Text(
                  isPledged ? 'Pledged on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}' : 'Pledge',
                  style: const TextStyle(color: Colors.black, fontFamily: "Times New Roman"), // Ensure text is black for contrast
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}
