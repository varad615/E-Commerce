import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:v_com/services/firebase_services.dart';
import 'package:v_com/widgets/custom_action_bar.dart';
import 'package:v_com/widgets/custom_input.dart';
import 'package:v_com/widgets/product_cart.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if(_searchString.isEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: 150.0,
                ),
                  child: Text("Search Result",style: constants.regularDarkText,)),
            )
          else
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef.orderBy('search_string')
                  .startAt([_searchString])
                  .endAt(["$_searchString\uf8ff"])
                  .get(),
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
                      top: 110.0,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hinttext: "Search....",
              onSubmitted: (value){
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
              },
            ),
          ),


        ],
      ),
    );
  }
}
