// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller }) :

    // Each animation defined here transforms its value during the subset
    // of the controller's duration defined by the animation's interval.
    // For example the opacity animation transforms its value during
    // the first 10% of the controller's duration.
    //
    // Most of the Intervals cause the animations' transforms to be
    // "staggered", i.e. to start one after another.

    opacity = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.0, 0.100,
          curve: Curves.ease,
        ),
      ),
    ),

    width = new Tween<double>(
      begin: 50.0,
      end: 150.0,
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.125, 0.250,
          curve: Curves.ease,
        ),
      ),
    ),

    height = new Tween<double>(
      begin: 50.0,
      end: 150.0
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.250, 0.375,
          curve: Curves.ease,
        ),
      ),
    ),

    padding = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 75.0),
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.250, 0.375,
          curve: Curves.ease,
        ),
      ),
    ),

    borderRadius = new BorderRadiusTween(
      begin: new BorderRadius.circular(4.0),
      end: new BorderRadius.circular(75.0),
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.375, 0.500,
          curve: Curves.ease,
        ),
      ),
    ),

    color = new ColorTween(
      begin: Colors.indigo[100],
      end: Colors.orange[400],
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(
          0.500, 0.750,
          curve: Curves.ease,
        ),
      ),
    ),

    super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  // This function is called each the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: new Opacity(
        opacity: opacity.value,
        child: new Container(
          width: width.value,
          height: height.value,
          decoration: new BoxDecoration(
            color: color.value,
            border: new Border.all(
              color: Colors.indigo[300],
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerDemo extends StatefulWidget {
  @override
  _StaggerDemoState createState() => new _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 10.0; // 1.0 is normal animation speed.
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: new Center(
          child: new Container(
            width: 300.0,
            height: 300.0,
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: new Border.all(
                color:  Colors.black.withOpacity(0.5),
              ),
            ),
            child: new StaggerAnimation(
              controller: _controller.view
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(home: new StaggerDemo()));
}