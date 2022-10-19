import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:medi_tech/Covid_19/View/world_states.dart';

class CovidSplashScreen extends StatefulWidget {
  const CovidSplashScreen({Key? key}) : super(key: key);

  @override
  _CovidSplashScreenState createState() => _CovidSplashScreenState();
}

class _CovidSplashScreenState extends State<CovidSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const WorldStates())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: const SizedBox(
                width: 200.0,
                height: 200.0,
                child: Center(
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/virus.png'),
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * math.pi,
                  child: child,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .08,
            ),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  'Covid-19\nTracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ))
          ],
        ),
      ),
    );
  }
}
