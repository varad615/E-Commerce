import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/screens/product_page.dart';
import 'package:v_com/widgets/custom_action_bar.dart';
import 'package:v_com/widgets/product_cart.dart';

class HomeTab extends StatelessWidget {
final CollectionReference _productsRef = FirebaseFirestore.instance.collection("products");


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                        "Error ${snapshot.error}"
                    ),
                  ),
                );
              }

              if(snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(
                    top: 90.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return ProductCart(
                      title: document.data()['name'],
                      imageUrl: document.data()['Image'][0],
                      price: "\$${document.data()['prize']}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }


          ),
          CustomActionBar(
            title: "Home",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
