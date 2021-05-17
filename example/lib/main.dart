import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_with_opencv/native_with_opencv.dart';

Directory tempDir;
String get tempPath => '${tempDir.path}/temp.jpg';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getTemporaryDirectory().then((dir) => tempDir = dir);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "title",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isWorking = false;
  bool _isProcessed = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> takeImageAndProcess() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
    if (image == null) {
      return;
    }

    setState(() {
      _isWorking = true;
    });
  }

  void showVersion(BuildContext context) {
    // final scaffoldState = Scaffold.of(context);
    // final snackBar = SnackBar(content: Text('OpenCV version: ${opencvVersion()}'));
    // scaffoldState..removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss)..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Native Cpp OpenCV")
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (_isProcessed && !_isWorking)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 3000, maxHeight: 300),
                    child: Image.file(
                      File(tempPath),
                      alignment: Alignment.center,
                    ),
                  ),
                Builder(
                    builder: (context) {
                      return RaisedButton(
                          child: Text('Show version'),
                          onPressed: () => showVersion(context)
                      );
                    }
                ),
                RaisedButton(
                    child: Text('Process photo'),
                    onPressed: takeImageAndProcess
                ),
                Text('1 + 2 == ${nativeAdd(1, 2)}'),
                Text('1 + 2 == ${hexListToFloat([0x66, 0xE6, 0xF6, 0x42])}')
              ],
            ),
          ),
          if (_isWorking)
            Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.7),
                  child: Center(
                      child: CircularProgressIndicator()
                  ),
                )
            ),
        ],
      ),
    );
  }
}
