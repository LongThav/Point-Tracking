import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'edit_cart_page.dart';
import '../../../mains/utils/logger.dart';
import '../../service/purchase_order_service.dart';
import '../../../mains/constants/colors.dart';
import '../../widgets/sales/product_list.dart';
import '../common/view_paten_file.dart';
import '../../../sales/models/purchase_order_sale_model.dart';
import '../../../mains/services/network/api_status.dart';
import '../common/show_pin_location.dart';
import 'edit_sale_page.dart';
import '../../../sales/widgets/common_block_row.dart';

class DetailSalePage extends StatefulWidget {
  const DetailSalePage({
    super.key,
    required this.purchaseOrderID,
    required this.purchaseOrderNumber,
    required this.totalPrice,
  });

  final int purchaseOrderID;
  final String purchaseOrderNumber;
  final int totalPrice;

  @override
  State<DetailSalePage> createState() => _DetailSalePageState();
}

class _DetailSalePageState extends State<DetailSalePage> with TickerProviderStateMixin {
  late TabController _tabController;
  Data? _purchaseOrder;
  bool _hideAddBtn = false;
  int _currentTab = 0;

  Future<void> _getSinglePO() async {
    var poSaleService = context.read<PoSaleService>();

    poSaleService.setLoading();
    await poSaleService.getSinglePO(context: context, poID: widget.purchaseOrderID);

    /// set loading to UI
    setState(() {
      _purchaseOrder = poSaleService.singlePurchaseOrder;
    });
  }

  void _init() async {
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSinglePO();
    });
  }

  @override
  void initState() {
    super.initState();
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
      appBar: _buildAppBar,
      body: SafeArea(
        child: Center(child: _buildBody),
      ),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
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
      title: Text(
        widget.purchaseOrderNumber,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
      ),
      titleSpacing: -13,
      actions: _hideAddBtn
          ? null
          : [
              IconButton(
                icon: const Icon(
                  Icons.edit_note,
                  color: AppColors.textColor,
                  size: 30,
                ),
                onPressed: () async {
                  'PO status:: ${_purchaseOrder!.poStatus}'.log();
                  'purchaseOrder: $_purchaseOrder!'.log();
                  if (_purchaseOrder!.poStatus == "New") {
                    if (_currentTab == 0) {
                      /// Update general
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return EditSalePage(
                          purchaseOrder: _purchaseOrder!,
                        );
                      }));
                    } else if (_currentTab == 1) {
                      /// udpate products
                      'total: ${_purchaseOrder!.total}'.log();
                      'products: ${_purchaseOrder!.items}'.log();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => EditCartPage(
                          purchaseOrderID: _purchaseOrder!.id,
                          purchaseOrderNumber: _purchaseOrder!.poNumber,
                          items: _purchaseOrder!.items,
                          totalPrice: widget.totalPrice,
                        ),
                      ));
                    }
                  } else {
                    "Can't Push Page".log();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't Edit this PO")));
                    return;
                  }
                },
              ),
            ],
      bottom: TabBar(
        indicatorColor: AppColors.textColor,
        indicatorWeight: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.textColor,
        labelPadding: EdgeInsets.only(bottom: 2.h),
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
        ],
        onTap: (tabNumber) async {
          'onTap change: $tabNumber'.log();
          // hints:
          // tab 0: General, tab 1: Product, tab 2: Progress
          // tab: 0 is profile tab, so disabled add action
          if (tabNumber == 0 || tabNumber == 1) {
            setState(() {
              _hideAddBtn = false;
              _currentTab = tabNumber;
            });
          } else {
            /// tab 2: Progress hide button edit
            setState(() {
              _hideAddBtn = true;
              _currentTab = tabNumber;
            });
          }
        },
      ),
    );
  }

  Widget get _buildBody {
    return Consumer<PoSaleService>(builder: (_, poService, __) {
      var status = poService.loadingStatus;
      if (status == Loadingstatus.loading) {
        return const CircularProgressIndicator.adaptive();
      } else if (status == Loadingstatus.error) {
        return Text(
          'Error: ${poService.errorMsg}',
          textAlign: TextAlign.center,
        );
      }

      _purchaseOrder = poService.singlePurchaseOrder;
      if (_purchaseOrder == null) {
        return Text('Error: ${widget.purchaseOrderNumber}');
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            _buildGeneral,
            _buildProduct,
            _buildProgress(),
          ],
        ),
      );
    });
  }

  /// General tab: 0
  Widget get _buildGeneral {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        margin: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(85, 75, 186, 0.14),
            offset: Offset(2.0, 2.0),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 1.7.h),
              child: const Text(
                'Order Detail',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'PO Number',
                rowValue: _purchaseOrder!.poNumber,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Status',
                rowValue: _purchaseOrder!.poStatus,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Create Date',
                rowValue: _purchaseOrder!.createdDate,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Create By',
                rowValue: _purchaseOrder!.createdBy?.name ?? '',
              ),
            ),
            SizedBox(height: 1.h),
            ViewPatenFile(title: 'View PO Reference', patenFileUrl: _purchaseOrder!.poFileUrl),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: const Text(
                'Customer Information',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF343434)),
              ),
            ),
            SizedBox(height: 1.7.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Company',
                rowValue: _purchaseOrder!.customer.companyNameEn,
              ),
            ),
            SizedBox(height: 1.7.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Contact',
                rowValue: _purchaseOrder!.poBy.contactName,
              ),
            ),
            SizedBox(height: 1.7.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Phone',
                rowValue: _purchaseOrder!.poBy.contactPhone1,
              ),
            ),
            SizedBox(height: 1.7.h),
            Padding(
              padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
              child: CommonBlockRow(
                rowText: 'Email',
                rowValue: _purchaseOrder!.poBy.email ?? '',
              ),
            ),
            SizedBox(height: 4.h),
            _deliverInfoSection,
          ],
        ),
      ),
    );
  }

  /// Product tab: 1
  Widget get _buildProduct {
    if (_purchaseOrder!.items.isEmpty) {
      return const Center(child: Text('No products'));
    }

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 1.7.h, horizontal: 0.5.h),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF343434)),
          ),
        ),
        ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _purchaseOrder!.items.length,
            itemBuilder: (context, index) {
              var item = _purchaseOrder!.items[index];
              return ProductList(
                productName: item.product.name,
                weight: item.package.label,
                productDescription: item.product.desc,
                total: item.quantity,
              );
            }),
        SizedBox(height: 1.h),
        _buildSummary,
        SizedBox(height: 2.h),
      ],
    );
  }

  /// Delivery Info Section
  Widget get _deliverInfoSection {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: const Text(
            'Delivery Information',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF343434)),
          ),
        ),
        SizedBox(height: 0.7.h),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Contact',
            rowValue: _purchaseOrder!.poTo.contactName,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Phone',
            rowValue: _purchaseOrder!.poTo.contactPhone1,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Email',
            rowValue: _purchaseOrder!.poTo.email ?? '',
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Location',
            rowValue: _purchaseOrder!.poDeliverAddress?.street ?? '',
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Delivery Method',
            rowValue: _purchaseOrder!.deliveryMethod?.name ?? '',
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Deliver By',
            rowValue: _purchaseOrder!.driver ?? '',
          ),
        ),
        SizedBox(height: 1.h),
        _buildShowPinLocation,
        SizedBox(height: 2.h),
        _otherInfo,
      ],
    );
  }

  /// Other Info
  Widget get _otherInfo {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: const Text(
            'Other Information',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF343434)),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: 'Payment Method',
            rowValue: _purchaseOrder!.paymentMethod?.name ?? '',
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
          child: CommonBlockRow(
            rowText: "Note",
            rowValue: _purchaseOrder!.driver ?? '',
          ),
        ),
      ],
    );
  }

  Widget get _buildShowPinLocation {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.h),
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
              lat = double.parse(_purchaseOrder!.poDeliverAddress!.lat.toString());
              'lat: $lat'.log();

              log = double.parse(_purchaseOrder!.poDeliverAddress!.log.toString());
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
                  currentAddress: _purchaseOrder!.poDeliverAddress?.street ?? '',
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
    );
  }

  Widget get _buildSummary {
    int totalItem = 0;
    for (int i = 0; i < _purchaseOrder!.items.length; i++) {
      try {
        totalItem += _purchaseOrder!.items[i].quantity;
      } catch (e) {
        return const Center(child: Text('Cannot get total item...'));
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.6.h),
      margin: EdgeInsets.symmetric(horizontal: 0.6.h),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(164, 156, 197, 0.25),
            offset: Offset(0.0, 1.0),
            blurRadius: 5.5,
            spreadRadius: 5.5,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            children: const [
              Text(
                "Summary",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF343434),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Item'),
              Text(
                totalItem.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sub Total'),
              Text(
                '\$${widget.totalPrice}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final boxWidth = constraints.constrainWidth();
                const dashWidth = 10.0;
                const dashHeight = 1.0;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: List.generate(dashCount, (_) {
                    return const SizedBox(
                      width: dashWidth,
                      height: dashHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total'),
              Text(
                '\$${widget.totalPrice}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    Progress progress = _purchaseOrder!.progress!;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 0.2.h,
            horizontal: 1.h,
          ),
          width: double.infinity,
          // height: 22.h,
          padding: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(85, 75, 186, 0.14),
              offset: Offset(
                5.0,
                5.0,
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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h, top: 2.h, bottom: 0.6.h),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Status History',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              _buildBoxItemProgress(progress: progress.progressNew),
              progress.inService == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: progress.inService!),
              progress.confirm == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: progress.confirm!),
              progress.control == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: progress.control!),
              progress.delivered == null ? const SizedBox.shrink() : _buildBoxItemProgress(progress: progress.delivered!),
            ],
          ),
        ),
      ],
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
