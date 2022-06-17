// import 'package:flutter/material.dart';
// import 'package:untitled/camera_page.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CameraPage(),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/camera_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // '/': (context) => HomeRoute(),
        '/second': (context) => const SecondRoute(),
        '/third': (context) => const ThirdRoute(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(title: 'RealTime-Journey-Recorder'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Page'),
          backgroundColor: Colors.green,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Next Page'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  /* Contains the code that helps us
			navigate to the second route. */

                ),
                ElevatedButton(
                  child: const Text('Third page!'),
                  onPressed: () {
                    /* Contains the code that helps us
			navigate to the third route. */
                    Navigator.pushNamed(context, '/third');
                  },
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(onPressed: () { Navigator.pushNamed(context, '/second'); },
            child: const Text('Next'))
    );
  }
}


//second page
class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/third');
          },
          child: const Text('Third page!'),
        ),

      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Home'),
            ),
            ListTile(
              title: const Text('Old Recordings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('New Recordings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}




// Start New Recording Page.
class ThirdRoute extends StatelessWidget {
  const ThirdRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter description',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Back!'),
                onPressed: () {
                  Navigator.pop(context);
                },


              ),
              ElevatedButton(
                child: const Text('Start New Recording!'),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(context,CupertinoPageRoute(builder: (context) => const CameraPage()));
                },
              )
            ],
          )

      ),
    );
  }
}

// child: ElevatedButton(
// child: const Text('Back!'),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
