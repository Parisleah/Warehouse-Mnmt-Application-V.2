import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_mnmt/Page/Model/Dealer.dart';
import 'package:warehouse_mnmt/Page/Model/Product.dart';
import 'package:warehouse_mnmt/Page/Model/ProductLot.dart';
import 'package:warehouse_mnmt/Page/Model/ProductModel.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing.dart';
import 'package:warehouse_mnmt/Page/Model/Purchasing_item.dart';

import '../../../db/database.dart';
import '../../Model/Shop.dart';
import 'nav_choose_dealer.dart';
import 'nav_choose_product.dart';
import 'nav_choose_shipping.dart';

class BuyingNavEdit extends StatefulWidget {
  final Shop shop;
  final PurchasingModel purchasing;
  const BuyingNavEdit(
      {super.key, required this.purchasing, required this.shop});
  @override
  State<BuyingNavEdit> createState() => _BuyingNavEditState();
}

class _BuyingNavEditState extends State<BuyingNavEdit> {
  List<PurchasingItemsModel> purchasingItems = [];
  List<Product> products = [];
  List<ProductModel> models = [];
  List<DealerModel> dealers = [];

  DateTime date = DateTime.now();
  final df = new DateFormat('dd-MM-yyyy');
  DealerModel _dealer =
      DealerModel(dName: 'ยังไม่ระบุตัวแทนจำหน่าย', dAddress: '', dPhone: '');
  String _shipping = 'ระบุการจัดส่ง';
  late var shippingCost = widget.purchasing.shippingCost;
  late var totalPrice = widget.purchasing.total;
  late var noShippingPrice = widget.purchasing.total - shippingCost;
  late var amount = widget.purchasing.amount;
  late bool isReceived = widget.purchasing.isReceive;

  final shipPricController = TextEditingController();

  void initState() {
    super.initState();

    shipPricController.addListener(() => setState(() {}));
    refreshPage();
  }

  Future refreshPage() async {
    products =
        await DatabaseManager.instance.readAllProducts(widget.shop.shopid!);

    models = await DatabaseManager.instance.readAllProductModels();
    dealers = await DatabaseManager.instance.readAllDealers();

    purchasingItems = await DatabaseManager.instance
        .readAllPurchasingItemsWherePurID(widget.purchasing.purId!);

    setState(() {});
  }

  _showAlertSnackBar(title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(title),
      duration: Duration(seconds: 2),
    ));
  }

  _updateDealer(DealerModel dealer) {
    setState(() {
      _dealer = dealer;
    });
  }

  _updateShipping(shipping) {
    setState(() {
      _shipping = shipping;
    });
  }

  _addProductInCart(PurchasingItemsModel product) {
    purchasingItems.add(product);
    print('Cart (${purchasingItems.length}) -> ${purchasingItems}');
  }

  _getDealerName() {
    for (var dealer in dealers) {
      if (dealer.dealerId == widget.purchasing.dealerId) {
        return dealer.dName;
      }
    }
  }

  _getDealerAddress() {
    for (var dealer in dealers) {
      if (dealer.dealerId == widget.purchasing.dealerId) {
        return dealer.dAddress;
      }
    }
  }

  Future<void> dialogConfirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (dContext, DialogSetState) {
          return AlertDialog(
            backgroundColor: Theme.of(dContext).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Container(
              width: 150,
              child: Row(
                children: [
                  const Text(
                    'ต้องการลบรายการการสั่งซื้อ ?',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('adasdasd'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () {
                  Navigator.of(dContext).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: const [
              Text(
                "รายงานการสั่งซื้อ",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) => [
                // popupmenu item 2
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          title: const Text(
                            'ต้องการลบรายการการสั่งซื้อ ?',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: const Text('ยกเลิก'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: const Text('ยืนยัน'),
                              onPressed: () async {
                                await DatabaseManager.instance
                                    .deletePurchasing(widget.purchasing.purId!);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  value: 2,
                  // row has two child icon and text
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      Text(
                        "ลบรายการการสั่งซื้อ",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 80),
              color: Theme.of(context).colorScheme.onSecondary,
              elevation: 2,
            ),
          ],
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(29, 29, 65, 1.0),
              Color.fromRGBO(31, 31, 31, 1.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const SizedBox(
                height: 70,
              ),
              // Date Picker
              Container(
                width: 440,
                height: 80,
                child: Row(children: [
                  Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Text(
                    '${df.format(widget.purchasing.orderedDate)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
              ),
              Row(
                children: [
                  Text(
                    "ตัวแทนจำหน่าย",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              Row(children: [
                Expanded(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getDealerName()}',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          '${_getDealerAddress()}',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "รายการสั่งซื้อ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container of รายการสินค้า
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [
                  // ListView

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: purchasingItems.length > 3 ? 230 : 90,
                      width: 440.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        // color: Color.fromRGBO(37, 35, 53, 1.0),
                      ),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: purchasingItems.length,
                          itemBuilder: (context, index) {
                            final purchasing = purchasingItems[index];
                            var prodName;
                            var prodImg;
                            var prodModel;

                            for (var prod in products) {
                              if (prod.prodId == purchasing.prodId) {
                                prodImg = prod.prodImage;
                                prodName = prod.prodName;
                              }
                            }

                            var stProperty;
                            var ndProperty;

                            for (var model in models) {
                              if (model.prodModelId == purchasing.prodModelId) {
                                stProperty = model.stProperty;
                                ndProperty = model.ndProperty;
                              }
                            }

                            return TextButton(
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => sellingNavShowProd(
                                //         product: product)));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 80,
                                    width: 400,
                                    color: Color.fromRGBO(56, 54, 76, 1.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 90,
                                          height: 90,
                                          child: Image.file(
                                            File(prodImg),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${prodName}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        // Theme.of(context)
                                                        //       .colorScheme
                                                        //       .background
                                                        color: Color.fromRGBO(
                                                            36, 33, 50, 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        stProperty,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            36, 33, 50, 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        ndProperty,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  'ราคา ${NumberFormat("#,###.##").format(purchasing.total)}',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  30, 30, 49, 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                                '${NumberFormat("#,###.##").format(purchasing.amount)}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .backgroundColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  // ListView
                  purchasingItems.isEmpty
                      ? Container(
                          width: 10,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'ทั้งหมด ',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(30, 30, 49, 1.0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                    '${NumberFormat("#,###.##").format(purchasingItems.length)}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Theme.of(context).backgroundColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Text(
                              'รายการ ',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "การจัดส่ง",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              // Container of รายการสินค้า

              // Container of การจัดส่ง
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("วิธีจัดส่ง",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Text(widget.purchasing.shipping!,
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                ]),
              ),
              // Container of การจัดส่ง
              const SizedBox(
                height: 10,
              ),
              // Container of ค่าจัดส่ง
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("ค่าจัดส่ง",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Text(
                      '${NumberFormat("#,###.##").format(widget.purchasing.shippingCost)}',
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                ]),
              ),
              // Container of ค่าจัดส่ง

              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "สรุปรายการสั่งซื้อ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // Container of จำนวน
              Container(
                decoration: BoxDecoration(
                    // color: const Color.fromRGBO(56, 48, 77, 1.0),
                    borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 30,
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text("จำนวน",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  Spacer(),
                  Text('${NumberFormat("#,###,###,### ชิ้น").format(amount)}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ]),
              ),
              // Container of จำนวน

              // Container of รวม
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: 400,
                height: 30,
                child: Wrap(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Text("รวม",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          shippingCost == 0
                              ? Container(
                                  width: 0,
                                )
                              : Text(
                                  'สินค้า(${NumberFormat("#,###,###,###.##").format(noShippingPrice)})',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                          shippingCost == 0
                              ? Container(
                                  width: 0,
                                )
                              : Text(
                                  '   + ค่าส่ง (${NumberFormat("#,###,###,###.##").format(shippingCost)})',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).backgroundColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            '${NumberFormat("#,###,###,###.##").format(totalPrice)}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey)),
                      ),
                    ]),
                  ],
                ),
              ),
              // Container of รวม
              const SizedBox(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        isReceived = !isReceived;
                        if (isReceived == false) {
                          print('ยังไม่ได้รับสินค้า');
                        } else {
                          print('ได้รับสินค้าแล้ว');
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isReceived
                            ? Icon(
                                Icons.check_box,
                                size: 40.0,
                                color: Theme.of(context).backgroundColor,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 40.0,
                                color: Theme.of(context).backgroundColor,
                              ),
                      ),
                    ),
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ได้รับสินค้าเรียบร้อยแล้ว",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "(สินค้าคงเหลือจะได้รับการปรับปรุง)",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.redAccent),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "ยกเลิกรายการ",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ]),
                    Column(children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Product Lot
                          if (isReceived) {
                            for (var item in purchasingItems) {
                              final productLot = ProductLot(
                                  orderedTime: date,
                                  amount: isReceived == true ? item.amount : 0,
                                  remainAmount: isReceived == true ? amount : 0,
                                  prodModelId: item.prodModelId);
                              await DatabaseManager.instance
                                  .updateProductLot(productLot);
                            }

                            final updatedPurchasing =
                                widget.purchasing!.copy(isReceive: isReceived);

                            await DatabaseManager.instance
                                .updatePurchasing(updatedPurchasing);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                children: [
                                  Text("ปรับปรุงสินค้าคงเหลือแล้ว"),
                                ],
                              ),
                              duration: Duration(seconds: 5),
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "บันทึก",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ]),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}