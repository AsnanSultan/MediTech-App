import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:medi_tech/Models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_tech/Provider/cart_provider.dart';
import 'package:medi_tech/Provider/pharmacy_provider.dart';
import 'package:medi_tech/Screens/CustomOrder/custom_order_request.dart';
import 'package:medi_tech/Widgets/my_medicine_box.dart';
import 'package:provider/provider.dart';

import '../Models/Cart.dart';
import '../Provider/cart_provider.dart';
import '../Provider/customer_provider.dart';

class AllProductScreen extends StatefulWidget {
  AllProductScreen({required this.filter, this.isHome, Key? key})
      : super(key: key);
  String filter;
  bool? isHome = false;
  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  Cart tempCart =
      Cart(id: "", userId: "", pharmacyId: "", productId: "", count: 1);

  bool checkProductIsInCart(Product product, List<Cart> list) {
    for (int i = 0; i < list.length; i++) {
      if (product.id == list[i].productId) {
        return true;
      }
    }

    return false;
  }

  List<Product> filterProducts = [];
  void filter(List<Product> products) {
    filterProducts = [];
    if (dropdownValue == "All") {
      filterProducts.addAll(products);
    } else {
      for (int i = 0; i < products.length; i++) {
        if (dropdownValue.toLowerCase() == products[i].category.toLowerCase()) {
          filterProducts.add(products[i]);
        }
      }
    }
  }

  TextEditingController searchQuery = TextEditingController();

  void search(List<Product> products) {
    List<Product> temp = [];

    for (int i = 0; i < products.length; i++) {
      if (products[i]
              .name
              .toLowerCase()
              .contains(searchQuery.text.toString().toLowerCase()) &&
          (dropdownValue.toLowerCase() == products[i].category.toLowerCase() ||
              dropdownValue == "All")) {
        temp.add(products[i]);
      }
    }
    filterProducts.clear();
    filterProducts.addAll(temp);
    setState(() {});
  }

  String dropdownValue = "All";
  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    if (searchQuery.text.isEmpty) {
      filter(pharmacyProvider.productList);
    } else {
      search(pharmacyProvider.productList);
    }
    return (widget.isHome!)
        ? Container(
            child: ProductScreen(cartProvider, customerProvider, context),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Products"),
            ),
            body: pharmacyProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child:
                        ProductScreen(cartProvider, customerProvider, context),
                  ),
          );
  }

  Widget ProductFilter(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 10),
      child: Row(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width / 2,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                TextField(
                  maxLines: 1,
                  controller: searchQuery,
                  onChanged: (data) {
                    search(products);
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Search Medicine...",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    search(products);
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            style: const TextStyle(fontSize: 16),
            icon: Stack(
              children: const [
                Icon(
                  Icons.filter_alt_rounded,
                  size: 28,
                  color: Colors.blueAccent,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18.0, top: 8),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            value: dropdownValue,
            onChanged: (newValue) {
              dropdownValue = newValue!;
              // filter(pharmacyProvider.productList);
              setState(() {});
            },
            elevation: 0,
            items: <String>[
              'All',
              'Tablets',
              'Capsules',
              'Syrup',
              'Injections',
              'Drops',
              'Homeopathic',
              'Medical Equipments'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget ProductScreen(CartProvider cartProvider,
      CustomerProvider customerProvider, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        !(widget.isHome!)
            ? ProductFilter(filterProducts)
            : Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 11,
                  bottom: 10,
                ),
                child: Row(
                  children: const [
                    Text("Products"),
                    Spacer(),
                  ],
                ),
              ),
        (filterProducts.isEmpty)
            ? Container(
                margin: const EdgeInsets.only(top: 100),
                height: 330,
                width: 300,
                child: Column(
                  children: [
                    Image.asset('assets/images/dataNotFound.png'),
                    const Text("Data not found!"),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomOrderRequest()));
                        },
                        child: Text("You can create Custom Order request"))
                  ],
                ))
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 640,
                child: StreamBuilder<QuerySnapshot>(
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    }
                    return AnimationLimiter(
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 240,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: filterProducts.length,
                          itemBuilder: (context, index) {
                            Cart? tempCart2;
                            try {
                              tempCart2 = cartProvider.cartList.firstWhere(
                                  (cart) =>
                                      filterProducts[index].id ==
                                      cart.productId);
                            } catch (e) {
                              tempCart2 = null;
                            }

                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: filterProducts.length,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: Stack(
                                    children: [
                                      MyMedicineBox(
                                        product: filterProducts[index],
                                        isCart: tempCart2,
                                      ),
                                      Container(
                                          width: 200,
                                          padding: const EdgeInsets.only(
                                              top: 190, left: 12, right: 12),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (checkProductIsInCart(
                                                  filterProducts[index],
                                                  cartProvider.cartList)) {
                                              } else {
                                                tempCart = Cart(
                                                    id: "",
                                                    userId: customerProvider
                                                        .currentCustomer.id,
                                                    pharmacyId:
                                                        filterProducts[index]
                                                            .pharmacyId,
                                                    productId:
                                                        filterProducts[index]
                                                            .id,
                                                    count: 1);
                                                cartProvider
                                                    .addToCard(tempCart);
                                              }
                                            },
                                            child: (cartProvider.isLoading &&
                                                    filterProducts[index].id ==
                                                        tempCart.productId)
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : (checkProductIsInCart(
                                                        filterProducts[index],
                                                        cartProvider.cartList))
                                                    ? const Icon(Icons.check)
                                                    : const Text("Add To Cart"),
                                          )),
                                      /*GestureDetector(
                                        onTap: () {
                                          filterProducts[index].isHeart =
                                              filterProducts[index].isHeart
                                                  ? false
                                                  : true;
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 135, top: 10),
                                          child: Icon(
                                            filterProducts[index].isHeart
                                                ? CupertinoIcons.heart_fill
                                                : CupertinoIcons.heart,
                                            color: filterProducts[index].isHeart
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 32,
                                          ),
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                )),
      ],
    );
  }
}
