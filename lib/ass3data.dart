import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jm26_4a/ass3control.dart';

class DATAPAGE extends StatefulWidget {
  const DATAPAGE({super.key});

  @override
  State<DATAPAGE> createState() => _DATAPAGEState();
}

class _DATAPAGEState extends State<DATAPAGE> {
  final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://assessment3-adam-fahrin-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  double ultrasonicDistance = 0.0;
  double mq2Value = 0.0;
  double temperature = 0.0;
  double humidity = 0.0;

  bool buzzerStatus = false;
  bool ledStatus = false;

  // 🔥 tambah untuk mode
  String currentMode = "AUTO";

  // 🔥 control popup supaya tak spam
  bool buzzerPopupShown = false;
  bool ledPopupShown = false;

  @override
  void initState() {
    super.initState();
    listenToFirebase();
  }

  // ================= POPUP =================

  void showAlertPopup(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void checkAndShowPopup() {
    // ❌ block popup kalau MANUAL
    if (currentMode == "MANUAL") return;

    // 🔥 dua-dua trigger sekali
    if (buzzerStatus && ledStatus && !buzzerPopupShown && !ledPopupShown) {
      buzzerPopupShown = true;
      ledPopupShown = true;
      showAlertPopup(
        "⚠️ Warning",
        "Gas detected and distance is too close.",
      );
    } else {
      // 🔔 buzzer
      if (buzzerStatus && !buzzerPopupShown) {
        buzzerPopupShown = true;
        showAlertPopup(
          "⚠️ Buzzer Alert",
          "Distance too close.",
        );
      } else if (!buzzerStatus) {
        buzzerPopupShown = false;
      }

      // 💡 LED
      if (ledStatus && !ledPopupShown) {
        ledPopupShown = true;
        showAlertPopup(
          "⚠️ LED Alert",
          "Gas detected.",
        );
      } else if (!ledStatus) {
        ledPopupShown = false;
      }
    }
  }

  // ================= FIREBASE =================

  void listenToFirebase() {
    dbRef.child('sensor').onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          ultrasonicDistance = (data['distance'] as num?)?.toDouble() ?? 0.0;
          mq2Value = (data['gasValue'] as num?)?.toDouble() ?? 0.0;
          temperature = (data['temperature'] as num?)?.toDouble() ?? 0.0;
          humidity = (data['humidity'] as num?)?.toDouble() ?? 0.0;
        });
      }
    });

    dbRef.child('control').onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          buzzerStatus = (data['buzzer'] == 'ON');
          ledStatus = (data['led'] == 'ON');
          currentMode = data['mode'] ?? "AUTO";
        });

        checkAndShowPopup();
      }
    });
  }

  // ================= UI =================

  Widget buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF16A34A), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildSensorBox({
    required IconData icon,
    required String title,
    required String value,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActuatorBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool status,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: status ? Colors.green.shade200 : Colors.red.shade200,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor:
            status ? Colors.green.shade100 : Colors.red.shade100,
            child: Icon(
              icon,
              color: status ? Colors.green : Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: status ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              status ? 'ON' : 'OFF',
              style: TextStyle(
                color: status ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F4),
      appBar: AppBar(
        title: const Text('Sensor & Actuator Monitoring'),
        centerTitle: true,
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.dashboard_customize,
              size: 70,
              color: Color(0xFF16A34A),
            ),
            const SizedBox(height: 10),

            buildSectionTitle('Sensors', Icons.sensors),
            const SizedBox(height: 14),

            buildSensorBox(
              icon: Icons.straighten,
              title: 'Ultrasonic Sensor',
              value: '${ultrasonicDistance.toStringAsFixed(1)} cm',
              iconBg: Colors.blue.shade50,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 14),

            buildSensorBox(
              icon: Icons.warning_amber_rounded,
              title: 'MQ2 Gas Sensor',
              value: mq2Value.toStringAsFixed(0),
              iconBg: Colors.orange.shade50,
              iconColor: Colors.orange,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                buildSmallInfoCard(
                  icon: Icons.thermostat,
                  title: 'Temperature',
                  value: '${temperature.toStringAsFixed(1)} °C',
                  color: Colors.red,
                ),
                const SizedBox(width: 12),
                buildSmallInfoCard(
                  icon: Icons.water_drop,
                  title: 'Humidity',
                  value: '${humidity.toStringAsFixed(1)} %',
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 24),

            buildSectionTitle('Actuators', Icons.settings_remote),
            const SizedBox(height: 14),

            buildActuatorBox(
              icon: Icons.notifications_active,
              title: 'Buzzer Alert',
              subtitle: 'Triggered when distance ≤ 20 cm',
              status: buzzerStatus,
            ),
            const SizedBox(height: 14),

            buildActuatorBox(
              icon: Icons.circle,
              title: 'Red LED Alert',
              subtitle: 'Turns ON when gas is detected',
              status: ledStatus,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tune),
                label: const Text(
                  'Go to Control Page',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CONTROLPAGE(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}