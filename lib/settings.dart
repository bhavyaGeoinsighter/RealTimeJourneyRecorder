import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled/settings_model.dart';
import 'package:untitled/token_model.dart';
import 'package:untitled/uploading_functions.dart';

import 'main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box<settingsModel> settingsBox;
  late final Upload upload = Upload();
  late Box<tokenModel> tokenBox;
  late bool autoupload;
  late bool showMap;
  late bool autoPlayPause;

  late String _chosenValue;
  late String mapType;

  late bool isSkipped = tokenBox.get('token')?.token.toString().length==0;


  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box<settingsModel>(settingsBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    autoupload = settingsBox.get('settings')!.automatic;
  _chosenValue = settingsBox.get('settings')!.resolution;
    showMap = settingsBox.get('settings')!.showMap;
    autoPlayPause =settingsBox.get('settings')!.autoPlayPause;
    mapType = settingsBox.get('settings')!.mapType;

    print(settingsBox.get('settings')!.showMap.toString()+"   ----$showMap------------new shomap");

    isSkipped = tokenBox.get('token')?.token.toString().length==0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        // brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Settings',style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SizedBox(height: 10.0,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.high_quality),
                    title: Text("Resolution"),
                    trailing:  DropdownButton<String>(
                      focusColor:Colors.white,
                      value: _chosenValue,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor:Colors.black,
                      items: <String>[
                        // '144p',
                        '240p',
                        '480p',
                        '720p',
                        '1080p',
                        '2160p',
                        '4k',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style:TextStyle(color:Colors.black),),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _chosenValue = value!;
                          settingsModel sm = settingsModel(resolution: value.toString(), automatic: settingsBox.get('settings')!.automatic,showMap: settingsBox.get('settings')!.showMap,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: settingsBox.get('settings')!.autoPlayPause );
                          settingsBox.put('settings', sm);
                          print(settingsBox.get('settings')!.resolution.toString()+"------------new resolution");
                        });
                      },
                    ),
                    onTap: (){

                    },
                  ),

                  IgnorePointer(
                    ignoring: isSkipped,
                    child: SwitchListTile(
                      tileColor: isSkipped ? Colors.grey[200] : Colors.white,
                      activeColor: Colors.orange,
                      secondary: const Icon(Icons.upload),
                      // contentPadding: const EdgeInsets.only(),
                      title:isSkipped ? Container(
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Automatic upload"),
                            Text("(Please sign in to use)",style:TextStyle(fontSize: 10)),
                          ],
                        ),
                      ): Text("Automatic upload"),
                      value: autoupload,
                      onChanged: (bool value) {
                        setState(() {
                          autoupload = value;
                          print("value --------------------- $value");
                          if(value){
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: true,showMap:settingsBox.get('settings')!.showMap,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: settingsBox.get('settings')!.autoPlayPause );
                            settingsBox.put('settings', sm);
                            print("automatic --------------------- " + settingsBox.get('settings')!.automatic.toString());
                            upload.autoUpload();

                          }
                          else{
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: false,showMap: settingsBox.get('settings')!.showMap,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: settingsBox.get('settings')!.autoPlayPause);
                            settingsBox.put('settings', sm);
                            print("automatic --------------------- " + settingsBox.get('settings')!.automatic.toString());

                          }
                        });
                      },


                    ),
                  ),
                  // CheckboxListTile(
                  //   title: Text("title text"),
                  //   value: showMap,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       showMap = value!;
                  //     });
                  //   },
                  //   controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  // ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text("Show Map"),
                    trailing:  Checkbox(
                      checkColor: Colors.white,
                      // fillColor: MaterialStateProperty.resolveWith(Colors.blue),
                      value: showMap,
                      onChanged: (bool? value) {
                        setState(() {
                          showMap = value!;
                          if(value){
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: settingsBox.get('settings')!.automatic,showMap: true,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: settingsBox.get('settings')!.autoPlayPause);
                            settingsBox.put('settings', sm);
                          }
                          else{
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: settingsBox.get('settings')!.automatic,showMap: false,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: settingsBox.get('settings')!.autoPlayPause);
                            settingsBox.put('settings', sm);
                          }
                          print("value --------------------- $value");
                        });
                      },
                    ),
                    onTap: (){

                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.satellite),
                    title: Text("Map Type"),
                    trailing:  DropdownButton<String>(
                      focusColor:Colors.white,
                      value: mapType,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor:Colors.black,
                      items: <String>[
                        // '144p',
                        'satellite',
                        'normal',
                        'terrain',
                        'hybrid',
                        'none'

                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style:TextStyle(color:Colors.black),),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          mapType = value!;
                          settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: settingsBox.get('settings')!.automatic,showMap: settingsBox.get('settings')!.showMap,mapType: mapType.toString(),autoPlayPause: settingsBox.get('settings')!.autoPlayPause);
                          settingsBox.put('settings', sm);
                          print(settingsBox.get('settings')!.mapType.toString()+"------------new type");
                        });
                      },
                    ),
                    onTap: (){

                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.speed),
                    title: Text("Record only when motion detected"),
                    trailing:  Checkbox(
                      checkColor: Colors.white,
                      // fillColor: MaterialStateProperty.resolveWith(Colors.blue),
                      value: autoPlayPause,
                      onChanged: (bool? value) {
                        setState(() {
                          autoPlayPause = value!;
                          if(value){
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: settingsBox.get('settings')!.automatic,showMap: settingsBox.get('settings')!.showMap,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: true);
                            settingsBox.put('settings', sm);
                          }
                          else{
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: settingsBox.get('settings')!.automatic,showMap: settingsBox.get('settings')!.showMap,mapType:settingsBox.get('settings')!.mapType,autoPlayPause: false);
                            settingsBox.put('settings', sm);
                          }
                          print("value --------------------- $value");
                        });
                      },
                    ),
                    onTap: (){

                    },
                  ),
                ],
              ),


            )

          ],
          
          
        ),
        
        
        
      ),

    );
  }
}
