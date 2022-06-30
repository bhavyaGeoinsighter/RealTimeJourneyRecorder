import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool upload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Settings',style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.purple,
              child: ListTile(
                title: Text("John Doe"),
                leading: CircleAvatar(
                  // backgroundImage:,
                ),
                trailing: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 10.0,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.high_quality),
                    title: Text("Resolution"),
                    trailing:  Icon(Icons.keyboard_arrow_down),
                    onTap: (){

                    },
                  ),
                  SwitchListTile(
                    activeColor: Colors.purple,
                    secondary: const Icon(Icons.lightbulb_outline),
                    contentPadding: const EdgeInsets.all(0),
                    title: Text("Automatic upload"),
                    value: upload,
                    onChanged: (bool value) {
                      setState(() {
                        upload = value;
                      });
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
