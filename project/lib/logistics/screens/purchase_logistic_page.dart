import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../logistics/screens/delivery_box.dart';
import '../../logistics/widgets/confirm_items.dart';
import '../../logistics/widgets/selected_filerby_logistic.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';
import '../models/po_model.dart';
import '../service/po_service.dart';

class PurchaseLogisticPage extends StatefulWidget {
  const PurchaseLogisticPage({super.key});

  @override
  State<PurchaseLogisticPage> createState() => _PurchaseLogisticPageState();
}

class _PurchaseLogisticPageState extends State<PurchaseLogisticPage> {
  TextEditingController searchCtrl = TextEditingController();
  PageController pageController = PageController();
  int selected = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PurchaseServiceLogistic>().setLoading();
      context.read<PurchaseServiceLogistic>().readPurchaseOrderLogistic(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: checkLoading(),
    );
  }

  Widget checkLoading() {
    Loadingstatus loadingstatus = context.watch<PurchaseServiceLogistic>().loadingstatus;
    if (loadingstatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingstatus == Loadingstatus.complete) {
      return _buildBody();
    } else {
      return Center(
        child: Text(context.read<PurchaseServiceLogistic>().errorMsg),
      );
    }
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
      onChanged: (value) async {
        if (value.length >= 3) {
          context.read<PurchaseServiceLogistic>().setLoading();
          await Future.delayed(const Duration(milliseconds: 500), () {});
          if (!mounted) return;
          await context.read<PurchaseServiceLogistic>().readPurchaseOrderLogistic(context, params: '?query=$value');
        }
      },
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

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SelectedFilterByLogistic(
                selected: selected,
                callBack: (int value) {
                  if (value == 0) {
                    context.read<PurchaseServiceLogistic>().setLoading();
                    context.read<PurchaseServiceLogistic>().readPurchaseOrderLogistic(context, params: '?status=in Service');
                  } else if (value == 1) {
                    context.read<PurchaseServiceLogistic>().setLoading();
                    context.read<PurchaseServiceLogistic>().readPurchaseOrderLogistic(context, params: '?status=confirm');
                  }
                  setState(() {
                    selected = value;
                  });
                }),
            SizedBox(
              height: 2.h,
            ),
            _buildItemData(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemData() {
    PurchaseOrderModelLogistic purchaseOrderModelLogistic = context.watch<PurchaseServiceLogistic>().purchaseOrderModelLOgistic;
    if (purchaseOrderModelLogistic.data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const Text(
            "No Data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      purchaseOrderModelLogistic;
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PurchaseServiceLogistic>().setLoading();
        selected = -1;
        await context.read<PurchaseServiceLogistic>().readPurchaseOrderLogistic(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView.builder(
          itemCount: purchaseOrderModelLogistic.data.length,
          itemBuilder: (context, index) {
            var puchase = purchaseOrderModelLogistic.data[index];
            var homeAddress = puchase.poDeliverAddress?.homeAddress ?? '';
            var street = puchase.poDeliverAddress?.street ?? '';
            var sangkat = puchase.poDeliverAddress?.sangkat.name ?? '';
            var khan = puchase.poDeliverAddress?.khan.name ?? '';
            var province = puchase.poDeliverAddress?.province.name ?? '';
            return ConfirmItems(
                poName: puchase.poNumber,
                edition: puchase.poStatus,
                dateTime: puchase.createdDate,
                name: puchase.poTo.contactName.toString(),
                phone: puchase.poTo.contactPhone1.toString(),
                delivery: '$homeAddress $street $sangkat $khan $province',
                details: () async {
                  if (puchase.poStatus == "Confirm") {
                    return;
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(name: "/deliveryBox"),
                            builder: (context) {
                              return DeliverBox(
                                index: index,
                                id: puchase.id,
                                location: '$homeAddress $street $sangkat $khan $province',
                                poNameId: puchase.poNumber,
                                poStatus: puchase.poStatus,
                                poDateTime: puchase.createdDate,
                                poName: puchase.poTo.contactName.toString(),
                                select: puchase.select,
                                poPhone: puchase.poTo.contactPhone1.toString(),
                                poDelivery: '$homeAddress $street $sangkat $khan $province',
                              );
                            }));
                  }
                });
          },
        ),
      ),
    );
  }
}
