import 'package:flutter/material.dart';

class SimpleSplash extends StatefulWidget {
  const SimpleSplash({super.key});

  @override
  State<SimpleSplash> createState() => _SimpleSplashState();
}

class _SimpleSplashState extends State<SimpleSplash>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _opacityController;
  late AnimationController _bounceController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    //scale
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeIn));

    //opacity
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeInCubic),
    );

    //bounce
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    Future<void> startAnimation() async {
      await _scaleController.forward();
      await Future.delayed(Duration(milliseconds: 800));
      await _opacityController.forward();
    }

    startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _scaleController.dispose();
    _opacityController.dispose();
    _bounceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/simple/bgsimple.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 80,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff424242),
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      "This is a Flutter-based learning application designed to help users explore, practice, and understand the fundamental as well as advanced concepts of Flutter development.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: ScaleTransition(
                        scale: _bounceAnimation,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {},
                              child: Container(
                                width: 125,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff9E9E9E),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Image.asset(
                                      "assets/simple/arrowsimple.png",
                                      width: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
