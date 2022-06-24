// @dart=2.9
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/camera_page.dart';
import 'package:untitled/todo_model.dart';
import 'package:untitled/view_files.dart';
const String todoBoxName = "todo3";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(todoBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.pink,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                SecondScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/train.jpg'), fit: BoxFit.cover,opacity: 0.9),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Container(
                child: const Text(
                  'RealTime - JourneyRecorder',

                  style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.w800),

                ),
              )
            ],
            )
        )
    );
  }
}
class SecondScreen extends StatelessWidget {


  TextEditingController name = TextEditingController();
  TextEditingController desciption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/train1.jpg'), fit: BoxFit.cover,opacity: 0.9),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          Expanded(
            child: Center(
              child: Container(
                child: const Text(
                  'Rail Insighter',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.w800)

                )
                ,

              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Column(children: [
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    controller: desciption,
                    // obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row( children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              String nametextToSend = name.text;
                              String desctextToSend = desciption.text;


                              Navigator.push(context,CupertinoPageRoute(builder: (context) =>  CameraPage(name: nametextToSend, description: desctextToSend,)));
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                        const Text(
                          'Start a Journey',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight:FontWeight.w600,
                          ),
                        ),

                      ],
                    ),
                  ),

                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {


                              Navigator.push(context,CupertinoPageRoute(builder: (context) => const Database()));
                            },
                            icon: const Icon(Icons.video_library_outlined),
                          ),
                        ),
                        const Text(
                          'View Recordings',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.pushNamed(context, 'register');
                        //   },
                        //   child: const Text(
                        //     '',//sign up
                        //     style: TextStyle(
                        //       decoration: TextDecoration.underline,
                        //       fontSize: 18,
                        //       color: Color(0xff4c505b),
                        //     ),
                        //   ),
                        // ),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: const Text(
                        //     '',//forgot password
                        //     style: TextStyle(
                        //       decoration: TextDecoration.underline,
                        //       fontSize: 18,
                        //       color: Color(0xff4c505b),
                        //     ),
                        //   ),
                        // ),
                      ]),
                  ]),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

