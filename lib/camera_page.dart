import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';
import 'package:untitled/journey_model.dart';
import 'package:untitled/settings_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/uploading_functions.dart';
import 'package:untitled/video_page.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled/view_files.dart';


import 'constants.dart';
import 'main.dart';
// import 'package:location/location.dart' as loc;

//Not needed
class project {
  final int projectName;
  final String type;

  const project({required this.projectName, required this.type});

  factory project.fromJson(Map<String, dynamic> json) {
    return project(
      projectName: json['name'],
      type: json['video'],
    );
  }
}


class CameraPage extends StatefulWidget {
  final String? name;
  final String? description;

  const CameraPage({Key? key, this.name, this.description}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  // final stopwatch = Stopwatch();
  String? data;//not used
  Timer? mytimer; //not used
  // StreamSubscription? gpsCurrPosStream;// Geolocator plugin

  StreamSubscription? gpsLocationStream; //Location plugin used

  int? srtIndex;//not used

  late String? name = "${widget.name}";
  late String? description = "${widget.description}";

  //Folder structure :- csv,video
  String? videoCsvFolderPath;
  String? folderName;
  String? videoFileName;
  String? csvFileName;// unique csv filename
  String? csvPath;
  String? videoPath;
  String? createdOn;

  //api token
  String? token;


  bool isFlashModeOn = true;
  late Box<journeyModel> journeyBox;
  late Box<tokenModel> tokenBox;
  late Box<settingsModel> settingsBox;


  late final Upload upload = Upload();
  late final constantFunctions constants = constantFunctions();
  // String timeString = "00:00:00";
  final ValueNotifier<String> timeString = ValueNotifier<String>("00:00:00");
// add from this line
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;

  bool _isVideoPaused = false;

  void start(){
    stopwatch.start();
    timer = Timer.periodic(Duration(milliseconds: 1), update);
  }

  void update(Timer t){
    if(stopwatch.isRunning){
      // setState(() {
        timeString.value =
            "${(stopwatch.elapsed.inHours % 60).toString().padLeft(2, "0")}:${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0")}" ;
                // (stopwatch.elapsed.inMilliseconds % 1000 / 10).clamp(0, 99).toStringAsFixed(0).padLeft(2, "0");
      // });

    }
  }

  void stop(){
    setState(() {
      timer.cancel();
      stopwatch.stop();
    });

  }

  void reset(){
    timer.cancel();
    stopwatch.reset();
    // setState((){
      timeString.value = "00:00:00";

    // });
    stopwatch.stop();
  }



  @override
  void initState() {
    super.initState();
    journeyBox = Hive.box<journeyModel>(journeyBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    settingsBox = Hive.box<settingsModel>(settingsBoxName);

    setState(() => token = tokenBox.get('token')?.token);
    _initCamera();
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    return directory.path;
  }

//Making a file
  Future<File> get _localFile async {
    final path = await _localPath;
    final String videoCsvDirectory = '$path/$folderName';
    await Directory(videoCsvDirectory).create(recursive: true);
    setState(() => videoCsvFolderPath =videoCsvDirectory );
    setState(() => csvPath ='$videoCsvDirectory/$csvFileName.csv' );
    return File('$videoCsvDirectory/$csvFileName.csv');
  }


  //Not used (Testing purpose forged file)
  Future<File> get _localFile2 async {
    final path = await _localPath;
    // final String videoCsvDirectory = '$path/$folderName';
    // await Directory(videoCsvDirectory).create(recursive: true);
    // setState(() => videoCsvFolderPath =videoCsvDirectory );
    // setState(() => csvPath ='$videoCsvDirectory/$csvFileName.csv' );
    return File('$videoCsvFolderPath/forgedtime.csv');
  }

  // Not used (Testing purpose forged with timer)
  _gpsforged() async {

    // final file = await _localFile2;
    // var dt = DateTime.now();
    // Position position = await Geolocator.getCurrentPosition();
    // String latitude = position.latitude.toString();
    // String longitude = position.longitude.toString();
    // String currTime = dt.toUtc().toString();
    // String accuracy  = position.accuracy.toString();
    // file.writeAsString('GPS($latitude $longitude),$currTime,$accuracy\n',mode: FileMode.append);

  }


//Reading file (Not Needed Now)
  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }


  //Location Plugin
  Location location = new Location();

  _gpsLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    final csvFile =  await _localFile;

    // LocationData locationData;
    // _locationData = await location.getLocation();
    await location.changeSettings(interval: 1000);
    gpsLocationStream = location.onLocationChanged.listen((LocationData currentLocation) {
      var dt = DateTime.now();
      String latitude = currentLocation.latitude.toString();
      String longitude = currentLocation.longitude.toString();
      String currTime = dt.toUtc().toString();
      String accuracy = currentLocation.accuracy.toString();
      String bearing = currentLocation.heading.toString();
      // String? timestamp = position.timestamp?.toUtc().toString();
      String altitude = currentLocation.altitude.toString();
      String speed = currentLocation.speed.toString();
      // String speedAcurracy = position.speedAccuracy.toString();
      String stopwatchTime = stopwatch.elapsed.inSeconds.toString();
      csvFile.writeAsString('GPS($latitude $longitude),$currTime,$accuracy,$speed,$altitude,$bearing,$stopwatchTime\n',mode: FileMode.append);




    });
  }

  _gpsLocationAutomaticPlayPauseVideoStream() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    final csvFile =  await _localFile;

    // LocationData locationData;
    // _locationData = await location.getLocation();
    await location.changeSettings(interval: 1000);
    gpsLocationStream = location.onLocationChanged.listen((LocationData currentLocation) {
      var dt = DateTime.now();
      String latitude = currentLocation.latitude.toString();
      String longitude = currentLocation.longitude.toString();
      String currTime = dt.toUtc().toString();
      String accuracy = currentLocation.accuracy.toString();
      String bearing = currentLocation.heading.toString();
      // String? timestamp = position.timestamp?.toUtc().toString();
      String altitude = currentLocation.altitude.toString();
      String speed = currentLocation.speed.toString();
      // String speedAcurracy = position.speedAccuracy.toString();
      String stopwatchTime = stopwatch.elapsed.inSeconds.toString();

      csvFile.writeAsString(
          'GPS($latitude $longitude),$currTime,$accuracy,$speed,$altitude,$bearing,$stopwatchTime\n',
          mode: FileMode.append);
      if(currentLocation.speed! >= _speedThreshlod()) {
        // csvFile.writeAsString(
        //     'GPS($latitude $longitude),$currTime,$accuracy,$speed,$altitude,$bearing\n',
        //     mode: FileMode.append);
        _cameraController.resumeVideoRecording();
        stopwatch.start();
      }
      else{
        // _isVideoPaused = true;
        _cameraController.pauseVideoRecording();
        stopwatch.stop();
      }




    });


  }


  double _speedThreshlod() {
    if (settingsBox.get('settings')!.speedThreshold == '0.1 m/s') {
      return 0.1;
    }
    else if (settingsBox.get('settings')!.speedThreshold == '0.5 m/s') {
      return 0.5;
    }
    else if (settingsBox.get('settings')!.speedThreshold == '1 m/s') {
      return 1.0;
    }
    else if (settingsBox.get('settings')!.speedThreshold == '2 m/s') {
      return 2.0;
    }
    else if (settingsBox.get('settings')!.speedThreshold == '3 m/s') {
      return 3.0;
    }
    else {
      return 5.0;
    }
  }



//GeoLocator Plugin
// // Getting permission for gps, checking for GPS, Getting latitude & longitude
//   _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing t
//     // he position of the device.
//     LocationSettings locationOptions = const LocationSettings(accuracy: LocationAccuracy.best,distanceFilter: 0);
//
//     // LocationSettings locationoptions;
//     // locationoptions = AndroidSettings(
//     //   accuracy: LocationAccuracy.high,
//     //   distanceFilter: 1,
//     //   //(Optional) Set foreground notification config to keep the app alive
//     //   //when going to the background
//     //
//     // );
//
//     //Make the csv file and then write while listening for the gps co-ordinates.
//     final csvFile =  await _localFile;
//     gpsCurrPosStream = Geolocator.getPositionStream().listen((position) async{
//       var dt = DateTime.now();
//       String latitude = position.latitude.toString();
//       String longitude = position.longitude.toString();
//       String currTime = dt.toUtc().toString();
//       String accuracy = position.accuracy.toString();
//       // String? timestamp = position.timestamp?.toUtc().toString();
//       // String altitude = position.altitude.toString();
//       // String speed = position.speed.toString();
//       // String speedAcurracy = position.speedAccuracy.toString();
//       csvFile.writeAsString('GPS($latitude $longitude),$currTime,$accuracy\n',mode: FileMode.append);
//       // print('---------------------------GPS($latitude $longitude),$currTime \n');
//     });
//   }
// //Getting the address (Not used now)
//   Future<void> GetAddressFromLatLong(Position position) async{
//     List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
//     print(placemark);
//   }


//dispose function
  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


//build page
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),

            StreamBuilder<LocationData>(
                stream: Location().onLocationChanged,
                builder: (context, location) {
                  return Container(
                    height: 200,
                    // color: Colors.red,
                    child: Row(
                      children: [
                        Column(
                          children:  [
                            Text(" Location Accuracy:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10), ),
                            (location.data!=null)?
                            Text(location.data!.accuracy!.toStringAsFixed(2)+" m",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),):
                            Container(
                              child: Text("null"),
                            ),
                            Text(" Location Speed:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10), ),
                            (location.data!=null)?
                            Text(location.data!.speed!.toStringAsFixed(2)+" m/s",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),):
                            Container(
                              child: Text("null"),
                            ),
                            Text(" Location speedAccuracy:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 10), ),
                            (location.data!=null)?
                            Text(location.data!.speedAccuracy!.toString()+" m",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),):
                            Container(
                              child: Text("null"),
                            ),


                          ],
                        ),
                      ],
                    ),


                  );
                }
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Icon(Icons.timer, size: 20, color: Colors.white),
            //     Text(timeString.value,
            //         style: TextStyle(
            //             fontSize: 30,
            //             color: Colors.white
            //         )
            //     )
            //   ],
            // ),

            // Text(stopwatch.elapsed.inSeconds.toString()),

            ValueListenableBuilder<String>(
              builder: (BuildContext context, String value, Widget? child) {
                // This builder will only get called when the _counter
                // is updated.
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.timer, size: 20, color: Colors.white),
                    Text(timeString.value,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                        )
                    )
                  ],
                );
              },
              valueListenable: timeString,
              // The child parameter is most helpful if the child is
              // expensive to build and does not depend on the value from
              // the notifier.
              // child: goodJob,
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor:_isRecording? Colors.white:Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.play_arrow,size: 36,color: _isRecording? Colors.red:Colors.white,),
                onPressed: () { _recordVideo(); stopwatch.isRunning ? stop() : start();
                },
              ),
            ),


            Container(
              // color: Colors.red,
              height: 100,
              width: MediaQuery.of(context).size.width+60,
              child: Row(
                children: [
                  Container(width: MediaQuery.of(context).size.width/2-100,),

                  FloatingActionButton(
                    backgroundColor: Colors.red,child: Icon( isFlashModeOn ? Icons.flash_off : Icons.flash_on ), onPressed: () {
                    _Flash();
                  },
                  ),
                  Container(width: MediaQuery.of(context).size.width/3-30,),
                  (_isRecording)?
                  FloatingActionButton(
                    backgroundColor: Colors.red,child: Icon( _isVideoPaused ? Icons.pause : Icons.play_circle_outline_outlined ), onPressed: () {
                      _videoPause();
                      _isVideoPaused? stopwatch.stop(): stopwatch.start();

                  },
                  ):Container(),
                ],
              ),
            ),


          ],
        ),
      );
    }
  }

  _videoPause(){
    if(_isVideoPaused){
      setState(() =>_isVideoPaused = false);
      _cameraController.resumeVideoRecording();

    }
    else{
      setState(() => _isVideoPaused = true);
      _cameraController.pauseVideoRecording();
    }
  }

  _Flash()  async{
    if(isFlashModeOn){
      _cameraController.setFlashMode(FlashMode.torch);
      setState(() => isFlashModeOn = false);

      // isFlashModeOn = false;
    }
    else{
      _cameraController.setFlashMode(FlashMode.off);
      setState(() => isFlashModeOn = true);
    }
}


_pause() async{
    _cameraController.pauseVideoRecording();
    gpsLocationStream?.pause();
    _pause();
}

_resume() async{
    _cameraController.resumeVideoRecording();
    gpsLocationStream?.resume();
    _resume();
}

  //Not Used
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = _cameraController;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _cameraController = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = _cameraController.value.isInitialized;
      });
    }
  }

  ResolutionPreset resolution(){
    if(settingsBox.get('settings')!.resolution.toString()=="240p"){
      return ResolutionPreset.low;
    }
    else if(settingsBox.get('settings')!.resolution.toString()=="480p"){
      return ResolutionPreset.medium;
    }
    else if(settingsBox.get('settings')!.resolution.toString()=="720p"){
      return ResolutionPreset.high;
    }else if(settingsBox.get('settings')!.resolution.toString()=="1080p"){
      return ResolutionPreset.veryHigh;
    }else if(settingsBox.get('settings')!.resolution.toString()=="2160p"){
      return ResolutionPreset.ultraHigh;
    }
    return ResolutionPreset.max;
  }

  _initCamera() async {
    //Dynamic Settings to be added with settings
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); //hiding device status bar which is visible on top
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(cameras[0], resolution());
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  //not needed
  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }



  bool _isRecording = false;
  _recordVideo() async {
    if (_isRecording) {
      // stopwatch.stop();
      // stopwatch.isRunning ? stop() : start();
      setState(() => _isRecording = false);
      gpsLocationStream?.cancel();   //cancelling gps stream of Location plugin once recording gets stop.
      final XFile? vidFile = await _cameraController.stopVideoRecording();
      //move to same folder from cache and delete
      File cacheVideoFile = File(vidFile!.path);
      await cacheVideoFile.copy(
        '$videoCsvFolderPath/$videoFileName.mp4',
      );
      print(journeyBox.keys.toString()+'------------keys;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      journeyModel journey = journeyModel(id: "".toString(),csvPath:csvPath.toString(),name:name.toString(),description: description.toString(),videoPath: '$videoCsvFolderPath/$videoFileName.mp4',createdOn: createdOn.toString(),modifiedOn: videoFileName.toString(),isVideoUploaded: false,isCsvUploaded: false, extra: '' );
      // Adding to the database.
      journeyBox.add(journey);
      int keyOfCurrjourney = journeyBox.keyAt(journeyBox.length-1);
      // print(keyOfCurrjourney.toString()+'------------currkey;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
      // XFile newVideoFile = XFile('$videoCsvFolderPath/$videoFileName.mp4');
      //delete from cache
      await cacheVideoFile.delete();
      //
      // await gpsCurrPosStream?.cancel();  //cancelling gps stream of geolocator plugin once recording gets stop.
      // mytimer?.cancel();
      // await getprojectid(journey.name,journey,key),
      // await uploadVideoToServer(newVideoFile); // upload video to server
      // await uploadCsvToServer(csvPath!); // upload csv file to server
      // // navigating to preview
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => Database(),
      // );
      //
      //  Navigator.push(context, route);
      Navigator.pop(context);

      // upload = Upload();
      // try {
      //   final result = await InternetAddress.lookup('example.com');
      //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //     print('connected');
      //     // print('name, path, description ------- '+ journey.name+ '--------'+ journey.videoPath + '-----'+journey.description);
      //

      //check internet connection and manual or automatic from settings database.
      if(await constants.checkInternetConnection() && settingsBox.get('settings')!.automatic) {
        await upload.getprojectid(
            token!, journey.name, journey, keyOfCurrjourney);
        await upload.uploadCsvToServer(
            token!, journey.csvPath, journey, keyOfCurrjourney, journey.id);
        await upload.uploadVideoToServer(
            token!, journey.videoPath, journey, keyOfCurrjourney, journey.id);
      }
      else{
        print("No Internet Connection");
      }
      //   }
      // } on SocketException catch (_) {
      //   // snackbar.snackbar(context, "${journey.name} Upload can't be uinitiated. Please turn on your Internet.", Colors.white);
      //   print('not connected');
      //
      // }
    } else {
      // file =  await _localFile;
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+name.toString()+ ';;;;;;;;;;;'+ description.toString() );
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      // stopwatch.start();
      // stopwatch.isRunning ? stop() : start();
      print(stopwatch.elapsed.inSeconds.toString() + "------------------stopwatch");
      setState(() => _isRecording = true);
      setState(() {
        if(name==null || name?.length==0){
          name = "Welcome";
        }
        var dt = DateTime.now();
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yMMMEd');
        final DateFormat timeformatter = DateFormat('jm');
        final String formatted = "${timeformatter.format(now)} \n${formatter.format(now)} ";
        // print(formatted);
        createdOn = '$formatted';
        csvFileName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
        videoFileName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
        folderName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';

      }); //assigning unique file name on every start recording key is pressed.
      // await _determinePosition(); //start gps current location stream and writing file after we get the position(lat,long) // Geolocator plugin
      // mytimer = await Timer.periodic(Duration(seconds: 1), (Timer t) => _gpsforged());
      (!settingsBox.get('settings')!.autoPlayPause)?await _gpsLocation():await _gpsLocationAutomaticPlayPauseVideoStream(); //Location plugin used
      // await gettoken();
      // await getprojectid();



    }

  }

}