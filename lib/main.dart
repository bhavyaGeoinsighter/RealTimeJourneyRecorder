// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/camera_page.dart';
import 'package:untitled/start_journey_page.dart';
import 'package:untitled/todo_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/view_files.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:async';


const String todoBoxName = "todo3";
const String tokenBoxName = "token";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(tokenModelAdapter());

  await Hive.openBox<TodoModel>(todoBoxName);
  await Hive.openBox<tokenModel>(tokenBoxName);

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
      home: LoginDemo(),

    );
  }
}

// Splash Screen (Not needed)

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key key,  this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//

// class _MyHomePageState extends State<MyHomePage> {
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3),
//             ()=>Navigator.pushReplacement(context,
//             MaterialPageRoute(builder:
//                 (context) =>
//                 LoginDemo()
//             )
//         )
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/train.jpg'), fit: BoxFit.cover,opacity: 0.9),
//         ),
//         child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(children: [
//               Container(
//                 child: const Text(
//                   'RealTime - JourneyRecorder',
//
//                   style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.w800),
//
//                 ),
//               )
//             ],
//             )
//         )
//     );
//   }
// }
//
//



class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {

  Box<tokenModel> tokenBox;
  String serverIpAddress='http://15.206.73.160:8081/api';
  String token;

  @override
  void initState() {
    super.initState();
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    // print('token at login page:- '+tokenBox.get(0).token.toString()+'----------------------------------');
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
      tokenModel tm = tokenModel(token: token);
      tokenBox.put('token', tm);
      // token = body['data']['token'];

      // return project.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/earth.jpg')),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  gettoken();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => startJourneyScreen()));
                },

                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),

            SizedBox(
              height: 130,
            ),
            FlatButton(
              onPressed: (){
                //TODO skip
                print('token at login page:- '+tokenBox.get('token').token.toString()+'----------------------------------');

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => startJourneyScreen()));
              },
              child: const Text(
                'skip',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}

