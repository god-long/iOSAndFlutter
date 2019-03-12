import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class SecondPageContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Second Present Page'),
      ),
        body: Center (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text('Second Present Content'),
              new RaisedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ThirdPage(),
                    ),
                  );
                },
                child: Text('Go to Third Page'),
              ),
              new RaisedButton(
                onPressed: (){
                  SystemNavigator.pop();
                },
                child: Text('Close Flutter Page'),
              ),
            ],
          ),
        )
    );
  }
}



class ThirdPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('ThirdPage'),
      ),
      body: new Center(
        child: Text('Third Page Content'),
      ),
    );
  }
}