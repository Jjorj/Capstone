import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saint Augustine Metropolitan Cathedral',
      theme: ThemeData(
        primaryColor: Colors.transparent,
      ),
      home: Cathedral(),
    );
  }
}

class Cathedral extends StatefulWidget {
  @override
  _CathedralState createState() => _CathedralState();
}

class _CathedralState extends State<Cathedral> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  final List<String> carouselImages = [
    "lib/images/27.jpg",
    "lib/images/25.jpg",
    "lib/images/24.jpg",
    "lib/images/36.jpg",
    "lib/images/31.jpg",
    "lib/images/26.jpg",
  ];

  final List<String> boxImages = [
    "lib/images/23.jpg",
    "lib/images/28.jpg",
    "lib/images/29.jpg",
    "lib/images/30.jpg",
    "lib/images/32.jpg",
    "lib/images/33.jpg",
    "lib/images/34.jpg",
    "lib/images/17.jpg",
    "lib/images/35.jpg",
  ];

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      'lib/images/simbahan.mp4', // replace with your video URL
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saint Augustine Metropolitan Cathedral'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                  '                                      The Saint Augustine Cathedral was built in 1624 by Fray Agustin San Pedro who was called El Padre Capitan by the residents here.\n'
                '        In 1778, both the church and convent were burned down. From its ruins, Fray Pedro de Santa Barbara, together with generous Cagayanons, built the new church\nwhich was inagurated in 1780.'
                ' But, it too did not last long as it was gutted in 1831.In 1841, the church was rebuilt using concrete materials. Archbishop James Hayes, SJ, in 1946\n                       rebuilt the Cathedral and the Convent until 1946. It was about this time that the stained glass, given by the New York Sacred Heart chapel, was installed.',
                style: TextStyle(fontFamily: 'Montserrat-Bold.ttf', fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 700.0,
              height: 400.0,
              child: Chewie(controller: _chewieController),
            ),
            SizedBox(height: 25),
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0, 
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.3,
              ),
              items: carouselImages.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(item),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 400, 
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 200, 41),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          _buildDayTimeRow('Monday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Tuesday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Wednesday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Thursday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Friday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Saturday', '8:00 AM - 5:00 PM'),
                          _buildDayTimeRow('Sunday', '8:00 AM - 5:00 PM'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox(boxImages[0]),
                _buildBox(boxImages[1]),
                _buildBox(boxImages[2]),
              ],
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox(boxImages[3]),
                _buildBox(boxImages[4]),
                _buildBox(boxImages[5]),
              ],
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBox(boxImages[6]),
                _buildBox(boxImages[7]),
                _buildBox(boxImages[8]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(String imageUrl) {
    return Container(
      width: 330.0,
      height: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDayTimeRow(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat-Bold.ttf',
            color: Colors.black,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat-Bold.ttf',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
