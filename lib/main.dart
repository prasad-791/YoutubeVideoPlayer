import 'package:flutter/material.dart';
import 'package:youtube_video_player/model/yt_video_model.dart';
import 'package:youtube_video_player/screens/youtube_video_player/yt_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YTVideoPlayer(model: YTVideoModel(urls: ["https://www.youtube.com/watch?v=rDX4f9IN12U","https://www.youtube.com/watch?v=x0ZNQ0YXyfE","https://www.youtube.com/watch?v=W-rHIsDFrzQ"],autoPlay: true,mute: false,isLive: true,isHD: false,enableCaption: false,startAt: 30),),
      // home: MyHomePage(),
    );
  }
}