import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_video_player/model/yt_video_model.dart';

class YTVideoPlayer extends StatefulWidget {

  final YTVideoModel model;
  const YTVideoPlayer({Key? key, required this.model}) : super(key: key);

  @override
  _YTVideoPlayerState createState() => _YTVideoPlayerState();
}

class _YTVideoPlayerState extends State<YTVideoPlayer> {
  late YoutubePlayerController _controller;
  final List<String> _ids = [];
  bool _muted = false;
  bool _isPlayerReady = false;
  late YoutubeMetaData _videoMetaData;

  void runYoutubePlayer() {
    for(int i=0;i<widget.model.urls.length;i++){
      _ids.add(YoutubePlayer.convertUrlToId(widget.model.urls[i])!);
    }
    _controller = YoutubePlayerController(
        initialVideoId: _ids.first,
        flags: YoutubePlayerFlags(
          enableCaption: widget.model.enableCaption,
          isLive: widget.model.isLive,
          autoPlay: widget.model.autoPlay,
          mute: widget.model.mute,
          forceHD: widget.model.isHD,
          startAt: widget.model.startAt,
        ))..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _muted = widget.model.mute;
    // _controller.
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runYoutubePlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _controller.pause();
    super.deactivate();
  }

  Widget buildInfoContainer(var h, var w){
    return Container(
      width: w,
      padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: h*0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _text("Title: ", _videoMetaData.title),
          SizedBox(height: h*0.015,),
          _text("Channel: ", _videoMetaData.author),
          SizedBox(height: h*0.015,),
          _text("Duration: ", _videoMetaData.duration.toString()),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous,color: Colors.white,),
                onPressed: _isPlayerReady
                    ? () => _controller.load(_ids[
                (_ids.indexOf(_controller.metadata.videoId) -
                    1) %
                    _ids.length])
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next,color: Colors.white,),
                onPressed: _isPlayerReady
                    ? () => _controller.load(_ids[
                (_ids.indexOf(_controller.metadata.videoId) +
                    1) %
                    _ids.length])
                    : null,
              ),
              IconButton(
                icon: Icon(_muted ? Icons.volume_off : Icons.volume_up,color: Colors.white,),
                onPressed: _isPlayerReady
                    ? () {
                  _muted
                      ? _controller.unMute()
                      : _controller.mute();
                  setState(() {
                    _muted = !_muted;
                  });
                }
                    : null,
              ),
            ],
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                player,
                buildInfoContainer(h,w)
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
  }
}


