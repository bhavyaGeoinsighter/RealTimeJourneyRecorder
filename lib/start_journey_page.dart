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
            child: Padding(
              padding:const EdgeInsets.only(
                  top: 30, bottom: 0),
              child: Container(
                child: const Text('WELCOME',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800)),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Jourey Name',
                    hintText: ''),
              ),
              Container(
                height: 12,
              ),
              TextField(
                controller: desciption,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Journey Description',
                    hintText: ''),
              ),
              Container(height: 15,),
              
              Container(
                
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () {
                          String nametextToSend = name.text;
                          String desctextToSend = desciption.text;
                          print("$nametextToSend-----------------------------------$desctextToSend");
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
                          }
                        },
                        

                        child: const Text(
                          'Start a Journey',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
