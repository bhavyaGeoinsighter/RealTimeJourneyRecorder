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
import 'package:untitled/todo_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/video_page.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:async';


import 'main.dart';

class Database extends StatefulWidget {
  const Database({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TodoFilter { ALL, VIDEO_UPLOADED, VIDEO_NOT_UPLOADED, CSV_UPLOADED, CSV_NOT_UPLOADED }

class _MyHomePageState extends State<Database> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  late Box<TodoModel> todoBox;
  late Box<tokenModel> tokenBox;

  //api
  String? projectid;
  String? serverIpAddress='http://15.206.73.160:8081/api';
  String? token;

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    setState(() => token = tokenBox.get('token')?.token);

  }

  //Get Project Id (API call :- 2)
  Future<dynamic> getprojectid(String name, TodoModel todo,int key) async {
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
      setState(() => projectid = body['_id']);
      todo.id = projectid!;
      todoBox.put(key, todo);

      // return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create project.');
    }
  }



  // upload video to server (API call:- 3)
  uploadVideoToServer(String videoPath,TodoModel todo,int key, String id) async {
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
        todo.isVideoUploaded = !todo.isVideoUploaded;
        todoBox.put(key, todo);
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
  uploadCsvToServer(String Csvpath,TodoModel todo,int key, String id) async {
    Map<String, String> headers = { 'Authorization': 'Bearer $token','projectid':id};
    var request =  http.MultipartRequest("POST", Uri.parse('$serverIpAddress/upload/csvForConversionToSrt'),);
    request.headers.addAll(headers);
    // int filenameSize = datetime.toString().length - 4; // filename: datetime.mp4 (removing .csv from datetime text here)
    request.files.add(await http.MultipartFile.fromPath('csv', Csvpath,filename: '$projectid' + 'new.csv',contentType: MediaType('application', 'vnd.ms-excel')));
    request.send().then((response) {
      print(':;;;;;;;;;;;;;;;;;statuscode-csv    ' + response.statusCode.toString());
      if(response.statusCode==200){
        todo.isCsvUploaded = !todo.isCsvUploaded;
        todoBox.put(key, todo);

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
                ///Todo : Take action accordingly
                ///
                if (value.compareTo("All") == 0) {
                  setState(() {
                    filter = TodoFilter.ALL;
                  });
                }
                else if (value.compareTo("Video Uploaded") == 0) {
                  setState(() {
                    filter = TodoFilter.VIDEO_UPLOADED;
                  });
                }
                else if (value.compareTo("Video Not Uploaded") == 0) {
                  setState(() {
                    filter = TodoFilter.VIDEO_NOT_UPLOADED;
                  });
                }
                else if (value.compareTo("Csv Uploaded") == 0) {
                  setState(() {
                    filter = TodoFilter.CSV_UPLOADED;
                  });
                }else if (value.compareTo("Csv Not Uploaded") == 0) {
                  setState(() {
                    filter = TodoFilter.CSV_NOT_UPLOADED;
                  });
                }
                // Logout
                else if (value.compareTo("Logout") == 0) {
                  setState(() {
                    // filter = TodoFilter.COMPLETED;
                    tokenModel tm = tokenModel(token: "");
                    tokenBox.put('token', tm);
                    print('token after logout:- ${tokenBox.get('token')?.token}----------------------------------');

                  });
                }
                // else {
                //   setState(() {
                //     filter = TodoFilter.INCOMPLETED;
                //   });
                // }
              },
              itemBuilder: (BuildContext context) {
                return ["All", "Video Uploaded", "Video Not Uploaded","Csv Uploaded","Csv Not Uploaded", "Logout"]
                    .map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: todoBox.listenable(),
          builder: (context, Box<TodoModel> todos, _) {
            List<int> keys;

            if (filter == TodoFilter.ALL) {
              keys = todos.keys.cast<int>().toList();
            }
            else if (filter == TodoFilter.VIDEO_UPLOADED) {
              keys = todos.keys
                  .cast<int>()
                  .where((key) => todos.get(key)!.isVideoUploaded)
                  .toList();
            }
            else if (filter == TodoFilter.VIDEO_NOT_UPLOADED) {
              keys = todos.keys
                  .cast<int>()
                  .where((key) => !todos.get(key)!.isVideoUploaded)
                  .toList();
            }else if (filter == TodoFilter.CSV_UPLOADED) {
              keys = todos.keys
                  .cast<int>()
                  .where((key) => todos.get(key)!.isCsvUploaded)
                  .toList();
            }else if (filter == TodoFilter.CSV_NOT_UPLOADED) {
              keys = todos.keys
                  .cast<int>()
                  .where((key) => !todos.get(key)!.isCsvUploaded)
                  .toList();
            }
            else {
              keys = todos.keys
                  .cast<int>()
                  .where((key) => !todos.get(key)!.isVideoUploaded)
                  .toList();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final int key = keys[index];
                final TodoModel todo = todos.get(key)!;
                print('$key${todo.name};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
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
                        dismissible: DismissiblePane(onDismissed: () {
                          setState(() {
                            // todoBox.delete(key);
                            print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                            todoBox.deleteAt(index);
                            File videoFile = File(todo.videoPath);
                            videoFile.delete();
                            File csvFile = File(todo.csvPath);
                            csvFile.delete();


                            print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                          });

                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                              content: Text("${todo.name} deleted",)));
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
                            todo.name,
                            style: TextStyle(fontSize: 24),
                          ),
                          subtitle: Text(todo.createdOn,
                              style: TextStyle(fontSize: 15)),
                          leading: Icon(Icons.video_call,size: 40,),

                          trailing: Icon(
                            Icons.menu_open_outlined,
                            color: todo.isVideoUploaded && todo.isCsvUploaded
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
                                      todo.description,
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
                                      builder: (_) => VideoPage(filePath:todo.videoPath),
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
                                    onPressed: (tokenBox.get('token')?.token.length!=0 && !todo.isVideoUploaded) // if token is valid then only button is enabled.
                                        ? () async => {
                                          print('token ----------${tokenBox.get('token')?.token.toString()};;;;;;;;;;;;;;;;;;;;;;;;'),
                                      print("${key}key;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                      if(todo.id.length==0){
                                      await getprojectid(todo.name,todo,key)},
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("${todo.name} VIDEO UPLOADING"))),
                                      await uploadVideoToServer(todo.videoPath,todo,key,todo.id).then((statusCode) => {
                                        print("$statusCode----- statusCode;;;;;;;;;;;;;;"),
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("${todo.name} VIDEO UPLOADED")))
                                      }),
                                      print("${todo.id}  ---- ${todo.name} ------  id of todo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),


                                    }
                                        : null
                                  ,

                                  child: Column(
                                    children: const <Widget>[
                                      Icon(Icons.cloud_upload_rounded),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('Upload Video'),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  // onPressed: () {
                                  //
                                  //
                                  // },
                                  onPressed: (tokenBox.get('token')?.token.length!=0 && !todo.isCsvUploaded) // if token is valid then only button is enabled.
                                      ? () async => {
                                    print('token ----------${tokenBox.get('token')?.token.toString()};;;;;;;;;;;;;;;;;;;;;;;;'),
                                    print(key.toString() + "key;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),
                                    if(todo.id.length==0){
                                      await getprojectid(todo.name,todo,key)},
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("${todo.name} CSV UPLOADING"))),
                                    await uploadCsvToServer(todo.csvPath,todo,key,todo.id).then((statusCode) => {
                                      // print("$statusCode----- statusCode;;;;;;;;;;;;;;"),
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("${todo.name} CSV UPLOADED")))
                                    }),

    // Scaffold.of(context).showSnackBar(SnackBar(
    // content: Text("${todo.name} CSV UPLOADED"))),

                                    print("${todo.id}  ---- ${todo.name} ------  id of todo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"),


                                  }
                                      : null
                                  ,
                                  child: Column(
                                    children: const <Widget>[
                                      Icon(Icons.upload_file),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('Upload Csv'),
                                    ],
                                  ),
                                ),

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
