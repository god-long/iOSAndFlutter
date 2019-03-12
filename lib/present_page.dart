import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'second_page.dart';



class PresentPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // 去掉debug
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: PresentPage(title: 'Present Page'),
    );
  }
}

class PresentPage extends StatefulWidget {
  PresentPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PresentPageState createState() => PresentPageState();
}

class PresentPageState extends State<PresentPage> {
  int _counter = 0;
  static const platform = const MethodChannel('qd.flutter.io/qd_present');

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String nativeBackString = 'Not Return';

  Future<void> invokeNativeGetResult() async {
    String backString;
    try {
      // 调用原生方法并传参，以及等待原生返回结果数据
      var result = await platform.invokeMethod(
          'getNativeResult', {"key1": "value1", "key2": "value2"});
      backString = 'Native return $result';
    } on PlatformException catch (e) {
      backString = "Failed to get native return: '${e.message}'.";
    }

    setState(() {
      nativeBackString = backString;
    });
  }

  void dismiss() {
    // 直接调用原生方法
    platform.invokeMethod('dismiss');
  }

  void gotoNativeSecondPage() {
    // 直接调用原生方法
    platform.invokeMethod('presentNativeSecondPage');
  }

  String mediaCall(BuildContext context) {
    var media = MediaQuery.of(context);
    print(media.toString());
    print("设备像素密度:" + media.devicePixelRatio.toString());
    print(media.orientation);
    print("屏幕：" + media.size.toString());
    print('状态栏高度：' + media.padding.top.toString());
    return media.padding.toString();
  }

  Future<dynamic> _handler(MethodCall methodCall) {
    String backNative = "failure";
    if (methodCall.method == "flutterMedia") {
      print("参数：" + methodCall.arguments.toString());
      backNative = mediaCall(this.context);
    }
    // 回传原生结果
    return Future.value(backNative);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // flutter 注册原生监听方法
    platform.setMethodCallHandler(_handler);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              dismiss();
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              nativeBackString,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: dismiss,
              child: Text('Dismiss'),
            ),
            RaisedButton(
              onPressed: gotoNativeSecondPage,
              child: Text('Go to native second page'),
            ),
            RaisedButton(
              onPressed: invokeNativeGetResult,
              child: Text('Invoke Native function get callback result'),
            ),
            RaisedButton(
              child: Text('Go to flutter second page'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SecondPageContent(),
                ));
              },
            ),
            new Card(
              elevation: 4.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(2.0),
              )),
              child: new IconButton(icon: Icon(Icons.add), onPressed: () {}),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
