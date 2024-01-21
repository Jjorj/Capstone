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
      title: 'Gaston Park',
      theme: ThemeData(
        primaryColor: Colors.transparent,
      ),
      home: Gaston(),
    );
  }
}

class Gaston extends StatefulWidget {
  @override
  _GastonState createState() => _GastonState();
}

class _GastonState extends State<Gaston> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  final List<String> carouselImages = [
    "lib/images/38.jpg",
    "lib/images/37.jpg",
    "lib/images/39.jpg",
    "lib/images/40.jpg",
    "lib/images/41.jpg",
    "lib/images/42.jpg",
    "lib/images/43.jpg",
    "lib/images/44.jpg",
  ];

  final List<String> boxImages = [
    "lib/images/38.jpg",
    "lib/images/37.jpg",
    "lib/images/39.jpg",
    "lib/images/40.jpg",
    "lib/images/41.jpg",
    "lib/images/42.jpg",
  ];

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      'lib/images/gaston.mp4', // replace with your video URL
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
        title: Text('Gaston Park'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                  '                         Gaston Park -Named after a pre-war Municipal Mayor of Cagayan de Oro, Segundo Gaston, the park is located near the St. Augustine Cathedral\n'
                '            and the Archbishop’s Palace. Gaston Park was the main plaza of Cagayan de Misamis  during  the  Spanish  colonial period. It served as the training ground\n'
                '                             of local patriots during the Philippine-American War. Later it became the site of the Battle of Cagayan de Misamis on April 7, 1900.\n                                                                                     A National Historical Institute marker was placed in the park  in 2000.',
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
                          _buildDayTimeRow('Monday', 'Open 24 hours'),
                          _buildDayTimeRow('Tuesday', 'Open 24 hours'),
                          _buildDayTimeRow('Wednesday', 'Open 24 hours'),
                          _buildDayTimeRow('Thursday', 'Open 24 hours'),
                          _buildDayTimeRow('Friday', 'Open 24 hours'),
                          _buildDayTimeRow('Saturday', 'Open 24 hours'),
                          _buildDayTimeRow('Sunday', 'Open 24 hours'),
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
