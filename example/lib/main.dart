import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pick Image Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Pick Image Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _pickImage() async{
    List<ImageEntity> imgList = await PhotoPicker.pickImage(
      context: context,
      themeColor: Colors.green,
      padding: 5.0,
      dividerColor: Colors.deepOrange,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
    );

    print("imgList = $imgList");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'pickImage',
        child: new Icon(Icons.add),
      ),
    );
  }

}
