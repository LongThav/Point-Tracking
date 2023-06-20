import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:camera/camera.dart';

import '../../mains/utils/logger.dart';
import '../../drivers/screens/camera_page.dart';
import '../../drivers/widgets/delivery.dart';
import '../../drivers/widgets/selected_filter_by.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';
import '../models/purchase_order_driver.dart';
import '../service/purchase_order_service.dart';

class PurchaseDriverPage extends StatefulWidget {
  const PurchaseDriverPage({super.key});

  @override
  State<PurchaseDriverPage> createState() => _PurchaseDriverPageState();
}

class _PurchaseDriverPageState extends State<PurchaseDriverPage> {
  late final TextEditingController _searchCtrl;
  late final PurchaseOrderDriverService _driverService;
  int selected = -1;
  List<PurchasOrder> _purchaseOrder = [];

  init() {
    '[Purchase Page] init...'.log();
    _searchCtrl = TextEditingController();
    _driverService = context.read<PurchaseOrderDriverService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _driverService.setLoading();
      await _driverService.readPODriver(context);
      _purchaseOrder = _driverService.purchaseOrderModelDriver.data;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
      body: checkStatus(),
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

  Widget checkStatus() {
    Loadingstatus loadingStatus = context.watch<PurchaseOrderDriverService>().loadingstatus;
    switch (loadingStatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        return Center(
          child: Text(context.read<PurchaseOrderDriverService>().errorMsg),
        );
      case Loadingstatus.complete:
        return _buildBody;
    }
  }

  Widget get _buildBody {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 0.5.h),
        child: Column(
          children: [
            SelectedFilterByDriver(
                selected: selected,
                callBack: (value) async {
                  if (value == 0) {
                    _driverService.setLoading();
                    await _driverService.readPODriver(context, params: '?status=delivery');
                    _purchaseOrder = _driverService.purchaseOrderModelDriver.data;
                  } else {
                    _driverService.setLoading();
                    await _driverService.readPODriver(context, params: '?status=delivered');
                    _purchaseOrder = _driverService.purchaseOrderModelDriver.data;
                  }
                  setState(() {
                    selected = value;
                  });
                }),
            SizedBox(
              height: 2.h,
            ),
            _buildListData(),
          ],
        ),
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
      child: _buildTextFieldForm(),
    );
  }

  Widget _buildTextFieldForm() {
    return TextField(
      onChanged: (value) async {
        if (value.length >= 3) {
          _driverService.setLoading();
          Future.delayed(const Duration(milliseconds: 500), () {}).then((_) {
            context.read<PurchaseOrderDriverService>().readPODriver(context, params: '?query=$value').then((_) {
              setState(() {
                _purchaseOrder = _driverService.purchaseOrderModelDriver.data;
              });
            });
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

  Widget _buildListData() {
    var loadingStatus = context.watch<PurchaseOrderDriverService>().loadingstatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    setState(() {
      _purchaseOrder = _driverService.purchaseOrderModelDriver.data;
    });

    if (_purchaseOrder.isNotEmpty) {
      _purchaseOrder;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const Text(
            "Use: No data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        _driverService.setLoading();
        selected = -1;
        await _driverService.readPODriver(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView.builder(
            itemCount: _purchaseOrder.length,
            itemBuilder: (context, index) {
              var purchase = _purchaseOrder[index];
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
                    border: Border.all(
                      width: 1,
                      color: const Color(0XFFB1BFE1),
                    ),
                  ),
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
                              name: purchase.pos[index].poTo?.contactName ?? '',
                              phone: purchase.pos[index].poTo?.contactPhone1 ?? '',
                              delivery: purchase.pos[index].poDeliverAddress?.homeAddress ?? '',
                              details: () async {
                                if (purchase.pos[index].poStatus.toLowerCase() == 'delivery') {
                                  var cameras = await availableCameras();
                                  if (!mounted) return;
                                  String? status = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraPage(
                                        id: purchase.pos[index].id,
                                        poNumber: purchase.pos[index].poNumber,
                                        cameras: cameras,
                                      ),
                                    ),
                                  );
                                  if (status == 'success 2') {
                                    'success 2'.log();
                                    _driverService.setLoading();
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    if (!mounted) return;
                                    await _driverService.readPODriver(context);
                                  }
                                } else {
                                  /// do nothing
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
