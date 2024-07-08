// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_physics/main.dart'; // Importa main.dart per accedere a MainScreen

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // Navigate to MainScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!, 
              Colors.cyan, 
            ],
            stops: const [0.0, 1.0], 
            transform: const GradientRotation(45 * 3.1415927 / 180),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png', 
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 30),
              Container(
                width: 200,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[800], 
                  borderRadius: BorderRadius.circular(4), 
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4), 
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Spazio sotto la barra di caricamento
            ],
          ),
        ),
      ),
    );
  }
}
