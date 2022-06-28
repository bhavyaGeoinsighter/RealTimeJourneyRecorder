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
import 'package:untitled/todo_model.dart';
import 'package:untitled/video_page.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


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

  //api
  String? projectid;
  String? serverIpAddress='http://15.206.73.160:8081/api';
  String? token;


  bool isFlashModeOn = true;
  late Box<TodoModel> todoBox;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
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

    final file = await _localFile2;
    var dt = DateTime.now();
    Position position = await Geolocator.getCurrentPosition();
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    String currTime = dt.toUtc().toString();
    String accuracy  = position.accuracy.toString();
    file.writeAsString('GPS($latitude $longitude),$currTime,$accuracy\n',mode: FileMode.append);

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
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    final csvFile =  await _localFile;

    LocationData locationData;
    // _locationData = await location.getLocation();
    await location.changeSettings(interval: 0);
    gpsLocationStream = location.onLocationChanged().listen((LocationData currentLocation) {
      var dt = DateTime.now();
      String latitude = currentLocation.latitude.toString();
      String longitude = currentLocation.longitude.toString();
      String currTime = dt.toUtc().toString();
      String accuracy = currentLocation.accuracy.toString();
      // String? timestamp = position.timestamp?.toUtc().toString();
      // String altitude = position.altitude.toString();
      // String speed = position.speed.toString();
      // String speedAcurracy = position.speedAccuracy.toString();
      csvFile.writeAsString('GPS($latitude $longitude),$currTime,$accuracy\n',mode: FileMode.append);




    });
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


  //Get token (API call :- 1)
  Future<dynamic> gettoken() async {
    final response = await http.post(
      Uri.parse('$serverIpAddress/getJwtToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );
    final body = json.decode(response.body);
    // setState(() =>
    // projectid = body['data']['_id'].toString() //ProjectId
    // );
    // print('--------------------------------------'+ projectid.toString());
    // print('--------------------------------------'+ body.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('--------------------------------------token:'+ body['data']['token'].toString());
      setState(() => token = body['data']['token']);

      // token = body['data']['token'];

      return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }


  //Get Project Id (API call :- 2)
  Future<project> getprojectid() async {
    final response = await http.post(
      Uri.parse('$serverIpAddress/projectCreate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'projectName': name.toString(),
        'type': 'video'
      }),
    );
    final body = json.decode(response.body);
    // print( '----------------------:::::::::::::::::::::::::-----------'+body['_id'].toString());
    // setState(() => projectid = body['_id']);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      setState(() => projectid = body['_id']);

      return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create project.');
    }
  }



  // upload video to server (API call:- 3)
  uploadVideoToServer(XFile videoPath) async {
    // String pi = projectid!;
    Map<String, String> headers = { 'Authorization': 'Bearer $token','projectid':projectid!};
    var request =  http.MultipartRequest("POST", Uri.parse('$serverIpAddress/upload/videoForFlutterApp'),);
    request.headers.addAll(headers);
    // int filenameSize = datetime.toString().length - 4; // filename: datetime.mp4 (removing .csv from datetime text here)
    request.files.add(await http.MultipartFile.fromPath('video', videoPath.path,filename: '$projectid' + '_video.mp4',contentType: MediaType('video', 'mp4')));

    // print(':::::::::::::::project id :- '+projectid!);
    // print('::::::::::::::::::token :- '+token!);

    request.send().then((response) {
      // print(':;;;;;;;;;;;;;;statuscode-video    ' + response.statusCode.toString());
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
          // print('------------'+e.toString());

        }
      });
    });
  }


  //Upload csv file to server (API call :- 4)
  uploadCsvToServer(String Csvpath) async {
    Map<String, String> headers = { 'Authorization': 'Bearer $token','projectid':projectid!};
    var request =  http.MultipartRequest("POST", Uri.parse('$serverIpAddress/upload/csvForConversionToSrt'),);
    request.headers.addAll(headers);
    // int filenameSize = datetime.toString().length - 4; // filename: datetime.mp4 (removing .csv from datetime text here)
    request.files.add(await http.MultipartFile.fromPath('csv', Csvpath,filename: '$projectid' + 'new.csv',contentType: MediaType('application', 'vnd.ms-excel')));
    request.send().then((response) {
      print(':;;;;;;;;;;;;;;;;;statuscode-csv    ' + response.statusCode.toString());
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
          print('-------------------------------'+e.toString());

        }
      });
    });
  }



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
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
            Padding(padding: const EdgeInsets.all(100),
            child : FloatingActionButton(
              backgroundColor: Colors.red,child: Icon( isFlashModeOn ? Icons.flash_off : Icons.flash_on ), onPressed: () {
                _Flash();
                },
            ),
            ),


          ],
        ),
      );
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





  _initCamera() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); //hiding device status bar which is visible on top
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
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
      setState(() => _isRecording = false);
      final XFile? vidFile = await _cameraController.stopVideoRecording();
      //move to same folder from cache and delete
      File cacheVideoFile = File(vidFile!.path);
      await cacheVideoFile.copy(
        '$videoCsvFolderPath/$videoFileName.mp4',
      );
      TodoModel todo = TodoModel(id: 1.toString(),csvPath:csvPath.toString(),name:name.toString(),description: description.toString(),videoPath: '$videoCsvFolderPath/$videoFileName.mp4',createdOn: createdOn.toString(),modifiedOn: videoFileName.toString(),isVideoUploaded: false,isCsvUploaded: false, extra: '' );
      // Adding to the database.
      todoBox.add(todo);
      //
      XFile newVideoFile = XFile('$videoCsvFolderPath/$videoFileName.mp4');

      //delete from cache
      await cacheVideoFile.delete();
      //
      // await gpsCurrPosStream?.cancel();  //cancelling gps stream once recording gets stop.
      gpsLocationStream?.cancel();
      // mytimer?.cancel();
      // await uploadVideoToServer(newVideoFile); // upload video to server
      // await uploadCsvToServer(csvPath!); // upload csv file to server

      //navigating to preview
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => VideoPage(filePath: file.path),
      // );
      //
      //  Navigator.push(context, route);
      Navigator.pop(context);

    } else {
      // file =  await _localFile;
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+name.toString()+ ';;;;;;;;;;;'+ description.toString() );
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
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
        csvFileName = '$formatted,${dt.hour}-${dt.minute}-${dt.second}';
        videoFileName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
        folderName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
      }); //assigning unique file name on every start recording key is pressed.
      // await _determinePosition(); //start gps current location stream and writing file after we get the position(lat,long) // Geolocator plugin
      // mytimer = await Timer.periodic(Duration(seconds: 1), (Timer t) => _gpsforged());
      await _gpsLocation(); //Location plugin used
      // await gettoken();
      // await getprojectid();



    }

  }

}