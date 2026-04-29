import 'package:flutter/material.dart';

class TextfieldPage extends StatefulWidget {
  const TextfieldPage({super.key});

  @override
  State<TextfieldPage> createState() => _State();
}

class _State extends State<TextfieldPage> {

  var nameController = TextEditingController();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Text Field Exercise'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text('Please Insert Your Details'),
            SizedBox(height: 10,),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Your Name'
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Class',
                  hintText: 'Enter Your Class'
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'Student Number',
                  hintText: 'Enter Your Student Number'
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter Your Phone Number'
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              setState(() {
                _name = nameController.text;
              });
            }, child: Text('Submit')),
            SizedBox(height: 50),
            Text('My name is ${_name}')
          ],
        ),
      ),
    );
  }
}
