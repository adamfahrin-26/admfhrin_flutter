import 'package:flutter/material.dart';
import 'package:jm26_4a/bmi.dart';
import 'package:jm26_4a/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BmiPage()),
              );
            },
            icon: Icon(Icons.hail),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WidgetsPage()),
              );
            },
            icon: Icon(Icons.widgets),
          ),
        ],
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        title: Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF049F27),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Biodata',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),

            Text('Name: Adam Fahrin Bin Abd Halim', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Age: 20', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Course: Diploma in Electronic Engineering (IOT)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Hobby: Writing coding', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
