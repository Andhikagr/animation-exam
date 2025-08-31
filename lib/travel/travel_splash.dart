import 'package:flutter/material.dart';

class TravelSplash extends StatefulWidget {
  const TravelSplash({super.key});

  @override
  State<TravelSplash> createState() => _TravelSplashState();
}

class _TravelSplashState extends State<TravelSplash>
    with TickerProviderStateMixin {
  bool isBig = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  //box
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    //controller 1
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    //atur animasi 1
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    //controller 2
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    //atur animasi 2
    _slideAnimation = Tween<Offset>(
      begin: Offset(-10, 10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    //jalankan
    startAnimation();
  }

  //fungsi animation
  Future<void> startAnimation() async {
    await _fadeController.forward();
    await Future.delayed(Duration(milliseconds: 800));
    await _slideController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _fadeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/travel/bgdtask.png", fit: BoxFit.fitHeight),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                curve: Curves.easeInOut,
                width: isBig ? 433 : 333,
                height: isBig ? 433 : 333,
                duration: Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isBig = !isBig;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Building Better Workplaces",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.bold,
                              fontSize: 37,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Create a unique emotional story that describes better than word",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 42),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Stack(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff8B78FF),
                                        Color(0xff5451D6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff5451D6),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Get Started",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
