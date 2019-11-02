import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  bool isDragging = false;
  Size screenSize;
  bool showBalloon = true;
  double value = 40.0;
  double angleBalloon = 0;

  double currentValue= 40;

  bool swipeRight = false;
  bool swipeLeft = false;
  double opacity = 1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentValue = value;

  }

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      body: new Center(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Positioned(
                top: screenSize.height * .4,
                left: 14,
                child: new AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 600),
                  child: new AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(
                      left: swipeLeft
                          ? ((screenSize.width * .8) * value / 99) + screenSize.width * .025
                          : (screenSize.width * .8) * value / 99,

                    ),
                    width: 50,
                    height: 75,
                    child: RotationTransition(
                      turns: new AlwaysStoppedAnimation(angleBalloon),
                      child: new Stack(
                        children: <Widget>[
                          new SvgPicture.asset(
                            'assets/images/Balloon.svg',
                          ),
                          new Positioned(
                            top: 15,
                            left: value > 9 ? screenSize.width * .03 : screenSize.width * .04,
                            child: new Center(
                              child: new Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              new Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child:  new FlutterSlider(
                  values: [value],
                  max: 99,
                  min: 0,
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBarHeight: 2,
                    activeTrackBar: BoxDecoration(
                      color: Color(0xff6468FA),
                    ),
                  ),
                  handler: FlutterSliderHandler(
                    child: new Center(
                      child: new AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: isDragging ? EdgeInsets.all(1) : EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff6468FA),
                        borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                  handlerHeight: isDragging ? 30 : 20,
                  handlerWidth: isDragging ? 30 : 20,

                  onDragging: (handlerIndex, lowerValue, upperValue) {

                    if(currentValue < lowerValue){

                      angleBalloon = -12/360;
                      swipeRight = true;
                      swipeLeft = false;

                    }else if(currentValue > lowerValue){

                      angleBalloon = 12 / 360;
                      swipeRight = false;
                      swipeLeft = true;

                    }

                    setState(() {
                      value = lowerValue;
                      isDragging = true;
                    });

                    currentValue = lowerValue;
                  },

                  onDragCompleted: (i,o,s){
                    setState(() {
                      isDragging = false;
                      opacity = 0;
                      showBalloon = false;
                      angleBalloon = 0;
                      swipeLeft = false;
                      swipeRight = false;
                    });
                  },

                  onDragStarted: (i,o,s){
                    setState(() {
                       showBalloon = true;
                      isDragging = true;
                      opacity = 1;
                    });
                  },
                  tooltip: FlutterSliderTooltip(
                      disabled: true
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

