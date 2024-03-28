import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/bloc/order/order_bloc.dart';
import 'package:foodie/customCliper/containerCliper.dart';
import 'package:foodie/modelClass/foodModelClass.dart';

import 'package:foodie/screens/mydialog.dart';
import 'package:readmore/readmore.dart';

class OrderScreen extends StatefulWidget {
  static const pagename = '/orderScreen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    var clintHeight = screenHeight - kToolbarHeight;

    // final orderFirestore =
    //     FirebaseFirestore.instance.collection('order').snapshots();

    return BlocProvider(
      create: (context) => OrderBloc(context),
      child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            elevation: 3,
            backgroundColor: Colors.red,
            title: const Text(
              'Your Order',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case OrderInitialState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  (state as OrderLoadedState);
                  return Center(
                    child: StreamBuilder(
                      stream: state.data,
                      builder: (context, snapshot) {
                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(20),
                          itemCount: (snapshot.data?.docs.length) ?? 0,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, mainAxisSpacing: 40, mainAxisExtent: 320, crossAxisCount: 1),
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            Food orderFood = Food.fromMap(snapshot.data!.docs[index].data());
                            return Column(
                              children: [
                                Card(
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 5,
                                  color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: screenHeight * 0.28,
                                        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        child: Image.network(
                                          orderFood.imageURL,
                                          height: clintHeight * 0.4,
                                          width: screenWidth * 0.4,
                                        ),
                                      ),
                                      Container(
                                        height: clintHeight * 0.57,
                                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                        child: SingleChildScrollView(scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: clintHeight * 0.030,
                                              ),
                                              Text(orderFood.dateTime.toString()),
                                              SizedBox(
                                                height: clintHeight * 0.020,
                                              ),
                                              Text('Total item Selected :${orderFood.quentity}'),
                                              SizedBox(
                                                height: clintHeight * 0.010,
                                              ),
                                              SingleChildScrollView(scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth * 0.050,
                                                    ),
                                                    Text(
                                                      textDirection: TextDirection.ltr,
                                                      maxLines: 2,
                                                      orderFood.name,
                                                      style: TextStyle(fontSize: screenWidth * 0.040),
                                                    ),
                                                    SizedBox(
                                                      height: clintHeight * 0.050,
                                                    ),
                                                    ClipPath(
                                                      clipper: ContainerClipper(),
                                                      child: Container(
                                                        height: clintHeight * 0.15,
                                                        width: screenWidth * 0.4,
                                                        color: Colors.red,
                                                        child: Center(
                                                          child: Text(
                                                            'Rs: ${orderFood.price * orderFood.quentity!}',
                                                            style: const TextStyle(fontSize: 11, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: clintHeight * 0.010,
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.75,
                                                  child: ReadMoreText(
                                                    orderFood.detail.toString(),
                                                    trimLength: 100,
                                                    trimExpandedText: '..less',
                                                    trimCollapsedText: '...More',
                                                    moreStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                    lessStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                  )),
                                              SizedBox(
                                                height: screenHeight * 0.070,
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: Size(screenWidth * 0.6, clintHeight * 0.060), elevation: 3, shadowColor: Colors.black, backgroundColor: Colors.red),
                                                  onPressed: () {
                                                    showMyOrderDialog(orderFood.id, context);
                                                  },
                                                  child: const Text(
                                                    'Cancel Order',
                                                    style: TextStyle(color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
              }
            },
          )),
    );
  }
}
