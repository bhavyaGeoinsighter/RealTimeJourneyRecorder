import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled/journey_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'package:untitled/token_model.dart';
import 'dart:async';

import 'main.dart';


class Upload {
  String? projectid;
  String? serverIpAddress='http://15.206.73.160:8081/api';
  late Box<journeyModel> journeyBox;
  late Box<tokenModel> tokenBox;

  Upload() {
    // journey: implement initState
    // super.initState();
    journeyBox = Hive.box<journeyModel>(journeyBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
  }
  //Get Project Id (API call :- 2)
  Future<dynamic> getprojectid(String token,String name, journeyModel journey,int key) async {
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
    print( '----------------------:::::::::::::::::::::::::-----------'+body['_id'].toString());
    // setState(() => projectid = body['_id']);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      projectid = body['_id'];
      journey.id = projectid!;
      journeyBox.put(key, journey);

      // return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create project.');
    }
  }



  // upload video to server (API call:- 3)
  uploadVideoToServer(String token,String videoPath,journeyModel journey,int key, String id) async {
    // String pi = projectid!;
    Map<String, String> headers = { 'Authorization': 'Bearer $token','projectid':id};
    var request =  http.MultipartRequest("POST", Uri.parse('$serverIpAddress/upload/videoForFlutterApp'),);
    request.headers.addAll(headers);
    // int filenameSize = datetime.toString().length - 4; // filename: datetime.mp4 (removing .csv from datetime text here)
    request.files.add(await http.MultipartFile.fromPath('video', videoPath,filename: '$projectid' + '_video.mp4',contentType: MediaType('video', 'mp4')));

    // print(':::::::::::::::project id :- '+projectid!);
    // print('::::::::::::::::::token :- '+token!);

    return request.send().then((response) {
      print(':;;;;;;;;;;;;;;statuscode-video    ' + response.statusCode.toString());
      if(response.statusCode==200){
        journey.isVideoUploaded = !journey.isVideoUploaded;
        journeyBox.put(key, journey);
      }
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
          // print('------------'+e.toString());

        }
      });
      return response.statusCode;
    });

  }


  //Upload csv file to server (API call :- 4)
  uploadCsvToServer(String token,String Csvpath,journeyModel journey,int key, String id) async {
    Map<String, String> headers = { 'Authorization': 'Bearer $token','projectid':id};
    var request =  http.MultipartRequest("POST", Uri.parse('$serverIpAddress/upload/csvForConversionToSrt'),);
    request.headers.addAll(headers);
    // int filenameSize = datetime.toString().length - 4; // filename: datetime.mp4 (removing .csv from datetime text here)
    request.files.add(await http.MultipartFile.fromPath('csv', Csvpath,filename: '$projectid' + 'new.csv',contentType: MediaType('application', 'vnd.ms-excel')));
    request.send().then((response) {
      print(':;;;;;;;;;;;;;;;;;statuscode-csv    ' + response.statusCode.toString());
      if(response.statusCode==200){
        journey.isCsvUploaded = !journey.isCsvUploaded;
        journeyBox.put(key, journey);

      }
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
          print('-------------------------------'+e.toString());

        }
      });
      return response.statusCode;
    });
  }


}
