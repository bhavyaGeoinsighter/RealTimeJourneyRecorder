import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert' show utf8;


class VideoPage extends StatefulWidget {
  final String videoFilePath;
  final String csvFilePath;


  const VideoPage({Key? key, required this.videoFilePath,required this.csvFilePath}) : super(key: key);

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
      VideoPlayerController.file(File(widget.videoFilePath)),
    );
    hash();
    csvToList();
  }
void hash(){
    // multipleCoord["1"] =LatLng(28.6151421,77.0329023);
    // multipleCoord["2"] = LatLng(28.615215,77.03323);
    // multipleCoord["3"] = LatLng(28.6066133,77.0354967);
    // multipleCoord["4"] = LatLng(28.6050899,77.0345912);
    // multipleCoord["5"] =   LatLng(28.6037102,77.0334788);
    // multipleCoord["6"] =     LatLng(28.5999185,77.0298561);


}
  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
  csvToList() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    // if (result != null) {
    //   PlatformFile file = result.files.first;
      final input = new File(widget.csvFilePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(eol: '\n'))
          .toList();
      print("---------------------------------------------------------------------" );
      print(fields[0][0].toString().split(' '));
      print("---------------------------------------------------------------------" );
      String t1 = fields[0][1];
      DateTime dateTime1 = DateTime.parse(t1);
      List<String> latLong = fields[0][0].toString().split(' ');
      String lat = latLong[0].substring(4);
      String long = latLong[1].substring(0,latLong[1].length-1);
      print(lat +" ----------------------lat");
      print((long + " --------------------long"));
      multipleCoord["0"] = LatLng(double.parse(lat), double.parse(long));
      int totalTime = 0;

      for(int i =1;i<fields.length;i++){
        if(fields[i].length>=3){
          String t2 = fields[i][1];
            DateTime dateTime2 = DateTime.parse(t2);
            int difference = dateTime1.difference(dateTime2).inSeconds.toInt()*-1;
            String timeInSecs = difference.toString();
          List<String> latLong = fields[i][0].toString().split(' ');
          String lat = latLong[0].substring(4);
          String long = latLong[1].substring(0,latLong[1].length-1);
          print(lat +" ----------------------lat");
          print((long + " --------------------long"));
          multipleCoord[difference.toString()] = LatLng(double.parse(lat), double.parse(long));
          totalTime = difference;
        }
      }

      print(totalTime.toString()+"----------------------totalime");
      LatLng? data = LatLng(0.0, 0.0);
      for(int i=0;i<totalTime;i++){
        if(multipleCoord.containsKey(i.toString())){
          data = multipleCoord[i.toString()];
        }
        else{
          multipleCoord[i.toString()] = data!;
        }

      }

      print(multipleCoord);


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
      print(value.position.inSeconds.toString()+"------------------------------------------------------------------------""");
    // return Text(value.position.toString());
      return GoogleMap(
          initialCameraPosition:  CameraPosition(
          target: (multipleCoord[value.position.inSeconds.toString()]!=null) ? multipleCoord[value.position.inSeconds.toString()]!: LatLng(28.6149173,77.0329372),
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

//
// void main() {
//   var dt = DateTime.now();
//   String s = dt.toUtc().toString();
//   String t1 = "2022-07-12 13:55:41.183634Z";
//   String t2 = "2022-07-12 14:05:03.529326Z";
//
//
//   DateTime dateTime1 = DateTime.parse(t1);
//   DateTime dateTime2 = DateTime.parse(t2);
//
//   int difference = dateTime1.difference(dateTime2).inSeconds.toInt();
//
//
//   print(difference*-1);
//
//
// }
