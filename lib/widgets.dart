import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Widgets'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                'This is my TEXT CAROUSEL',
              style: GoogleFonts.macondo(),
            ),
            SizedBox(height: 10),

            //==Sizedbox utk display carousel==//
            SizedBox(
              height: 200,
              child: CarouselView(
                  itemExtent: MediaQuery.of(context).size.width * 0.8,
                  shrinkExtent: 150,
                  children: [
                    _buildCarouselItem('Rosetail Betta', Colors.orangeAccent),
                    _buildCarouselItem('Plakat Betta', Colors.green),
                    _buildCarouselItem('Crowntail Betta', Colors.indigo)
                  ],
              ),
            ),

            SizedBox(height: 10),
            Text('This is my IMAGE CAROUSEL'),
            SizedBox(height: 10),

            SizedBox(
              height: 200,
              child: CarouselView(
                itemExtent: MediaQuery.of(context).size.width * 0.8,
                shrinkExtent: 150,
                children: [
                  _buildCarouselImageItem('https://plantedtankmates.com/wp-content/uploads/white-rose-tail-betta-fish.jpg', Colors.deepPurple),
                  _buildCarouselImageItem('https://thailandbettafish.com/cdn/shop/collections/Koi_Candy_Betta_Fish.png?v=1691207624', Colors.cyan),
                  _buildCarouselImageItem('https://thailandbettafish.com/cdn/shop/products/CrowntailBlackVenomBettaFish.png?v=1678541377', Colors.white30)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildCarouselItem(String title, Color color){
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCarouselImageItem(String src, Color color){
    return Container(
      color: color,
      child: Center(
        child: Image.network(src)
      ),
    );
  }
}