// import 'dart:js_util/js_util_wasm.dart';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
// import 'package:hivetodoteach/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled/todo_model.dart';
import 'package:untitled/video_page.dart';

import 'main.dart';

class Database extends StatefulWidget {
  const Database({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TodoFilter {ALL, COMPLETED, INCOMPLETED}

class _MyHomePageState extends State<Database> {

  late Box<TodoModel> todoBox;

  // final TextEditingController titleController = TextEditingController();
  // final TextEditingController detailController = TextEditingController();

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Hive Todo"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              ///Todo : Take action accordingly
              ///
              if(value.compareTo("All") == 0){
                setState(() {
                  filter = TodoFilter.ALL;
                });
              }else if (value.compareTo("Compeleted") == 0){
                setState(() {
                  filter = TodoFilter.COMPLETED;
                });
              }else{
                setState(() {
                  filter = TodoFilter.INCOMPLETED;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return ["All", "Compeleted", "Incompleted","Others"].map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          )
        ],
      ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: todoBox.listenable(),

            builder: (context, Box<TodoModel> todos, _){

              List<int> keys;

              if(filter == TodoFilter.ALL){
                keys = todos.keys.cast<int>().toList();
              }else if(filter == TodoFilter.COMPLETED){
                keys = todos.keys.cast<int>().where((key) => todos.get(key)!.isVideoUploaded).toList();
              }else{
                keys = todos.keys.cast<int>().where((key) => !todos.get(key)!.isVideoUploaded).toList();
              }
              print(keys.toString());
              return ListView.separated(
                itemBuilder:(_, index){

                  final int key = keys[index];
                  final TodoModel todo = todos.get(key)!;
                  print(key.toString()+ todo.name.toString()+';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                  return Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: UniqueKey(),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible:
                  DismissiblePane(onDismissed: () {
                    setState(() {
                        // todoBox.delete(key);
                      print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                      todoBox.deleteAt(index);
                        print('${index};;;;;;;;;;;;;;;;;;;;;;;;;;;');
                    });


    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("${todo.name} dismissed")));
                  }),

                  // All actions are defined in the children parameter.
                  children: const [
                  // A SlidableAction can have an icon and/or a label.
                  SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  ),

                  ],
                  ),
                  // The end action pane is the one at the right or the bottom side.



                  child: ListTile(
                    title: Text(todo.videoPath, style: TextStyle(fontSize: 24),),
                    subtitle: Text(todo.createdOn,style: TextStyle(fontSize: 20)),
                    leading: Text("$key"),
                    trailing: Icon(Icons.check, color: todo.isVideoUploaded ? Colors.green : Colors.red,),


                    onTap: (){
                      final route = MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (_) => VideoPage(filePath: todo.videoPath),
                      );

                       Navigator.push(context, route);

                      // showDialog(
                      //     context: context,
                      //     builder: (context) => Dialog(
                      //         child: Container(
                      //           padding: EdgeInsets.all(16),
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: <Widget>[
                      //
                      //               ElevatedButton(
                      //                 child: Text("Mark as completed"),
                      //                 onPressed: () {
                      //                   // TodoModel mTodo = TodoModel(
                      //                   //     title: todo.title,
                      //                   //     detail: todo.detail,
                      //                   //     isCompleted: true
                      //                   // );
                      //
                      //                   // todoBox.put(key, mTodo);
                      //
                      //                   Navigator.pop(context);
                      //                 },
                      //               )
                      //             ],
                      //           ),
                      //         )
                      //     ),
                      // );
                    },
                  )
                  );
                },
                separatorBuilder: (_, index) => Divider(),
                itemCount: keys.length,
                shrinkWrap: true,
              );
            },
          )
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     showDialog(
      //         context: context,
      //         builder: (context) =>Dialog(
      //             child: Container(
      //               padding: EdgeInsets.all(16),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: <Widget>[
      //                   TextField(
      //                     decoration: InputDecoration(hintText: "Title"),
      //                     controller: titleController,
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   TextField(
      //                     decoration: InputDecoration(hintText: "Detail"),
      //                     controller: detailController,
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   FlatButton(
      //                     child: Text("Add Todo"),
      //                     onPressed: () {
      //                       ///Todo : Add Todo in hive
      //                       final String title = titleController.text;
      //                       final String detail = detailController.text;
      //
      //                       TodoModel todo = TodoModel(title: title, detail: detail, isCompleted: false);
      //
      //                       todoBox.add(todo);
      //
      //                       Navigator.pop(context);
      //                     },
      //                   )
      //                 ],
      //               ),
      //             )
      //         )
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    )
    );

  }
}