import 'package:flutter/material.dart';
import 'package:po_project/logistics/models/add_po.dart';
import 'package:po_project/mains/utils/logger.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/services/network/api_status.dart';
import '../../mains/constants/colors.dart';
import '../../sales/screens/common/show_pin_location.dart';
import '../../sales/widgets/save_btn.dart';
import '../models/show_model.dart';
import '../service/po_service.dart';
import '../widgets/view_Paten_file.dart';
import 'delivery_confirm.dart';

class DetailLogistic extends StatefulWidget {
  final int index;
  final String street;
  final List<int> showId;
  final String location;
  final List<AddPO> addPo;
  final String poDeliveryAddress;
  const DetailLogistic(
      {super.key,
      required this.street,
      required this.showId,
      required this.location,
      required this.poDeliveryAddress,
      required this.addPo,
      required this.index});

  @override
  State<DetailLogistic> createState() => _DetailLogisticState();
}

class _DetailLogisticState extends State<DetailLogistic> with TickerProviderStateMixin {
  late TabController _tabController;

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<PurchaseServiceLogistic>().setLoading();
      print("ID:${widget.showId.join(',')}");
      await context.read<PurchaseServiceLogistic>().readShowDetail(widget.showId.join(','), context);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onPressed: () async {
            if (widget.addPo.isEmpty) {
              // widget.showId.first
              Navigator.pop(context);
            } else {
              // print("ID befor remove:${widget.showId}");
              // print("Add PO:${widget.addPo}");
              // widget.addPo.removeAt(widget.index);
              // print("Show ID:${widget.showId}");

              // print("ID befor remove:${widget.showId}");
              // widget.showId.removeLast();
              // print("ID After remove:${widget.showId}");
              if (widget.showId.length == 2) {
                print("ID befor remove:${widget.showId}");
                widget.showId.removeLast();
                print("ID After remove:${widget.showId}");
              }

              // print("Befor Remove addPo...:${widget.addPo}");
              // widget.addPo.removeLast();
              // print("After Remove...:${widget.addPo}");
              if (widget.addPo.length == 2) {
                print("Befor Remove addPo...:${widget.addPo}");
                widget.addPo.removeLast();
                print("After Remove...:${widget.addPo}");
              }

              //  widget.addPo.clear();
              await Future.delayed(const Duration(milliseconds: 600)).then((value) {
                Navigator.pop(context);
              });
            }
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
        bottom: TabBar(
            onTap: (v) {
              if (v == 1 && v == 2) {}
            },
            indicatorColor: AppColors.textColor,
            indicatorWeight: 2.0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.textColor,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            labelPadding: EdgeInsets.only(bottom: 1.7.h),
            automaticIndicatorColorAdjustment: true,
            controller: _tabController,
            tabs: const [
              Text(
                'General',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                'Product',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              )
            ]),
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: SaveBtn(
          onPress: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DeliveryConfirm(
                addpo: widget.addPo,
                // id: widget.showId,
                street: widget.street,
                listId: widget.showId,
              );
            }));
          },
          title: 'Confirm Delivery',
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _buildTabBarView(),
    );
  }

  Widget _buildTabBarView() {
    Loadingstatus loadingstatus = context.watch<PurchaseServiceLogistic>().loadingstatus;
    if (loadingstatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingstatus == Loadingstatus.complete) {
      return TabBarView(controller: _tabController, children: [
        _buildGeneral(),
        _buildProduct(),
        _buildProgress(),
      ]);
    } else {
      return const Center(
        child: Text("Error"),
      );
    }
  }

  Widget _buildGeneral() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 18),
            margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(85, 75, 186, 0.14),
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 7.0,
                spreadRadius: 7.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ]),
            child: _buildData(),
          ),
        ],
      ),
    );
  }

  Widget _buildData() {
    ShowModel showModel = context.watch<PurchaseServiceLogistic>().showModel;
    if (showModel.data.isEmpty) {
      return const Center(
        child: Text("Error"),
      );
    }
    var item = showModel.data[0];
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Order Detail",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('PO Number', item.poNumber),
        _buildRowStatus('Status', item.poStatus),
        _buildFormRow('Create Date', item.createdDate),
        _buildFormRow('Create By', item.createdBy.name),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ViewPatenFileLogistic(title: 'View PO Reference', patenFileUrl: item.poFileUrl),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Customer Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Customer Name', item.customer.companyNameKh),
        _buildFormRow('Company Name', item.customer.companyNameEn),
        _buildFormRow('Phone Number', item.poTo.contactPhone1),
        _buildFormRow('Email', item.poTo.email ?? ""),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Delivery Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Contact', item.poTo.contactName),
        _buildFormRow('Phone Number', item.poTo.contactPhone1),
        _buildFormRow('Email', item.poTo.email ?? ""),
        _buildLocation('Location', widget.location),
        _buildFormRow('Delivery Method', item.deliveryMethod?.name ?? ''),
        _buildFormRow('Deliver By', item.driver ?? ''),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          margin: const EdgeInsets.all(10.0),
          width: double.infinity,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color.fromRGBO(89, 133, 245, 1),
          ),
          child: Center(
            child: TextButton(
              onPressed: () async {
                double? lat;
                double? log;
                try {
                  lat = double.parse(item.poDeliverAddress!.lat.toString());
                  'lat: $lat'.log();

                  log = double.parse(item.poDeliverAddress!.log.toString());
                  'log: $log'.log();
                } catch (e) {
                  'Lat-Log Error: $e'.log();
                }
                if (lat == null || log == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not view location'),
                    ),
                  );
                  return;
                }

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowPinLocation(
                      latitude: lat!,
                      longitude: log!,
                      currentAddress: item.poDeliverAddress?.street ?? '',
                    ),
                  ),
                );
              },
              child: const Text(
                'Show Pinned Location',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Deliver Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Payment Method', item.paymentMethod.name),
        _buildFormRow('Note', item.notes ?? ''),
      ],
    );
  }

  Widget _buildFormRow(String giveData, String valueData) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            giveData,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0XFF727272),
            ),
          ),
          Flexible(
            child: Text(
              valueData,
              style: const TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w500, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocation(String giveData, String valueData) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            giveData,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0XFF727272),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.08,
          ),
          Flexible(
            child: Text(
              valueData,
              style: const TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w500, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowStatus(String giveData, String valueData) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            giveData,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0XFF727272),
            ),
          ),
          Text(
            valueData,
            style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget _buildProduct() {
    ShowModel showModel = context.watch<PurchaseServiceLogistic>().showModel;
    if (showModel.data.isEmpty) {
      return const Center(
        child: Text("Error"),
      );
    }
    var item = showModel.data[0];
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: const Text(
              "Product",
              style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Column(
            children: List.generate(item.items.length, (index) {
              var pro = item.items[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(85, 75, 186, 0.14), offset: Offset(5.0, 5.0), blurRadius: 7.0, spreadRadius: 7.0),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(pro.product.name, style: const TextStyle(color: Colors.black)),
                                const SizedBox(height: 3),
                                Container(
                                    alignment: Alignment.centerLeft, child: Text(pro.package.label, style: const TextStyle(color: Colors.black))),
                                const SizedBox(height: 3),
                                Text(pro.product.desc.toString(), style: const TextStyle(color: Colors.black)),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(85, 75, 186, 0.14),
                                  offset: Offset(1.0, 2.0),
                                  blurRadius: 3.0,
                                  spreadRadius: 3.0,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                              ]),
                              child: Center(
                                child: Text(
                                  pro.quantity.toString(),
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    ShowModel showModel = context.watch<PurchaseServiceLogistic>().showModel;
    if (showModel.data.isEmpty) {
      return const Center(
        child: Text("Error"),
      );
    }
    var item = showModel.data[0];
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(85, 75, 186, 0.14),
                offset: Offset(1.0, 2.0),
                blurRadius: 3.0,
                spreadRadius: 3.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ]),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 0.6.h, bottom: 0.6.h),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Status History',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                _buildBoxItemProgress(progress: item.progress.progressNew),
                item.progress.inService == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: item.progress.inService!),
                item.progress.confirm == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: item.progress.confirm!),
                item.progress.control == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: item.progress.control!),
                item.progress.delivered == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: item.progress.delivered!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxItemProgress({required ProgressStatus progress}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.7.h),
      width: double.infinity,
      height: 7.8.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(85, 75, 186, 0.14),
          offset: Offset(
            0.5,
            3.0,
          ),
          blurRadius: 6.0,
          spreadRadius: 2.0,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progress.status,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.textColor),
                ),
                Text(
                  progress.date,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(52, 52, 52, 1)),
                )
              ],
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    text: 'Handle by ',
                    children: [
                      TextSpan(
                        text: progress.by,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
