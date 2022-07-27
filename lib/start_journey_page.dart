// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
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
import 'maps.dart';

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
      settingsModel sm = settingsModel(resolution: "720p", automatic: false,showMap: true,mapType: 'normal');
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
          Expanded(
            child: Padding(
              padding:const EdgeInsets.only(
                  top: 70, bottom: 0),
              child: Container(
                child: const Text('RAIL INSIGHTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800)),

              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                const Database()));
                      },
                      icon: const Icon(Icons.video_library_outlined,size: 30,),
                    ),

                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        print(settingsBox.length.toString()+"---------------settingbox length");
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                const SettingsScreen()));
                      },
                      icon: const Icon(Icons.settings,size: 30,),
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                const OrderTrackingPage()));
                      },
                      icon: const Icon(Icons.map_sharp,size: 30,),
                    ),

                  ]

              ),
            ),
          ),
          StreamBuilder<LocationData>(
            stream: Location().onLocationChanged,
            builder: (context, location) {
              return Container(
                child: Column(
                  children:  [
                    Text("Location Accuracy:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600), ),
                    (location.data!=null)?
                    Text(location.data!.accuracy!.toStringAsFixed(2)+" m",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),):
                    Container(
                      child: Text(location.data.toString()),
                    ),


                    Text("Satellites:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600), ),
                    (location.data!=null)?
                    Text(location.data!.satelliteNumber!.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),):
                    Container(
                      child: Text(location.data.toString()),
                    ),
                  ],
                ),


              );
            }
          ),
          Container(
            height: 30,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: SingleChildScrollView(
                child: Column(children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                        // border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Journey Name',
                        hintText: ''),
                  ),
                  Container(
                    height: 12,
                  ),
                  TextField(
                    controller: desciption,
                    decoration: const InputDecoration(
                        // border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Journey Description',
                        hintText: ''),
                  ),
                  Container(height: 15,),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () {
                        String nametextToSend = name.text;
                        String desctextToSend = desciption.text;
                        print("$nametextToSend-----------------------------------$desctextToSend");
                        if(nametextToSend.toString().length==0){
                       constants.tokenPopup("Enter a Journey name", context, false);
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
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
