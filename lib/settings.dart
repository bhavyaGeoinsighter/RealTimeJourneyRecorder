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
  late String _chosenValue;
  late bool isSkipped = tokenBox.get('token')?.token.toString().length==0;


  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box<settingsModel>(settingsBoxName);
    tokenBox = Hive.box<tokenModel>(tokenBoxName);
    autoupload = settingsBox.get('settings')!.automatic;
  _chosenValue = settingsBox.get('settings')!.resolution;
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
                          settingsModel sm = settingsModel(resolution: value.toString(), automatic: settingsBox.get('settings')!.automatic);
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
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: true);
                            settingsBox.put('settings', sm);
                            print("automatic --------------------- " + settingsBox.get('settings')!.automatic.toString());
                            upload.autoUpload();

                          }
                          else{
                            settingsModel sm = settingsModel(resolution: settingsBox.get('settings')!.resolution, automatic: false);
                            settingsBox.put('settings', sm);
                            print("automatic --------------------- " + settingsBox.get('settings')!.automatic.toString());

                          }
                        });
                      },


                    ),
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.high_quality),
                  //   title: Text("Resolution"),
                  //   trailing:  Icon(Icons.keyboard_arrow_down),
                  //   onTap: (){
                  //
                  //   },
                  // ),
                ],
              ),


            )

          ],
          
          
        ),
        
        
        
      ),

    );
  }
}
