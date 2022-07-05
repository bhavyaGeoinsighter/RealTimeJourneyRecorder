// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/camera_page.dart';
import 'package:untitled/settings_model.dart';
import 'package:untitled/start_journey_page.dart';
import 'package:untitled/journey_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/uploading_functions.dart';
import 'package:untitled/view_files.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'constants.dart';


const String journeyBoxName = "journey3";
const String tokenBoxName = "token";
const String settingsBoxName = "settings";


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(journeyModelAdapter());
  Hive.registerAdapter(tokenModelAdapter());
  Hive.registerAdapter(settingsModelAdapter());


  await Hive.openBox<journeyModel>(journeyBoxName);
  await Hive.openBox<tokenModel>(tokenBoxName);
  await Hive.openBox<settingsModel>(settingsBoxName);


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

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: SafeArea(child: MyHomePage()),

    );
  }
}

// Splash Screen (Not needed)

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final constantFunctions constants = constantFunctions();
  final Upload upload = Upload();
  Box<tokenModel> tokenBox;


  void initState() {
    super.initState();
    tokenBox = Hive.box<tokenModel>(tokenBoxName);

    Timer(Duration(seconds: 3),
            ()=>
        //     Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder:
        //         (context) =>
        //         LoginDemo()
        //     )
        // )
        loginScreen()
    );
  }
  Future<void> loginScreen() async {
    // print("hello");
    // await upload.checktoken(tokenBox.get('token').token.toString());
    if(await constants.checkInternetConnection()){
      try{
        print("check-----------------");
    await upload.checktoken(tokenBox.get('token').token.toString()).then((value) =>
        {
          // print(value+"-----------------"),
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => startJourneyScreen()), (
            Route route) => false),
        });
        // await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        //         builder: (context) => startJourneyScreen()),(Route route) => false);
      }
      catch(e){
        print(e);

        Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                  LoginDemo()
              )
          );
      }
      // if(await upload.checktoken(tokenBox.get('token').token.toString())){
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      //       builder: (context) => startJourneyScreen()),(Route route) => false);



      // }
    }
    else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              LoginDemo()
          )
      );
    }
    // if(12%2==0) {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder:
    //           (context) =>
    //           LoginDemo()
    //       )
    //   );
    // }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/earth.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: const [
              Center(
                child: Text(
                  'Rail Insighter',
                  style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.w800),

                ),
              )
            ],
            )
        )
    );
  }
}





class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {

  Box<tokenModel> tokenBox;
  String serverIpAddress='http://15.206.73.160:8081/api';
  String token;
  final constantFunctions constants = constantFunctions();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final Upload upload = Upload();


  @override
  void initState() {
    super.initState();
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    // print('token at login page:- '+tokenBox.get(0).token.toString()+'----------------------------------');
  }

  //Get token (API call :- 1)
  Future<dynamic> gettoken(String email,String password) async {
    final response = await http.post(
        Uri.parse('$serverIpAddress/railinsighter/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
    );
    final body = json.decode(response.body);
    // setState(() =>
    // projectid = body['data']['_id'].toString() //ProjectId
    // );
    // print('--------------------------------------'+ projectid.toString());
    print('--------------------------------------'+ body['message']);
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      // print('--------------------------------------token:'+ body['data']['token'].toString());
      // if (mounted) {
      setState(() => token = body['data']['token']);
      tokenModel tm = tokenModel(token: body['data']['token']);
      tokenBox.put('token', tm);
      // token = body['data']['token'];

      // return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // print('--------------------------------------token:'+ body['data']['token'].toString());

      throw Exception(body['message']);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Railinsighter.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,


          body: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:const EdgeInsets.only(
                       top: 30, bottom: 0),
                  child: Container(
                    child: const Text('LOGIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800)),

                  ),
                ),
              ),
               Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),

              Container(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    print(tokenBox.get('token').token+'------------------token');
                    if(!await constants.checkInternetConnection()){
                      // print(email.text+"------------------email");
                      // print(password.text+"----------------password");
                    constants.tokenPopup("conection error", context);
                    }
                    else {
                      try {
                        await gettoken(email.text, password.text);
                        await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => startJourneyScreen()), (
                            Route route) => false);
                      }
                      catch (e) {
                        constants.tokenPopup(e.toString(), context);
                      }
                      // await upload.checktoken(token);
                      // await Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => startJourneyScreen()), (
                      //     Route route) => false);
                    }
                  },

                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              FlatButton(
                onPressed: (){
                  //journey skip
                  print(tokenBox.get('token').token+"----------token before skip");
                  print('token at login page:- ${tokenBox.length}----------------------------------');
                  tokenModel tm = tokenModel(token: "");
                  tokenBox.put('token', tm);
                  print(tokenBox.get('token')?.token.toString().length );

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => startJourneyScreen()),(Route route) => false);
                },
                child: const Text(
                  'skip',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
