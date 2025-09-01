import 'dart:math';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:animation_exam/food_one/widget/data_model.dart';
import 'package:animation_exam/food_one/widget/format_rupiah.dart';
import 'package:animation_exam/food_one/widget/icon.dart';
import 'package:animation_exam/food_one/widget/text_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodOneSplash extends StatefulWidget {
  const FoodOneSplash({super.key});

  @override
  State<FoodOneSplash> createState() => _FoodOneSplashState();
}

class _FoodOneSplashState extends State<FoodOneSplash>
    with SingleTickerProviderStateMixin {
  //memilih topping
  int selectTopping = 0;

  //qty items
  int numbers = 0;
  String qty = "0";

  late PageController _pageController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  //fungsi
  void addProduk() {
    setState(() {
      numbers++;
      qty = numbers.toString();
    });
  }

  void minusProduk() {
    setState(() {
      if (numbers > 0) numbers--;
      qty = numbers.toString();
      if (numbers == 0) return;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
    _pageController.addListener(() {
      setState(() {});
    });

    //animasi item tengah
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // buat key untuk masing-masing burger agar bisa dijadikan target animasi
    burgerKeys = List.generate(burgerItems.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  //total awal items di cart
  RxInt totalItem = 0.obs;

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();

  //untuk menjalanakan animasi
  late Function(GlobalKey) runAddToCartAnimation;

  var cartQty = 0;

  //key untuk masing2 item
  late List<GlobalKey> burgerKeys;

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    //update badge
    await cartKey.currentState!.runCartAnimation((++cartQty).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,

      jumpAnimation: JumpAnimationOptions(active: false),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },

      child: Scaffold(
        backgroundColor: const Color(0xFF3A3C4A),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // background
            Image.asset("assets/foodone/fdbackone.png", fit: BoxFit.cover),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Image.asset("assets/foodone/backfd.png", scale: 2),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/foodone/fdeclipone.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: AddToCartIcon(
                            key: cartKey,
                            icon: Icon(
                              CupertinoIcons.shopping_cart,
                              color: Colors.white,
                            ),
                            badgeOptions: BadgeOptions(
                              active: true,
                              backgroundColor: Color(0xffFF7269),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 300,
                    child: AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return PageView.builder(
                          controller: _pageController,
                          itemCount: burgerItems.length,
                          itemBuilder: (context, index) {
                            final burger = burgerItems[index];

                            double page = 0;
                            if (_pageController.hasClients) {
                              page = _pageController.page ?? 0;
                            }

                            double distanceFromCenter = page - index;
                            // efek melengkung halus
                            double translateY =
                                30 * (1 - cos(distanceFromCenter * 0.8 * pi));
                            // bounce hanya untuk item tengah
                            double bounce =
                                _bounceAnimation.value *
                                max(0, 1 - distanceFromCenter.abs());
                            // rotasi sederhana untuk efek 3D
                            double rotationY = distanceFromCenter * 0.2;

                            return Transform.translate(
                              offset: Offset(0, translateY - bounce),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..rotateY(rotationY),
                                child: Container(
                                  key: burgerKeys[index],
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(burger["image"]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //informasi item
                  Builder(
                    builder: (context) {
                      int currentPage = 0;
                      if (_pageController.hasClients) {
                        currentPage =
                            (_pageController.page ??
                                    _pageController.initialPage)
                                .round();
                      }
                      final burgerDetail = burgerItems[currentPage];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextOrder(
                            textItem: burgerDetail["name"],
                            colorItem: Colors.grey.shade200,
                            sizeText: 23,
                            isBold: true,
                          ),
                          TextOrder(
                            textItem: (burgerDetail["price"] as num).toRupiah(),
                            colorItem: Colors.grey.shade400,
                            sizeText: 14,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: 70,
                              child: TextOrder(
                                textItem: burgerDetail["description"],
                                colorItem: Colors.grey.shade200,
                                sizeText: 14,
                                isCenter: true,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChooseIcons(
                          icons: Icon(CupertinoIcons.add_circled_solid),
                          colorIcon: Colors.grey.shade200,
                          onTap: addProduk,
                        ),
                        TextOrder(
                          textItem: qty,
                          colorItem: Colors.grey.shade200,
                          sizeText: 13,
                        ),
                        ChooseIcons(
                          icons: Icon(CupertinoIcons.minus_circle_fill),
                          colorIcon: Colors.grey.shade200,
                          onTap: minusProduk,
                        ),
                        Icon(CupertinoIcons.time, color: Colors.grey.shade500),
                        SizedBox(width: 10),
                        TextOrder(
                          textItem: "10 Menit",
                          colorItem: Colors.grey.shade500,
                          sizeText: 13,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextOrder(
                        textItem: "Topping",
                        colorItem: Colors.grey.shade300,
                        sizeText: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: toppingItem.length,
                      itemBuilder: (context, index) {
                        final bool selectTop = selectTopping == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectTopping = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: selectTop
                                  ? Color(0xffFF7269)
                                  : Colors.transparent,
                              border: Border.all(color: Colors.grey.shade700),
                            ),
                            child: Center(
                              child: TextOrder(
                                textItem: toppingItem[index]["name"],
                                colorItem: selectTop
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200,
                                sizeText: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 90,
          decoration: BoxDecoration(color: Color(0xffFF7269)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextOrder(
                      textItem: "Total",
                      colorItem: Colors.grey.shade900,
                      sizeText: 14,
                    ),
                    Builder(
                      builder: (context) {
                        int currentPage = 0;
                        if (_pageController.hasClients) {
                          currentPage =
                              (_pageController.page ??
                                      _pageController.initialPage)
                                  .round();
                        }
                        final burgerDetail = burgerItems[currentPage];
                        return TextOrder(
                          textItem: (totalItem * burgerDetail["price"])
                              .toRupiah(),
                          colorItem: Colors.white,
                          sizeText: 23,
                          isBold: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (numbers > 0) {
                      int currentPage = 0;
                      if (_pageController.hasClients) {
                        currentPage =
                            (_pageController.page ??
                                    _pageController.initialPage)
                                .round();
                      }

                      //jalankan animasi
                      runAddToCartAnimation(burgerKeys[currentPage]);

                      //update jumlah item
                      cartQty += numbers;
                      cartKey.currentState!.runCartAnimation(
                        cartQty.toString(),
                      );
                      //update cart reactive GetX
                      totalItem.value += numbers;
                      numbers = 0;
                      qty = numbers.toString();
                      setState(() {});
                    }
                  },
                  splashColor: Colors.grey.shade300,
                  child: Ink(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: TextOrder(
                        textItem: "Pesan",
                        colorItem: Colors.black,
                        sizeText: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
