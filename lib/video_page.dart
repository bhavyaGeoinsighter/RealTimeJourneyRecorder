import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
class marker_data{
  late LatLng latLng;
  late double accuracy;
  late double bearing;
  marker_data(LatLng latLng,double accuracy,double bearing){
    this.latLng = latLng;
    this.accuracy = accuracy;
    this.bearing = bearing;
  }
}

class _VideoPageState extends State<VideoPage> {
  late FlickManager flickManager;
  // late FlickCurrentPosition currentPosition;
  late FlickVideoManager videoManager;
  late final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  bool setUpDone = false;
  final Map<String, LatLng> multipleCoord = HashMap(); // Is a HashMap


  LatLng? currentLocation = LatLng(28.6149173, 77.0329372);
  double accuracy = 0.0;
  double bearing = 0.0;
  final Map<String, marker_data> marker_data_objects = HashMap(); // Is a HashMap


  double zoom = 13.5;

  StreamSubscription? time;
  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(File(widget.videoFilePath)),
    );
    // hash();
    polylineCoordinates.clear();
    multipleCoord.clear();
    csvToList();
    setUpDone =true;

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
      print(fields[0][1].toString().split(' '));
      print("---------------------------------------------------------------------" );

      String t1 = fields[0][1];
      DateTime dateTime1 = DateTime.parse(t1);
      List<String> latLong = fields[0][0].toString().split(' ');
      String lat = latLong[0].substring(4);
      String long = latLong[1].substring(0,latLong[1].length-1);
      // print(lat +" ----------------------lat");
      // print((long + " --------------------long"));
      multipleCoord["0"] = LatLng(double.parse(lat), double.parse(long));

      ///////////////////////////////////////
      try {
        marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[0][2],fields[0][5]);
        marker_data_objects["0"] = mdata;

      } catch (e) {
        marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[0][2],0.0);
        marker_data_objects["0"] = mdata;
        // print(s);
      }
      // marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[0][2],0.0);
      // marker_data_objects["0"] = mdata;
      ///////////////////////////////////////

      int totalTime = 0;
      polylineCoordinates.add(LatLng(double.parse(lat), double.parse(long)));

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
          /////////////////////////////////////////////
          try {
            marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[i][2],fields[i][5]);
            marker_data_objects[difference.toString()] = mdata;

          } catch (e, s) {
            marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[i][2],i*4%360);
            marker_data_objects[difference.toString()] = mdata;
            print(s);
          }
          // marker_data mdata = new marker_data(LatLng(double.parse(lat), double.parse(long)), fields[0][2],i*4%360);
          // marker_data_objects[difference.toString()] = mdata;
          /////////////////////////////////////////////
          multipleCoord[difference.toString()] = LatLng(double.parse(lat), double.parse(long));
          polylineCoordinates.add(LatLng(double.parse(lat), double.parse(long)));
          totalTime = difference;
        }
      }

      print(fields[0][5].toString()+"----------------------totalime");
      LatLng? data = multipleCoord["0"];
      for(int i=0;i<totalTime+60;i++){
        if(multipleCoord.containsKey(i.toString())){
          data = multipleCoord[i.toString()];
        }
        else{
          multipleCoord[i.toString()] = data!;
        }

      }


      ////////////////////////////////////////////
      marker_data? marker_data_secs = marker_data_objects["0"];

      for(int i=0;i<totalTime+60;i++){
        if(marker_data_objects.containsKey(i.toString())){
          marker_data_secs = marker_data_objects[i.toString()];
        }
        else{
          marker_data_objects[i.toString()] = marker_data_secs!;
        }

      }

      for(int i=0;i<totalTime;i++){
        if(!multipleCoord.containsKey(i.toString())){
          print("NULL POINT COORDINATE" + "------------------------------------------------- NULL POINT");
        }
      }
      print(multipleCoord);


  }
  void streamTime() async{
    // time = flickManager.flickControlManager.

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
      currentLocation = marker_data_objects[value.position.inSeconds.toString()]?.latLng;
      bearing =( marker_data_objects[value.position.inSeconds.toString()]==null)?bearing:marker_data_objects[value.position.inSeconds.toString()]!.bearing ;
      if(currentLocation!=null){
        animate(currentLocation!,bearing);
      }

      return currentLocation==null? Center(child: Icon(Icons.assistant_navigation,size: 40,),):
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: (currentLocation != null)
              ? currentLocation!
              : LatLng(28.6149173, 77.0329372),
          zoom: zoom,
        ),
        onCameraMove: _cameraMove,
        polylines: {
          Polyline(
            polylineId:  PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          )
        },
        mapType: MapType.satellite,
        markers: {

          Marker(
            markerId: MarkerId("source"),
            position: (currentLocation !=
                null)
                ? currentLocation!
                : LatLng(28.6149173, 77.0329372),
            infoWindow:  InfoWindow(
              title: currentLocation!.latitude.toString()+ ","+ currentLocation!.longitude.toString(),
              snippet: 'Bearing: '+marker_data_objects[value.position.inSeconds.toString()]!.bearing.toString(),
            ),
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },

      );
                },
            ),
        ),

          // Expanded(
          //   child:   currentLocation==null? Center(child: Text("Loading"),):
          //           GoogleMap(
          //             initialCameraPosition: CameraPosition(
          //               target: (currentLocation != null)
          //                   ? currentLocation!
          //                   : LatLng(28.6149173, 77.0329372),
          //               zoom: 13.5,
          //             ),
          //             polylines: {
          //               Polyline(
          //                 polylineId:  PolylineId("route"),
          //                 points: polylineCoordinates,
          //                 color: Colors.blue,
          //                 width: 6,
          //               )
          //             },
          //             markers: {
          //
          //               Marker(
          //                 markerId: MarkerId("source"),
          //                 position: (currentLocation !=
          //                     null)
          //                     ? currentLocation!
          //                     : LatLng(28.6149173, 77.0329372),
          //                 infoWindow:  InfoWindow(
          //                   title: currentLocation!.latitude.toString()+ ","+ currentLocation!.longitude.toString(),
          //                   snippet: '',
          //                 ),
          //               ),
          //             },
          //             onMapCreated: (mapController) {
          //               _controller.complete(mapController);
          //             },
          //
          //           ),
          // ),
      ],
    );
  }

  Future<void> animate(LatLng ll, double bearing) async {
    GoogleMapController gmc = await _controller.future;
    gmc.showMarkerInfoWindow(MarkerId("source"));

    gmc.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: ll,zoom: zoom, bearing : bearing)));
    // gmc.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: ll,zoom: zoom)));
    // setState(() {});
    
  }

  double _cameraMove(CameraPosition position){
    zoom = position.zoom;
    return zoom;
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
