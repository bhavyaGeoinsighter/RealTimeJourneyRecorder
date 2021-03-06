import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:untitled/video_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


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
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  late CameraController _cameraController;
  String? data;//not used
  Timer? mytimer; //not used
  StreamSubscription? gpsCurrPosStream;
  int? srtIndex;//not used

  //Folder structure :- csv,video
  String? videoCsvFolderPath;
  String? folderName;
  String? videoFileName;
  String? csvFileName;// unique csv filename
  String? csvPath;
  String? videoPath;

  //api
  String? projectid;
  String? serverIpAddress='http://15.206.73.160:8081/api';
  String? token;


  @override
  void initState() {
    super.initState();
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




// Getting permission for gps, checking for GPS, Getting latitude & longitude
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // LocationSettings locationOptions = const LocationSettings(accuracy: LocationAccuracy.best,distanceFilter: 0);

    LocationSettings locationoptions;
    locationoptions = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      intervalDuration: const Duration(seconds: 1),
      //(Optional) Set foreground notification config to keep the app alive
      //when going to the background

    );

    //Make the csv file and then write while listening for the gps co-ordinates.
    final csvFile =  await _localFile;
    gpsCurrPosStream = Geolocator.getPositionStream(locationSettings: locationoptions).listen((position) async{
      var dt = DateTime.now();
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();
      String currTime = dt.toUtc().toString();
      csvFile.writeAsString('GPS($latitude $longitude),$currTime\n',mode: FileMode.append);
      print('---------------------------GPS($latitude $longitude),$currTime \n');
    });
  }


//Getting the address (Not used now)
  Future<void> GetAddressFromLatLong(Position position) async{
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);
  }


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
        'projectName': "this is my first video project",
        'type': 'video'
      }),
    );
    final body = json.decode(response.body);
    print( '----------------------:::::::::::::::::::::::::-----------'+body['_id'].toString());
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

    print(':::::::::::::::project id :- '+projectid!);
    print('::::::::::::::::::token :- '+token!);

    request.send().then((response) {
      print(':;;;;;;;;;;;;;;statuscode-video    ' + response.statusCode.toString());
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
          print('------------'+e.toString());

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

    // _determinePosition();
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
          ],
        ),
      );
    }
  }


  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.high);
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
      final XFile? vidFile = await _cameraController.stopVideoRecording();
      //move to same folder from cache and delete
      File videoFile = File(vidFile!.path);
      await videoFile.copy(
        '$videoCsvFolderPath/$videoFileName.mp4',
      );
      //yet to add delete from cache

      //
      // mytimer?.cancel();
      setState(() => _isRecording = false);
      await gpsCurrPosStream?.cancel();  //cancelling gps stream once recording gets stop.
      await uploadVideoToServer(vidFile); // upload video to server
      await uploadCsvToServer(csvPath!); // upload csv file to server

      //navigating to preview
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => VideoPage(filePath: file.path),
      // );
      //
      //  Navigator.push(context, route);

    } else {
      // file =  await _localFile;
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      await gettoken();
      await getprojectid();
      setState(() => _isRecording = true);
      //assigning unique file name on every start recording key is pressed.
      setState(() {
        var dt = DateTime.now();
        csvFileName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
        videoFileName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
        folderName = '${dt.day}-${dt.month}-${dt.year},${dt.hour}-${dt.minute}-${dt.second}';
      });
      await _determinePosition(); //start gps current location stream and writing file after we get the position(lat,long)



    }
  }

}