import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/services/network/api_status.dart';
import '../../models/purchase_order_sale_model.dart';
import '../../service/purchase_order_service.dart';
import '../../../mains/constants/colors.dart';
import '../../../mains/constants/index_colors.dart';
import '../../widgets/sales/selected_filterby_sale.dart';
import '../../widgets/sales/widget_list.dart';
import 'detail_sale_page.dart';
import '../../../mains/utils/logger.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final TextEditingController _searchCtrl;
  late final PoSaleService _poSaleService;
  int _selected = -1;

  void _init() {
    _pageController = PageController();
    _searchCtrl = TextEditingController();
    _poSaleService = context.read<PoSaleService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _poSaleService.setLoading();
      await _poSaleService.readPOSale(context);
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
      body: _buildBody,
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

  Widget get _buildBody {
    Loadingstatus loadingStatus = context.watch<PoSaleService>().loadingStatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == Loadingstatus.error) {
      return Center(
        child: Text(_poSaleService.errorMsg),
      );
    } else {
      return _buildBodyContent;
    }
  }

  Widget get _buildBodyContent {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 0.5.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 1.7.h),
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter By',
                style: TextStyle(
                  color: IndexColors.blackcolor,
                  fontWeight: FontWeight.w500,
                  fontSize: 1.5.h,
                ),
              ),
            ),
            SelectedFilterBySale(
                selected: _selected,
                callBack: (value) {
                  if (value == 0) {
                    _poSaleService.setLoading();
                    _poSaleService.readPOSale(context, params: '?status=NEW');
                  } else if (value == 1) {
                    _poSaleService.setLoading();
                    _poSaleService.readPOSale(context, params: '?status=IN SERVICE');
                  } else if (value == 2) {
                    _poSaleService.setLoading();
                    _poSaleService.readPOSale(context, params: '?status=Delivery');
                  } else if (value == 3) {
                    _poSaleService.setLoading();
                    _poSaleService.readPOSale(context, params: '?status=Delivered');
                  } else {
                    _poSaleService.setLoading();
                    _poSaleService.readPOSale(context, params: '?status=Confirm');
                  }
                  setState(() {
                    _selected = value;
                  });
                }),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: PageView(
                reverse: true,
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
                children: [
                  _buildDataList(),
                  Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      const CircularProgressIndicator()
                    ],
                  )
                ],
              ),
            ),
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
      child: TextField(
        onChanged: (value) {
          if (value.length >= 3) {
            _poSaleService.setLoading();
            Future.delayed(const Duration(milliseconds: 500), () {}).then((_) {
              _poSaleService.readPOSale(context, params: '?query=$value');
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
      ),
    );
  }

  Widget _buildDataList() {
    PurchaseOrderSaleModel purchaseOrderSaleModel = context.watch<PoSaleService>().purchaseOrderSaleModel;
    if (purchaseOrderSaleModel.data.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const Text(
            "No data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        _poSaleService.setLoading();
        _selected = -1;
        await _poSaleService.readPOSale(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: purchaseOrderSaleModel.data.length,
          itemBuilder: (context, index) {
            var purchase = purchaseOrderSaleModel.data[index];
            var address = purchase.poDeliverAddress;
            String deliveryAddress =
                '${address?.homeAddress ?? ''} ${address?.street ?? ''} ${address?.sangkat?.name ?? ''} ${address?.khan?.name ?? ''} ${address?.province?.name ?? ''}';
            return ListDataofSale(
              id: purchase.poNumber,
              edition: purchase.poStatus,
              price: purchase.total,
              dateTime: purchase.createdDate,
              name: purchase.poTo.contactName,
              phone: purchase.poTo.contactPhone1,
              delivery: deliveryAddress,
              details: () {
                'on tapped -> po id: ${purchase.id}'.log();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    reverseTransitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DetailSalePage(
                        purchaseOrderID: purchase.id,
                        purchaseOrderNumber: purchase.poNumber,
                        totalPrice: purchase.total,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
