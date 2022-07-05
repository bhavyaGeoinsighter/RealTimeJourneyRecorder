// import 'dart:js_util/js_util_wasm.dart';

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/journey_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/uploading_functions.dart';
import 'package:untitled/video_page.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:async';


import 'constants.dart';
import 'main.dart';

class Database extends StatefulWidget {
  const Database({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum journeyFilter { ALL, VIDEO_UPLOADED, VIDEO_NOT_UPLOADED, CSV_UPLOADED, CSV_NOT_UPLOADED }

class _MyHomePageState extends State<Database> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  late final Upload upload = Upload();
  late final constantFunctions constants = constantFunctions();

  //Databases
  late Box<journeyModel> journeyBox;
  late Box<tokenModel> tokenBox;

  //api token
  String? token;

  //uploads filters
  journeyFilter filter = journeyFilter.ALL;

  @override
  void initState() {
    // journey: implement initState
    super.initState();
    journeyBox = Hive.box<journeyModel>(journeyBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    setState(() => token = tokenBox.get('token')?.token);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("All Recordings"),
          backgroundColor: Colors.black,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                ///journey : Take action accordingly
                ///
                if (value.compareTo("All") == 0) {
                  setState(() {
                    filter = journeyFilter.ALL;
                  });
                }
                else if (value.compareTo("Video Uploaded") == 0) {
                  setState(() {
                    filter = journeyFilter.VIDEO_UPLOADED;
                  });
                }
                else if (value.compareTo("Video Not Uploaded") == 0) {
                  setState(() {
                    filter = journeyFilter.VIDEO_NOT_UPLOADED;
                  });
                }
                else if (value.compareTo("Csv Uploaded") == 0) {
                  setState(() {
                    filter = journeyFilter.CSV_UPLOADED;
                  });
                }else if (value.compareTo("Csv Not Uploaded") == 0) {
                  setState(() {
                    filter = journeyFilter.CSV_NOT_UPLOADED;
                  });
                }
                // Logout
                else if (value.compareTo("Logout") == 0) {
                  setState(() {
                    // filter = journeyFilter.COMPLETED;
                    tokenModel tm = tokenModel(token: "");
                    tokenBox.put('token', tm);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => LoginDemo()),(Route route) => false);
                    print('token after logout:- ${tokenBox.get('token')?.token}----------------------------------');

                  });
                } else if (value.compareTo("Login") == 0) {
                  setState(() {
                    // filter = journeyFilter.COMPLETED;
                    tokenModel tm = tokenModel(token: "");
                    tokenBox.put('token', tm);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => LoginDemo()),(Route route) => false);
                    print('token after logout:- ${tokenBox.get('token')?.token}----------------------------------');

                  });
                }
                // else {
                //   setState(() {
                //     filter = journeyFilter.INCOMPLETED;
                //   });
                // }
              },
              itemBuilder: (BuildContext context) {
                if(tokenBox.get('token')?.token.toString().length!=0) {
                  return [
                    "All",
                    "Video Uploaded",
                    "Video Not Uploaded",
                    "Csv Uploaded",
                    "Csv Not Uploaded",
                    "Logout"
                  ]
                      .map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                }
                else{
                  return [
                    "All",
                    "Video Uploaded",
                    "Video Not Uploaded",
                    "Csv Uploaded",
                    "Csv Not Uploaded",
                    "Login"
                  ]
                      .map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                }
              },
            )
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: journeyBox.listenable(),
          builder: (context, Box<journeyModel> journeys, _) {
            List<int> keys;

            if (filter == journeyFilter.ALL) {
              keys = journeys.keys.cast<int>().toList();
            }
            else if (filter == journeyFilter.VIDEO_UPLOADED) {
              keys = journeys.keys
                  .cast<int>()
                  .where((key) => journeys.get(key)!.isVideoUploaded)
                  .toList();
            }
            else if (filter == journeyFilter.VIDEO_NOT_UPLOADED) {
              keys = journeys.keys
                  .cast<int>()
                  .where((key) => !journeys.get(key)!.isVideoUploaded)
                  .toList();
            }else if (filter == journeyFilter.CSV_UPLOADED) {
              keys = journeys.keys
                  .cast<int>()
                  .where((key) => journeys.get(key)!.isCsvUploaded)
                  .toList();
            }else if (filter == journeyFilter.CSV_NOT_UPLOADED) {
              keys = journeys.keys
                  .cast<int>()
                  .where((key) => !journeys.get(key)!.isCsvUploaded)
                  .toList();
            }
            else {
              keys = journeys.keys
                  .cast<int>()
                  .where((key) => !journeys.get(key)!.isVideoUploaded)
                  .toList();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final int key = keys[index];
                final journeyModel journey = journeys.get(key)!;
                // print('$key${journey.name};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                return Container(
                  //height: 10,
                  child: Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: UniqueKey(),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // A pane can dismiss the Slidable.
                        dismissible: DismissiblePane(
                            confirmDismiss: () async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text("Are you sure you wish to delete this item?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("DELETE")
                                      ),
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: () {
                          setState(() {
                            // journeyBox.delete(key);
                            print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                            //Deleting both the files
                            journeyBox.deleteAt(index);
                            File videoFile = File(journey.videoPath);
                            videoFile.delete();
                            File csvFile = File(journey.csvPath);
                            csvFile.delete();
                            print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                          });

                          constants.snackbar(context,"${journey.name} deleted", Colors.red);

                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //   backgroundColor: Colors.red,
                          //     content: Text("${journey.name} deleted",)));
                        }),

                        // All actions are defined in the children parameter.
                        children: const [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: null,
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      // The end action pane is the one at the right or the bottom side.

                      child: ExpansionTile(
                          title: Text(
                            journey.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                          subtitle: Text(journey.createdOn,
                              style: const TextStyle(fontSize: 15)),
                          leading: const Icon(Icons.video_call,size: 40,),

                          trailing: Icon(
                            Icons.menu_open_outlined,
                            color: journey.isVideoUploaded && journey.isCsvUploaded
                                ? Colors.green
                                : Colors.red,
                          ),

                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                      journey.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 16),
                                ),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              // buttonHeight: 52.0,
                              // buttonMinWidth: 90.0,
                              children: <Widget>[
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0)),
                                  onPressed: () {
                                    // cardA.currentState?.expand();
                                    final route = MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (_) => VideoPage(filePath:journey.videoPath),
                                    );

                                    Navigator.push(context, route);
                                  },
                                  child: Column(
                                    children: const <Widget>[
                                      Icon(Icons.video_collection),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('Open'),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0)),
                                    onPressed: ((!journey.isVideoUploaded && journey.isCsvUploaded) || (journey.isVideoUploaded && !journey.isCsvUploaded) || (!journey.isVideoUploaded && !journey.isCsvUploaded)) // if token is valid then only button is enabled.
                                        ? () async => {
                                      if( !await constants.checkInternetConnection()){
                                        constants.snackbar(context, "Please check your Internet Connection and try again!", Colors.black),
                                      },
                                      if(tokenBox.get('token')?.token.length==0 && await constants.checkInternetConnection() ){
                                      constants.snackbar(context," Please sign in.", null),
                                      // Scaffold.of(context).showSnackBar(const SnackBar(
                                      //     content: Text(" Please sign in."))),
                                      },
                                          // print('token ----------${tokenBox.get('token')?.token.toString()};;;;;;;;;;;;;;;;;;;;;;;;'),
                                          // print("${key}key;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                          // print("${journey.id} ----- id;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                          // upload = Upload(),
                                          // snackbar = showSnackbar(),

                                      if(await constants.checkInternetConnection()){
                                        if(journey.id.length == 0){
                                          await upload.getprojectid(
                                              token!, journey.name, journey,
                                              key),
                                        },

                                        if(!journey.isCsvUploaded){
                                          print("${journey.id}  ---- ${journey
                                              .name} ------  id of csv;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                          constants.snackbar(context,
                                              "${journey.name} CSV UPLOADING",
                                              null),
                                          // Scaffold.of(context).showSnackBar(SnackBar(
                                          //     content: Text("${journey.name} CSV UPLOADING"))),
                                          await upload.uploadCsvToServer(
                                              token!, journey.csvPath, journey,
                                              key, journey.id).then((
                                              statusCode) =>
                                          {
                                            // print("$statusCode----- statusCode;;;;;;;;;;;;;;"),
                                            constants.snackbar(context,
                                                "${journey.name} CSV UPLOADED",
                                                null),
                                            // Scaffold.of(context).showSnackBar(SnackBar(
                                            //     content: Text("${journey.name} CSV UPLOADED")))
                                          }),
                                        },
                                        if(!journey.isVideoUploaded){
                                          print("${journey.id}  ---- ${journey
                                              .name} ------  id of video;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                          constants.snackbar(context,
                                              "${journey.name} VIDEO UPLOADING",
                                              null),
                                          // Scaffold.of(context).showSnackBar(SnackBar(
                                          // content: Text("${journey.name} VIDEO UPLOADING"))),

                                          await upload.uploadVideoToServer(
                                              token!, journey.videoPath,
                                              journey, key, journey.id).then((
                                              statusCode) =>
                                          {
                                            print(
                                                "$statusCode----- statusCode;;;;;;;;;;;;;;"),
                                            constants.snackbar(context,
                                                "${journey
                                                    .name} VIDEO UPLOADED",
                                                null),
                                            //  Scaffold.of(context).showSnackBar(SnackBar(
                                            // content: Text("${journey.name} VIDEO UPLOADED")))
                                          }),
                                        }
                                      },
                                        // print("${journey.id}  ---- ${journey.name} ------  id of journey;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                    }
                                        : null,

                                  child: Column(
                                    children: const <Widget>[
                                      Icon(Icons.cloud_upload_rounded),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('Upload'),
                                      Text('Video & Csv'),
                                    ],
                                  ),
                                ),
    //                             FlatButton(
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(10.0)),
    //                               // onPressed: () {
    //                               //
    //                               //
    //                               // },
    //                               onPressed: (tokenBox.get('token')?.token.length!=0 && !journey.isCsvUploaded) // if token is valid then only button is enabled.
    //                                   ? () async => {
    //                                 print('token ----------${tokenBox.get('token')?.token.toString()};;;;;;;;;;;;;;;;;;;;;;;;'),
    //                                 print(key.toString() + "key;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
    //                                 if(journey.id.length==0){
    //                                   await getprojectid(journey.name,journey,key)},
    //                                 Scaffold.of(context).showSnackBar(SnackBar(
    //                                     content: Text("${journey.name} CSV UPLOADING"))),
    //                                 await uploadCsvToServer(journey.csvPath,journey,key,journey.id).then((statusCode) => {
    //                                   // print("$statusCode----- statusCode;;;;;;;;;;;;;;"),
    //                                   Scaffold.of(context).showSnackBar(SnackBar(
    //                                       content: Text("${journey.name} CSV UPLOADED")))
    //                                 }),
    //
    // // Scaffold.of(context).showSnackBar(SnackBar(
    // // content: Text("${journey.name} CSV UPLOADED"))),
    //
    //                                 print("${journey.id}  ---- ${journey.name} ------  id of journey;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
    //
    //
    //                               }
    //                                   : null
    //                               ,
    //                               child: Column(
    //                                 children: const <Widget>[
    //                                   Icon(Icons.upload_file),
    //                                   Padding(
    //                                     padding: EdgeInsets.symmetric(
    //                                         vertical: 2.0),
    //                                   ),
    //                                   Text('Upload Csv'),
    //                                 ],
    //                               ),
    //                             ),

                              ],
                            )
                          ])),
                );
              },
              itemCount: keys.length,
            );
          },
        ));
  }
}
