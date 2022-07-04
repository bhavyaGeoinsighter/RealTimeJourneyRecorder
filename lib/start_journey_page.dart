import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/camera_page.dart';
import 'package:untitled/journey_model.dart';
import 'package:untitled/settings.dart';
import 'package:untitled/settings_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/uploading_functions.dart';
import 'package:untitled/view_files.dart';

import 'constants.dart';
import 'main.dart';

class startJourneyScreen extends StatefulWidget {
  const startJourneyScreen({Key? key}) : super(key: key);

  @override
  _startJourneyScreen createState() => _startJourneyScreen();
}

class _startJourneyScreen extends State<startJourneyScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController desciption = TextEditingController();
  late Box<journeyModel> journeyBox;
  late Box<settingsModel> settingsBox;
  late Box<tokenModel> tokenBox;

  late final Upload upload = Upload();
  late final constantFunctions constants = constantFunctions();





  @override
  void initState() {
    super.initState();
    journeyBox = Hive.box<journeyModel>(journeyBoxName);
    settingsBox = Hive.box<settingsModel>(settingsBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    // settingsModel sm = settingsModel(resolution: "720p", automatic: true);
    // settingsBox.put("settings", sm);
    // settingsBox.put('settings', )
    print('upoloading--------------------------------------------');

    //autoUpload if Internet is connected and automatic upload is true from settings.
    if(settingsBox.length==0){
      settingsModel sm = settingsModel(resolution: "720p", automatic: true);
      settingsBox.put('settings', sm);
    }
    if(settingsBox.length!=0 && settingsBox.get('settings')!.automatic) {
      print(settingsBox.get('settings')!.automatic.toString()+'-------------------------------------------');
      upload.autoUpload();
    }



    // tokenBox = Hive.box<tokenModel>(tokenBoxName);
    // print('token at login page:- '+tokenBox.get(0).token.toString()+'----------------------------------');
  }






  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/Railinsighter.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          Container(
            height: 50,
          ),
          Expanded(
            child: Container(
              child: const Text('RAIL \n INSIGHTER',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w800)),

            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                child: Column(children: [
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: TextField(
                      // style: const TextStyle(fontSize: 15.0, height: 0.5, color: Colors.black),
                      controller: name,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter your journey Name',
                        hintStyle: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.w500),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 12,
                  ),
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: TextField(
                      controller: desciption,
                      // obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Your journey Description',
                        hintStyle: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(children: [
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
                                  print(nametextToSend.toString()+ "-----------------------------------"+ desctextToSend.toString());
                                  if(nametextToSend.toString().length==0){
                                  showDialog(
                                  context: context,
                                  builder: (context) {
                                  return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                  elevation: 16,
                                  child: Container(
                                  child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                  SizedBox(height: 20),
                                  Center(child: Text('   Please enter your journey name')),
                                  SizedBox(height: 20),
                                  TextButton(
                                  child: Text("OK"),
                                  onPressed: () { Navigator.pop(context);},
                                  ),

                                  // _buildRow('assets/choc.png', 'Name 1', 1000),
                                  // _buildRow('assets/choc.png', 'Name 2', 2000),
                                  // _buildRow('assets/choc.png', 'Name 3', 3000),
                                  // _buildRow('assets/choc.png', 'Name 4', 4000),
                                  // _buildRow('assets/choc.png', 'Name 5', 5000),
                                  // _buildRow('assets/choc.png', 'Name 6', 6000),
                                  ],
                                  ),
                                  ),
                                  );
                                  },
                                  );
                                  }else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                CameraPage(
                                                  name: nametextToSend,
                                                  description: desctextToSend,
                                                )));
                                  }},
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                            const Text(
                              'Start a Journey',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 10,
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
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              const Database()));
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
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  print(settingsBox.length.toString()+"---------------settingbox length");
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                          const SettingsScreen()));
                                },
                                icon: const Icon(Icons.settings),
                              ),
                            ),
                            const Text(
                              'Settings',
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
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
