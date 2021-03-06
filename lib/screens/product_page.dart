import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/services/firebase_services.dart';
import 'package:v_com/widgets/custom_action_bar.dart';
import 'package:v_com/widgets/custom_btn.dart';
import 'package:v_com/widgets/image_swipe.dart';
import 'package:v_com/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }
  Future _addToSave() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("saved")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  final SnackBar snackBar = SnackBar(
    content: Text("Product Added To Cart"),
  );

  final SnackBar snackBar2 = SnackBar(
    content: Text("Product Bookmarked"),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _firebaseServices.productsRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error ${snapshot.error}"),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> documentData = snapshot.data.data();

              //image list
              List imageList = documentData['Image'];
              List productSize = documentData['size'];

              _selectedProductSize = productSize[0];

              return ListView(
                padding: EdgeInsets.all(0),
                children: [
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 24.0,
                      right: 24.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      "${documentData['name']}" ?? "Product Name",
                      style: constants.boaldheading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      "₹${documentData['prize']}" ?? "Price",
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 20.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      "${documentData['desc']}" ?? "Description",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      "Select Size",
                      style: constants.regularDarkText,
                    ),
                  ),
                  ProductSize(
                    productSizes: productSize,
                    onSelected: (size) {
                      _selectedProductSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _addToSave();
                            Scaffold.of(context).showSnackBar(snackBar2);
                          },
                          child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/images/tab_saved.png"),
                                height: 22,
                              )),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              _addToCart();
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            child: Container(
                              height: 65.0,
                              margin: EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)),
                              alignment: Alignment.center,
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(
                  vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                    ),

                  )
                ],
              );
            }

            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          hasTitle: false,
          hasBackArrow: true,
          hasBackground: false,
        ),
      ],
    ));
  }
}
