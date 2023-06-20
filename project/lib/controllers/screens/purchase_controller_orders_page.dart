import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/screens/po_detail.dart';
import '../../controllers/widgets/selected_fiterby.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../../drivers/widgets/delivery.dart';
import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';
import '../models/purchase_order_controller.dart';
import '../service/po_controller_service.dart';

class PurchaseOrderControllerPage extends StatefulWidget {
  const PurchaseOrderControllerPage({super.key});

  @override
  State<PurchaseOrderControllerPage> createState() => _PurchaseOrderControllerPageState();
}

class _PurchaseOrderControllerPageState extends State<PurchaseOrderControllerPage> {
  late final PoControllerService _poController;
  final TextEditingController _searchCtrl = TextEditingController();
  int _selected = -1;

  void _init() {
    '[List Purchase Orders] init...'.log();
    _poController = context.read<PoControllerService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _poController.setLoading();
      await _poController.readPoController(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _checkLoading,
    );
  }

  Widget get _checkLoading {
    Loadingstatus loadingStatus = context.watch<PoControllerService>().loadingstatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == Loadingstatus.error) {
      return Center(
        child: Text(_poController.errorMsg),
      );
    }
    return _buildBody();
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 0.5.h),
        child: Column(
          children: [
            SelectedFilterByController(
                selected: _selected,
                callBack: (value) {
                  if (value == 0) {
                    _poController.setLoading();
                    _poController.readPoController(context, params: '?status=delivery');
                  } else {
                    _poController.setLoading();
                    _poController.readPoController(context, params: '?status=confirm');
                  }
                  setState(() {
                    _selected = value;
                  });
                }),
            SizedBox(height: 1.5.h),
            _buildItem(),
          ],
        ),
      ),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Purchase Orders',
        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
        child: _buildFrmSearch(),
      ),
    );
  }

  Widget _buildFrmSearch() {
    return Container(
      margin: EdgeInsets.only(top: 1.h, left: 15, right: 15),
      height: 6.h,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: IndexColors.frmSearch),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildTextFieldfrm(),
    );
  }

  Widget _buildTextFieldfrm() {
    return TextField(
      onChanged: (value) {
        if (value.length >= 3) {
          _poController.setLoading();
          Future.delayed(const Duration(milliseconds: 500), () {}).then((_) {
            _poController.readPoController(context, params: '?query=$value');
          });
        }
      },
      controller: _searchCtrl,
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        prefixIcon: Icon(
          Icons.search,
          size: 24,
          color: AppColors.textColor,
        ),
        hintText: 'Search',
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.textColor),
      ),
    );
  }

  Widget _buildItem() {
    PurchaseOrderModelController purchaseOrderModelController = context.watch<PoControllerService>().poModelController;
    if (purchaseOrderModelController.data.isNotEmpty) {
      purchaseOrderModelController;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const Text(
            "No-Data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        _poController.setLoading();
        _selected = -1;
        await _poController.readPoController(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: purchaseOrderModelController.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var purchase = purchaseOrderModelController.data[index];
              return Padding(
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
                          purchase.street,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: List.generate(purchase.pos.length, (index) {
                            return DeliveryDriver(
                              poNumber: purchase.pos[index].poNumber,
                              edition: purchase.pos[index].poStatus,
                              dateTime: purchase.pos[index].createdDate,
                              name: purchase.pos[index].poTo.contactName,
                              phone: purchase.pos[index].poTo.contactPhone1,
                              delivery: purchase.pos[index].poDeliverAddress?.homeAddress ?? '',
                              details: () async {
                                if (purchase.pos[index].poStatus.toLowerCase() == 'confirm') {
                                  /// confirm case
                                  String? status = await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return PODetail(
                                        poNumber: purchase.pos[index].poNumber,
                                        poID: purchase.pos[index].id,
                                        createBy: purchase.pos[index].createdBy.name,
                                        homeaddress: purchase.pos[index].poDeliverAddress?.homeAddress ?? "",
                                        street: purchase.pos[index].poDeliverAddress?.street ?? "",
                                        sangkat: purchase.pos[index].poDeliverAddress?.sangkat.name ?? "",
                                        khan: purchase.pos[index].poDeliverAddress?.khan.name ?? "",
                                        province: purchase.pos[index].poDeliverAddress?.province.name ?? "",
                                      );
                                    }),
                                  );
                                  if (status == 'success 2') {
                                    'success 2...'.log();
                                    if (!mounted) return;
                                    _poController.setLoading();
                                    await _poController.readPoController(context);
                                  }
                                } else {
                                  /// others: do nothing
                                  // if (purchase.pos[index].poStatus == 'Delivered' || purchase.pos[index].poStatus == 'Delivery') {}
                                }
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
