import 'package:flutter/material.dart';

class PizzaMenuPage extends StatefulWidget {
  const PizzaMenuPage({super.key});

  @override
  State<PizzaMenuPage> createState() => _PizzaMenuPageState();
}

class _PizzaMenuPageState extends State<PizzaMenuPage> {

  final List<Map<String, String>> pizzas = [
    {
      'name': 'PYTHON',
      'description': 'A high-level programming language used for automation, data analysis, AI, and IoT applications.',
      'image': 'assets/21.png',
    },
    {
      'name': 'JAVA',
      'description': 'An object-oriented programming language commonly used for Android and enterprise applications.',
      'image': 'assets/22.png'
    },
    {
      'name': 'HTML',
      'description': 'A markup language used to create the structure of web pages.',
      'image': 'assets/23.png'
    },
    {
      'name': 'C++',
      'description': 'A high-performance programming language used for system and application development.',
      'image': 'assets/24.png'
    },
    {
      'name': 'PHPMYADMIN',
      'description': 'A web-based tool used to manage MySQL or MariaDB databases.',
      'image': 'assets/25.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
            'Code Application',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text('🔥.Powering Smart Applications from Code to Database !', textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              Expanded(
                      child: ListView.builder(
                        itemCount: pizzas.length,
                      itemBuilder: (context, index){
                          final pizza = pizzas[index];

                          return Card(
                            color: Color(0xCA7ED5C0),
                            child: ListTile(
                              leading:Image.asset(
                                pizza['image']!,
                                fit: BoxFit.cover,
                              ),
                              title: Text('${pizza['name']} .'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pizza['description']!),
                                  SizedBox(height: 5,),
                                ],
                              ),
                              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right)),
                            ),
                          );
                      }
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
