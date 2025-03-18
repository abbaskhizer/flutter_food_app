
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie/controller/bloc/order/order_bloc.dart';
import 'package:foodie/controller/customCliper/containerCliper.dart';
import 'package:foodie/model/foodModelClass.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final clientHeight = screenSize.height - kToolbarHeight;

    return BlocProvider(
      create: (context) => OrderBloc(context),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          elevation: 3,
          backgroundColor: Colors.red,
          title: const Text('Your Order', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoadedState) {
              return StreamBuilder(
                stream: state.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading orders'));
                  }
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  }

                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(20),
                    itemCount: snapshot.data.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      mainAxisSpacing: 40,
                      mainAxisExtent: 320,
                      crossAxisCount: 1,
                    ),
                    itemBuilder: (context, index) {
                      Food orderFood = Food.fromMap(snapshot.data.docs[index].data());
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
                                  height: clientHeight * 0.28,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child: Image.network(
                                    orderFood.imageURL,
                                    height: clientHeight * 0.6,
                                    width: screenSize.width * 0.6,
                                    
                                  ),
                                ),
                                Container(
                                  height: clientHeight * 0.57,
                                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: clientHeight * 0.030),
                                        Text(orderFood.dateTime.toString()),
                                        SizedBox(height: clientHeight * 0.020),
                                        Text('Total quantity Selected: ${orderFood.quentity}'),
                                        SizedBox(height: clientHeight * 0.010),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: screenSize.width * 0.050),
                                              Text(
                                                orderFood.name,
                                                style: TextStyle(fontSize: screenSize.width * 0.040),
                                                maxLines: 2,
                                                textDirection: TextDirection.ltr,
                                              ),
                                              SizedBox(height: clientHeight * 0.050),
                                              ClipPath(
                                                clipper: ContainerClipper(),
                                                child: Container(
                                                  height: clientHeight * 0.15,
                                                  width: screenSize.width * 0.4,
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
                                        SizedBox(height: clientHeight * 0.010),
                                        SizedBox(
                                          width: screenSize.width * 0.75,
                                          child: ReadMoreText(
                                            orderFood.detail.toString(),
                                            trimLength: 100,
                                            trimExpandedText: '..less',
                                            trimCollapsedText: '...More',
                                            moreStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                            lessStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: clientHeight * 0.070),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(screenSize.width * 0.6, clientHeight * 0.060),
                                            elevation: 3,
                                            shadowColor: Colors.black,
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            _showMyOrderDialog(orderFood.id, context);
                                          },
                                          child: const Text('Cancel Order', style: TextStyle(color: Colors.white)),
                                        ),
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
              );
            }
            return const Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
  Future<void> _showMyOrderDialog(String id, BuildContext context) async {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.red,
        elevation: 3,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () async {
                BlocProvider.of<OrderBloc>(context).add(DeleteFromOrderEvent(deocumentsId: id));
              },
              child: const Text(
                'Cancel Order',
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: const Text('Do you want to Cancel Order?', style: TextStyle(fontSize: 20, color: Colors.white)),
      );
    },
  );
}
}
