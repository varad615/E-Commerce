import 'package:flutter/material.dart';
import 'package:v_com/constants.dart';
import 'package:flutter/services.dart';
import 'package:v_com/screens/product_page.dart';

class ProductCart extends StatelessWidget {
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;
  final String productId;

  ProductCart({this.title, this.onPressed, this.imageUrl, this.price, this.productId});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductPage(productId: productId,),
        ));
      },
      child: Container(
        height: 350.0,
        margin: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: [
            Container(
              height:350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  "$imageUrl",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 2.0,
                          bottom: 2.0,
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Text(
                          title,
                          style: constants.regularHeading,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 2.0,
                          bottom: 2.0,
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Text(
                          price,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
