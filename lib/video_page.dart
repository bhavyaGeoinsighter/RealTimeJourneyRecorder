import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';


class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}
final Map<String, LatLng> multipleCoord = HashMap(); // Is a HashMap

class _VideoPageState extends State<VideoPage> {
  late FlickManager flickManager;
  late FlickCurrentPosition currentPosition;
  late FlickVideoManager videoManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(File(widget.filePath)),
    );
    hash();
  }
void hash(){
    multipleCoord["1"] =LatLng(28.6151421,77.0329023);
    multipleCoord["2"] = LatLng(28.615215,77.03323);
    multipleCoord["3"] = LatLng(28.6066133,77.0354967);
    multipleCoord["4"] = LatLng(28.6050899,77.0345912);
    multipleCoord["5"] =   LatLng(28.6037102,77.0334788);
    multipleCoord["6"] =     LatLng(28.5999185,77.0298561);


}
  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            child: FlickVideoPlayer(
                flickManager: flickManager
            ),
          ),
        ),
        // Expanded(
        //   child: Container(
        //       color: Colors.blue,
        //       child:
        //     Text(flickManager.flickVideoManager!.videoPlayerController!.value.duration.inSeconds.toString()+' secs')
        //   ),
        // ),
          Expanded(
            child: ValueListenableBuilder(
            valueListenable: flickManager.flickVideoManager!.videoPlayerController!,
    builder: (context, VideoPlayerValue value, child) {
    //Do Something with the value.
      print(value.position.inSeconds.toString()+"------------------------------------------------------------------------"
          "");
    // return Text(value.position.toString());
      return GoogleMap(
          initialCameraPosition: const CameraPosition(
          target: LatLng(28.6149173,77.0329372),
          zoom: 13.5,
          ),
          markers: {

    Marker(
    markerId: MarkerId("source"),
    position: (multipleCoord[value.position.inSeconds.toString()]!=null) ? multipleCoord[value.position.inSeconds.toString()]!: LatLng(28.6149173,77.0329372) ,
    infoWindow: InfoWindow(
    title: 'Start Point',
    snippet: '---',
    ),
    ),}
      );
    },
    ),
          ),
      ],
    );
  }
}
