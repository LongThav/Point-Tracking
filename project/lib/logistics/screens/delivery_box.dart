import 'package:flutter/material.dart';
import 'package:po_project/logistics/models/po_group_model.dart';
import 'package:po_project/logistics/screens/delivery_confirm.dart';
import 'package:po_project/mains/services/network/api_status.dart';
import 'package:po_project/mains/utils/logger.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import '../../logistics/widgets/inservice_items.dart';
import '../../sales/widgets/next_btn.dart';
import '../../mains/constants/colors.dart';
import '../../logistics/screens/detials_inservice.dart';
import '../models/add_po.dart';
import '../service/po_service.dart';

class DeliverBox extends StatefulWidget {
  final int index;
  final int id;
  final String location;
  final String poNameId;
  final String poStatus;
  final String poDateTime;
  final String poName;
  final String poPhone;
  final String poDelivery;

  bool selected;
  bool select;
  DeliverBox(
      {super.key,
      this.select = true,
      this.selected = false,
      required this.id,
      required this.location,
      required this.poNameId,
      required this.poStatus,
      required this.poDateTime,
      required this.poName,
      required this.poPhone,
      required this.poDelivery,
      required this.index});

  @override
  State<DeliverBox> createState() => _DeliverBoxState();
}

class _DeliverBoxState extends State<DeliverBox> {
  List<int> listIdPOs = [];
  String _street = '';

  AddPO insertPro(int id, String poIdName, String poStatus, String poDate, String poContactName, String poPhone, String poDelivery) {
    var addPO =
        AddPO(poIdName: poIdName, poStatus: poStatus, poDate: poDate, poContactName: poContactName, poPhone: poPhone, poDelivery: poDelivery, id: id);
    return addPO;
  }

  List<AddPO> poPro = [];

  int indexpoPro = 1;

  late PurchaseServiceLogistic _purchaseServiceLogistic;

  final snackBar = const SnackBar(
    content: Text('Please select PO'),
  );
  @override
  void initState() {
    "Po List:$poPro";
    "loading and come to Delivery Box".log();
    super.initState();
    listIdPOs.add(widget.id);
    _purchaseServiceLogistic = context.read<PurchaseServiceLogistic>();
    "List Id PO:${listIdPOs.first}".log();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _purchaseServiceLogistic.setLoading();
      _purchaseServiceLogistic.groupDelivery(listIdPOs.first.toString(), context);
      if (widget.select == true) {
        poPro.add(insertPro(widget.id, widget.poNameId, widget.poStatus, widget.poDateTime, widget.poName, widget.poPhone, widget.poDelivery));
      } else {
        //return nothing
        // poPro.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: -13,
        title: const Text(
          "Delivery Box",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    Loadingstatus loadingstatus = context.watch<PurchaseServiceLogistic>().loadingstatus;
    if (loadingstatus == Loadingstatus.none || loadingstatus == Loadingstatus.loading) {
      "Loading status".log();
      if (poPro.isEmpty) {
        poPro.add(insertPro(widget.id, widget.poNameId, widget.poStatus, widget.poDateTime, widget.poName, widget.poPhone, widget.poDelivery));
        "Po Pro Item:$poPro".log();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingstatus == Loadingstatus.error) {
      return Center(
        child: Text(context.read<PurchaseServiceLogistic>().errorMsg),
      );
    } else {
      return _buildCardDelivery();
    }
  }

  Widget _buildCardDelivery() {
    PoGroup poGroup = _purchaseServiceLogistic.poGroup;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 0.5.h),
      child: RefreshIndicator(
        onRefresh: () async {
          "Pop and Check status".log();
          if (poPro.isEmpty) {
            poPro.add(insertPro(widget.id, widget.poNameId, widget.poStatus, widget.poDateTime, widget.poName, widget.poPhone, widget.poDelivery));
            "Po Pro Item:$poPro".log();
          }
          _purchaseServiceLogistic.setLoading();
          _purchaseServiceLogistic.groupDelivery(widget.id.toString(), context);
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
              itemCount: poGroup.data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final group = poGroup.data[index];
                return Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    InServiceItems(
                      poName: widget.poNameId,
                      edition: widget.poStatus,
                      selected: widget.select,
                      phone: widget.poPhone,
                      name: widget.poName,
                      dateTime: widget.poDateTime,
                      delivery: widget.poDelivery,
                      onSelect: () {},
                      onClick: () {
                        setState(() {
                          widget.select = !widget.select;
                        });
                      },
                      details: () async {
                        if (widget.poStatus.toLowerCase() == "in service") {
                          if (widget.select == true) {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DetailLogistic(
                                index: 0,
                                street: _street,
                                showId: listIdPOs,
                                location: widget.location,
                                poDeliveryAddress: widget.location,
                                addPo: poPro,
                              );
                            }));
                          } else {
                            if (poPro[index].id != widget.id) {
                              poPro.add(AddPO(
                                id: widget.id,
                                poIdName: widget.poNameId,
                                poStatus: widget.poStatus,
                                poDate: widget.poDateTime,
                                poContactName: widget.poName,
                                poPhone: widget.poPhone,
                                poDelivery: widget.poDelivery,
                              ));
                            } else {
                              "Item has been added".log();
                              "Item has been added".log();
                            }
                            'poPro:: $poPro'.log();
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DetailLogistic(
                                index: 0,
                                street: _street,
                                showId: listIdPOs,
                                location: widget.location,
                                poDeliveryAddress: widget.location,
                                addPo: poPro,
                              );
                            }));

                            /// double click...
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                            color: const Color(0XFFF6F6F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(width: 1, color: const Color(0XFFB1BFE1))),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 0.5.h, right: 0.5, top: 1.5.h),
                              child: Text(
                                group.street,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: List.generate(group.pos.length, (index) {
                                  final pos = group.pos[index];
                                  final homeAddress = pos.poDeliverAddress?.homeAddress ?? "";
                                  final street = pos.poDeliverAddress?.street ?? "";
                                  final sangkat = pos.poDeliverAddress?.sangkat.name ?? "";
                                  final khan = pos.poDeliverAddress?.khan.name ?? "";
                                  final province = pos.poDeliverAddress?.province.name ?? "";
                                  _street = group.street;
                                  return InServiceItems(
                                      poName: pos.poNumber,
                                      edition: pos.poStatus,
                                      selected: pos.selected,
                                      dateTime: pos.createdDate,
                                      name: pos.poTo.contactName,
                                      phone: pos.poTo.contactPhone1,
                                      delivery: '$homeAddress $street $khan $province',
                                      onSelect: () {},
                                      onClick: () {
                                        setState(() {
                                          if (pos.poStatus.toLowerCase() == "confirm") {
                                            // nothing return
                                          } else {
                                            pos.selected = !pos.selected;
                                            if (pos.selected == true) {
                                              listIdPOs.add(pos.id);
                                            } else {
                                              listIdPOs.removeLast();
                                            }
                                          }
                                        });
                                        widget.selected = pos.selected;
                                        var address = '$homeAddress $street $khan $province';
                                        if (pos.poStatus.toLowerCase() == "in service" || pos.poStatus.toLowerCase() == "new") {
                                          if (pos.selected == true) {
                                            "id Pos:${pos.id}".log();
                                            "Group pos:${group.pos.length + 1}".log();
                                            "PoPro:${poPro.length}".log();
                                            if (poPro.length == group.pos.length + 1) {
                                              "Smer knea".log();
                                              "Id poPro:${poPro[index + 1].id}".log();
                                              "Pos id:${pos.id}".log();
                                              if (poPro[index + 1].id == pos.id) {
                                                "ot oy add item".log();
                                              } else {
                                                poPro.add(insertPro(pos.id, pos.poNumber, pos.poStatus, pos.createdDate, pos.poTo.contactName,
                                                    pos.poTo.contactPhone1, address));
                                              }
                                            }
                                            //  else if (poPro.length <= group.pos.length) {
                                            //   if (poPro[index + 1].id == pos.id) {
                                            //     "Can't added item".log();
                                            //   } else {
                                            //     poPro.add(insertPro(pos.id, pos.poNumber, pos.poStatus, pos.createdDate, pos.poTo.contactName,
                                            //         pos.poTo.contactPhone1, address));
                                            //   }
                                            // }
                                            else {
                                              "Befor remove:$poPro".log();
                                              poPro.add(insertPro(pos.id, pos.poNumber, pos.poStatus, pos.createdDate, pos.poTo.contactName,
                                                  pos.poTo.contactPhone1, address));
                                              "After Add :$poPro".log();
                                              "min smer knea".log();
                                            }
                                          } else {
                                            poPro.removeLast();
                                            "After remove:$poPro".log();
                                          }
                                        } else {}
                                      },
                                      details: () async {
                                        if (pos.poStatus == "in service" || pos.poStatus == "new") {
                                          if (pos.selected == true) {
                                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return DetailLogistic(
                                                index: index,
                                                addPo: poPro,
                                                street: _street,
                                                showId: listIdPOs,
                                                location: widget.location,
                                                poDeliveryAddress: widget.location,
                                              );
                                            }));
                                          } else {
                                            "Added po".log();
                                            if (poPro.length == group.pos.length + 1) {
                                              "Smer knea".log();
                                              "Id poPro:${poPro[index + 1].id}".log();
                                              "Pos id:${pos.id}".log();
                                              if (poPro[index + 1].id == pos.id) {
                                                "ot oy add item".log();
                                              } else {
                                                poPro.add(insertPro(pos.id, pos.poNumber, pos.poStatus, pos.createdDate, pos.poTo.contactName,
                                                    pos.poTo.contactPhone1, widget.location));
                                                "po Pro Add:$poPro".log();
                                              }
                                            } else {
                                              "Add item".log();
                                              "Befor remove:$poPro".log();
                                              poPro.add(insertPro(pos.id, pos.poNumber, pos.poStatus, pos.createdDate, pos.poTo.contactName,
                                                  pos.poTo.contactPhone1, widget.location));
                                              "After Add :$poPro".log();
                                              "min smer knea".log();
                                            }
                                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return DetailLogistic(
                                                index: index,
                                                addPo: poPro,
                                                street: _street,
                                                showId: listIdPOs,
                                                location: widget.location,
                                                poDeliveryAddress: widget.location,
                                              );
                                            }));
                                          }
                                        }
                                      });
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return NextButton(
        title: 'Confirm Group Delivery',
        onPress: () {
          if (widget.select == true) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DeliveryConfirm(
                // id: widget.id,
                listId: listIdPOs,
                addpo: poPro,
                street: _street,
              );
            }));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
  }
}
