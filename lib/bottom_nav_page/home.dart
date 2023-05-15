import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/ui/product_detail_screen.dart';
import 'package:runnn/ui/search_screen1.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _firestoreInstance = FirebaseFirestore.instance;
  final List<String> _carouselImages = [];
  final List _products = [];
  var _dotPosition = 0;
  //TextEditingController _searchController = TextEditingController();

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: TextFormField(
              //controller: _searchController,
              readOnly: true,

              decoration: InputDecoration(
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: "Search products here",
                hintStyle: TextStyle(fontSize: 15.sp),
              ),
              onTap: () => Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => const Search())),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          AspectRatio(
            aspectRatio: 3.5,
            child: CarouselSlider(
              items: _carouselImages
                  .map((item) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(item),
                                fit: BoxFit.fitWidth)),
                      ))
                  .toList(),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (val, CarouselPageChangedReason) {
                  setState(() {
                    _dotPosition = val;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          DotsIndicator(
            dotsCount: _carouselImages.isEmpty ? 1 : _carouselImages.length,
            position: _dotPosition.toDouble(),
            decorator: DotsDecorator(
                activeColor: AppColors.deep_orange,
                color: AppColors.deep_orange.withOpacity(0.5),
                spacing: const EdgeInsets.all(2),
                activeSize: const Size(8, 8),
                size: const Size(6, 6)),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetails(_products[index]))),
                    child: Card(
                      elevation: 3,
                      child: Column(children: [
                        AspectRatio(
                            aspectRatio: 2,
                            child: Container(
                              color: Colors.amber,
                              child: Image.network(
                                  _products[index]["product-img"][0]),
                            )),
                        Text("${_products[index]["product-name"]}"),
                        Text(_products[index]["product-price"].toString()),
                      ]),
                    ),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
