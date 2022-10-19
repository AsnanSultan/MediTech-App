import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medi_tech/Models/Product.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Widgets/my_medicine_box.dart';
import 'package:provider/provider.dart';

import '../Models/Cart.dart';
import '../Provider/cart_provider.dart';
import '../Provider/customer_provider.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({Key? key}) : super(key: key);

  @override
  _MySearchScreenState createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  TextEditingController searchQuery = TextEditingController();
  Cart tempCart = Cart(id: "", userId: "",pharmacyId: "", productId: "", count: 1);

  List<Product> resultProducts = [];

  void search(List<Product> products) {
    resultProducts.clear();
    for (int i = 0; i < products.length; i++) {
      if (products[i]
              .name
              .toLowerCase()
              .contains(searchQuery.text.toString().toLowerCase()) ||
          products[i]
              .category
              .toLowerCase()
              .contains(searchQuery.text.toString().toLowerCase())) {
        resultProducts.add(products[i]);
      }
    }
    setState(() {});
  }

  bool checkProductIsInCart(Product product, List<Cart> list) {
    for (int i = 0; i < list.length; i++) {
      if (product.id == list[i].productId) {
        return true;
      }
    }

    return false;
  }

  bool flag = true;
  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    if (flag) {
      search(pharmacyProvider.productList);
    }
    flag = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              TextField(
                onChanged: (data) {
                  search(pharmacyProvider.productList);
                },
                controller: searchQuery,
                keyboardType: TextInputType.name,
                autofocus: true,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 18),
                  hintText: 'Search Medicine...',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 640,
                width: MediaQuery.of(context).size.width,
                child: AnimationLimiter(
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 240,
                      ),
                      itemCount: resultProducts.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Cart? tempCart2;
                        try {
                          tempCart2 = cartProvider.cartList.firstWhere((cart) =>
                              resultProducts[index].id == cart.productId);
                        } catch (e) {
                          tempCart2 = null;
                        }
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: resultProducts.length,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: Stack(
                                children: [
                                  MyMedicineBox(
                                    product: resultProducts[index],
                                    isCart: tempCart2,
                                  ),
                                  Container(
                                      width: 200,
                                      padding: const EdgeInsets.only(
                                          top: 180, left: 12, right: 12),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (checkProductIsInCart(
                                              resultProducts[index],
                                              cartProvider.cartList)) {
                                          } else {
                                            tempCart = Cart(
                                                id: "",
                                                userId: customerProvider
                                                    .currentCustomer.id,
                                                pharmacyId: resultProducts[index].pharmacyId,
                                                productId:
                                                    resultProducts[index].id,
                                                count: 1);
                                            cartProvider.addToCard(tempCart);
                                          }
                                        },
                                        child: (cartProvider.isLoading &&
                                                resultProducts[index].id ==
                                                    tempCart.productId)
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : (checkProductIsInCart(
                                                    resultProducts[index],
                                                    cartProvider.cartList))
                                                ? const Icon(Icons.check)
                                                : const Text("Add To Cart"),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
