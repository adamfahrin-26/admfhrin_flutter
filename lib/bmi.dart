import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {

  //==Variable Declare==//

  double height = 1.0;
  TextEditingController weightController = TextEditingController();

  //==Function Declare Here==//

  AlertDialog PopUp(double height, double weight){

    double bmi = weight/(height*height);
    String category = '';

    if(bmi < 18.5){
      category = 'Underweight';
    }
    else if(bmi >= 18.5 && bmi < 25){
      category = 'Normal';
    }
    else if(bmi >= 25 && bmi < 30){
      category = 'Overweight';
    }
    else if(bmi >= 30 && bmi < 35){
      category = 'Obese';
    }
    else if(bmi >= 35){
      category = 'Extremely Obese';
    }

    return AlertDialog(
      title: Text('Your BMI'),
      content: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${bmi.toStringAsFixed(2)}'),
            Text(category)
          ],

        ),
      ),
    );
  }

  //==Scaffold Starts Here==//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network('https://www.shutterstock.com/image-vector/weight-loss-concept-body-mass-260nw-1668874993.jpg'),
              Text('Height (m)'),
              Text('${height.toStringAsFixed(2)} m'),
              Slider(
                  min: 0.00,
                  max: 2.00,
                  value: height,
                  onChanged: (heightValue){
                    setState(() {
                      height = heightValue;
                    });
                  }),

              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'Insert Your Weight Truthfully',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){

                double weight = double.parse(weightController.text);

                showDialog(context: context, builder: (BuildContext context) {
                  return PopUp(height, weight);
                },);
              }, child:
              Text('Calculate', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
