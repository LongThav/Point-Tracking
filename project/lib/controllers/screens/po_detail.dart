import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../mains/utils/logger.dart';
import '../../controllers/screens/confirm_delivery.dart';
import '../../mains/constants/colors.dart';
import '../../mains/services/network/api_status.dart';
import '../../sales/widgets/save_btn.dart';
import '../models/product_detail.dart';
import '../service/po_controller_service.dart';

class PODetail extends StatefulWidget {
  const PODetail({
    super.key,
    required this.poID,
    required this.poNumber,
    this.createBy,
    this.homeaddress,
    this.street,
    this.sangkat,
    this.khan,
    this.province,
  });

  final String? createBy;
  final String? homeaddress;
  final String? street;
  final String? sangkat;
  final String? khan;
  final String? province;
  final int poID;
  final String poNumber;

  @override
  State<PODetail> createState() => _PODetailState();
}

class _PODetailState extends State<PODetail> with TickerProviderStateMixin {
  late TabController _tabController;

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  _init() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<PoControllerService>().setLoading();
      await context.read<PoControllerService>().readDetailPoController(context, widget.poID);
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
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: -13,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.poNumber,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
          child: TabBar(
              onTap: (v) {},
              indicatorColor: AppColors.textColor,
              indicatorWeight: 2.0,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.textColor,
              labelPadding: const EdgeInsets.only(
                bottom: 10,
              ),
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
              ]),
        ),
      ),
      body: _buildBody,
    );
  }

  Widget get _buildBody {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _buildTabBarView(),
    );
  }

  Widget _buildTabBarView() {
    Loadingstatus loadingStatus = context.watch<PoControllerService>().loadingstatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == Loadingstatus.error) {
      return Center(
        child: Text(context.read<PoControllerService>().errorMsg),
      );
    }
    ProductDetailModel productDetailModel = context.read<PoControllerService>().productDetailModel;
    if (productDetailModel.data.isEmpty) {
      return const Center(
        child: Text('Error'),
      );
    }
    var data = productDetailModel.data[0];
    return TabBarView(controller: _tabController, children: [
      _buildGeneral(data),
      _buildItem(data),
    ]);
  }

  Widget _buildGeneral(Datum data) {
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
            child: _buildData(data),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SaveBtn(
                title: 'Confirm for Delivery',
                onPress: () async {
                  String? status = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                    var homeAddress = data.poDeliverAddress?.homeAddress ?? '';
                    var street = data.poDeliverAddress?.street ?? '';
                    var sangKat = data.poDeliverAddress?.sangkat.name ?? '';
                    var khan = data.poDeliverAddress?.khan.name ?? '';
                    var province = data.poDeliverAddress?.province.name ?? '';
                    return ConfirmDelivery(
                      poName: data.poNumber,
                      status: data.poStatus,
                      createBy: data.createdDate,
                      contact: data.poBy.contactName,
                      phone: data.poBy.contactPhone1,
                      delivery: '$homeAddress $street $sangKat $khan $province',
                      con_id: widget.poID,
                    );
                  }));
                  if (status == 'success 1') {
                    'success 1...'.log();
                    if (!mounted) return;
                    Navigator.of(context).pop('success 2');
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildData(Datum data) {
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
        _buildFormRow('PO Number', data.poNumber),
        _buildFormRow('Status', data.poStatus),
        _buildFormRow('Create Date', data.createdDate),
        _buildFormRow('Create By', widget.createBy.toString()),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Customer Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Company', data.customer.companyNameEn),
        _buildFormRow('Contact', data.poBy.contactName),
        _buildFormRow('Phone', data.poBy.contactPhone1),
        _buildFormRow('Email', data.poBy.email ?? ''),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Delivery Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Contact', data.poBy.contactName),
        _buildFormRow('Phone', data.poBy.contactPhone1),
        _buildFormRow('Email', data.poBy.email ?? ''),
        _buildFormRow(
            'Location  ',
            widget.homeaddress.toString() +
                widget.street.toString() +
                widget.sangkat.toString() +
                widget.khan.toString() +
                widget.province.toString()),
        _buildFormRow('Delivery Method', data.deliveryMethod?.name ?? ''),
        _buildFormRow('Deliver By', data.driver ?? ''),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: const Text(
            "Other Information",
            style: TextStyle(color: Color.fromRGBO(52, 52, 52, 1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
        _buildFormRow('Payment Method', data.paymentMethod.name),
        _buildFormRow('Note', data.notes ?? ''),
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

  Widget _buildItem(Datum data) {
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
            children: List.generate(data.items.length, (index) {
              var pro = data.items[index];
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SaveBtn(
                  title: 'Confirm Delivery',
                  onPress: () async {
                    String? status = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      var homeAddress = data.poDeliverAddress?.homeAddress ?? '';
                      var street = data.poDeliverAddress?.street ?? '';
                      var sangKat = data.poDeliverAddress?.sangkat.name ?? '';
                      var khan = data.poDeliverAddress?.khan.name ?? '';
                      var province = data.poDeliverAddress?.province.name ?? '';
                      return ConfirmDelivery(
                        poName: data.poNumber,
                        status: data.poStatus,
                        createBy: data.createdDate,
                        contact: data.poBy.contactName,
                        phone: data.poBy.contactPhone1,
                        delivery: '$homeAddress $street $sangKat $khan $province',
                        con_id: widget.poID,
                      );
                    }));

                    if (status == 'success 1') {
                      'success 1...'.log();
                      if (!mounted) return;
                      Navigator.of(context).pop('success 2');
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
