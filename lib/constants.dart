import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

const Color PRIMARY_COLOR_1 = Color(0x00ffa500);//orange
const Color PRIMARY_COLOR_2 = Color(0xff4c505b); //Grey Icons
// const Color PRIMARY_COLOR_3 = Color();

// class Logic {
//   Future<String> doSomething() async {
//     print("doing something");
//     return "";
//   }
// }

class constantFunctions {

  //Snackbar
  void snackbar(context,String text,color){
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(text)));
  }

  //CheckInternetConnection
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      // snackbar.snackbar(context, "${journey.name} Upload can't be uinitiated. Please turn on your Internet.", Colors.white);
      print('not connected');
      return false;
    }
    return false;
  }

  Future<bool> popupConfirmDelete(context) async{
    bool delete;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const Text('AlertDialog description'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel')
            ,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    return false;


  }


}