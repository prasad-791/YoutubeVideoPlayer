class YTVideoModel{
  final List<String> urls;
  final bool autoPlay;
  final bool mute;
  final bool isLive;
  final bool isHD;
  final bool enableCaption;
  final int startAt;


  YTVideoModel({required this.urls,required this.autoPlay,required this.mute,required this.isLive,required this.isHD,
    required this.enableCaption,required this.startAt});

  factory YTVideoModel.fromJson(Map<String,dynamic> json){
    return YTVideoModel(urls: json['urls'], autoPlay: json['autoPlay'], mute: json['mute'], isLive: json['isLive'], isHD: json['isHD'], enableCaption: json['enableCaption'], startAt: json['startAt']);
  }

  Map<String,dynamic> dataToJson(YTVideoModel model){
    return {
      "urls": model.urls,
      "autoPlay": model.autoPlay,
      "mute": model.mute,
      "isLive": model.isLive,
      "isHD": model.isHD,
      "enableCaption": model.enableCaption,
      "startAt": model.startAt,
    };
  }

}