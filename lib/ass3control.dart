import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jm26_4a/ass3data.dart';
import 'package:jm26_4a/ass3login.dart';

class CONTROLPAGE extends StatefulWidget {
  const CONTROLPAGE({super.key});

  @override
  State<CONTROLPAGE> createState() => _CONTROLPAGEState();
}

class _CONTROLPAGEState extends State<CONTROLPAGE> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://assessment3-adam-fahrin-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  bool ledStatus = false;
  bool buzzerStatus = false;
  bool isManualMode = false; // false = Auto, true = Manual

  @override
  void initState() {
    super.initState();
    listenToFirebase();
  }

  void listenToFirebase() {
    dbRef.child('control').onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null && mounted) {
        setState(() {
          isManualMode = data['mode'] == 'MANUAL';
          ledStatus = data['led'] == 'ON';
          buzzerStatus = data['buzzer'] == 'ON';
        });
      }
    });
  }

  Future<void> setMode(bool manual) async {
    await dbRef.child('control/mode').set(manual ? 'MANUAL' : 'AUTO');
  }

  Future<void> setLedStatus(bool value) async {
    await dbRef.child('control/led').set(value ? 'ON' : 'OFF');
  }

  Future<void> setBuzzerStatus(bool value) async {
    await dbRef.child('control/buzzer').set(value ? 'ON' : 'OFF');
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LOGINPAGE(),
      ),
          (route) => false,
    );
  }

  Widget buildControlCard({
    required IconData icon,
    required String title,
    required bool status,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        secondary: CircleAvatar(
          radius: 24,
          backgroundColor: status ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            icon,
            color: status ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          status ? 'ON' : 'OFF',
          style: const TextStyle(fontSize: 16),
        ),
        value: status,
        onChanged: isManualMode ? onChanged : null,
      ),
    );
  }

  Widget buildModeButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: selected ? const Color(0xFF16A34A) : Colors.white,
            foregroundColor: selected ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: selected
                    ? const Color(0xFF16A34A)
                    : Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Actuator Option Control'),
        centerTitle: true,
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DATAPAGE(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Icon(
                Icons.tune,
                size: 70,
                color: Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 6),
              Text(
                isManualMode
                    ? 'Manual mode is active'
                    : 'Auto mode is active',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    buildModeButton(
                      text: 'AUTO',
                      selected: !isManualMode,
                      onTap: () async {
                        await setMode(false);
                      },
                    ),
                    const SizedBox(width: 8),
                    buildModeButton(
                      text: 'MANUAL',
                      selected: isManualMode,
                      onTap: () async {
                        await setMode(true);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!isManualMode)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Auto mode is ON. Manual switch control is disabled.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              buildControlCard(
                icon: Icons.lightbulb,
                title: 'LED Control',
                status: ledStatus,
                onChanged: (value) async {
                  await setLedStatus(value);
                },
              ),
              buildControlCard(
                icon: Icons.notifications_active,
                title: 'Buzzer Control',
                status: buzzerStatus,
                onChanged: (value) async {
                  await setBuzzerStatus(value);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: logoutUser,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}