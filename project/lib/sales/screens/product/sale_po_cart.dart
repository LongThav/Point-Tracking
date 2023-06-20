import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/utils/logger.dart';
import '../../service/product_item_service.dart';
import '../../../mains/constants/colors.dart';
import '../../db/pocart_database.dart';
import '../../models/products_item.dart';
import '../../widgets/sales/po_cart_sale.dart';
import 'po_information_stepi.dart';
import '../../../mains/services/network/api_status.dart';

class SalePOCart extends StatefulWidget {
  const SalePOCart({super.key});

  @override
  State<SalePOCart> createState() => _SalePOCartState();
}

class _SalePOCartState extends State<SalePOCart> {
  late final ProductItemService _productItemService;
  List<Data> _productsCart = [];

  Future<void> init() async {
    '[Sale PO Cart init...]'.log();
    _productItemService = context.read<ProductItemService>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _productItemService.setLoading();

      // initialize database
      await POCARTDatabase.instance.database;

      await _productItemService.readFromLocalStorage();
      _productsCart = _productItemService.pocarts.data;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      backgroundColor: Colors.white,
      bottomNavigationBar: _productsCart.isEmpty ? null : _buildBottomNavigationBar,
      body: SafeArea(child: _buildBody),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Transform.translate(
        offset: const Offset(5, 0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      titleSpacing: -5,
      centerTitle: false,
      title: const Text(
        'PO Cart',
        style: TextStyle(
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget get _buildBottomNavigationBar {
    return GestureDetector(
      onTap: () async {
        var res = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => POInFormationStepI(
              listPO: _productsCart,
            ),
          ),
        );
        if (res == 'success_1') {
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 1.7.h, left: 1.7.h, bottom: 1.h),
        height: 6.5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
            Color.fromRGBO(67, 110, 220, 1),
            Color.fromRGBO(44, 54, 145, 1),
          ]),
        ),
        child: const Center(
          child: Text(
            'Create New Purchase Order',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0XFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildBody {
    var loadingStatus = context.watch<ProductItemService>().loadingStatus;
    switch (loadingStatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        return Center(
          child: Text(
            _productItemService.errorMsg,
            textAlign: TextAlign.center,
          ),
        );
      case Loadingstatus.complete:
        if (_productsCart.isEmpty) {
          return const Center(
            child: Text('No cart'),
          );
        }
        return ListView(
          children: [
            _buildCard(),
            _buildSummary(),
          ],
        );
    }
  }

  Widget _buildCard() {
    return ListView.builder(
        padding: EdgeInsets.all(1.h),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _productsCart.length,
        itemBuilder: (context, index) {
          var productCart = _productsCart[index];
          return Dismissible(
            key: Key(productCart.name),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                var res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          "Are you sure you want to delete ${productCart.name}?",
                          textAlign: TextAlign.center,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        buttonPadding: EdgeInsets.zero,
                        actions: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: EdgeInsets.zero, elevation: 0),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    // remove from local database
                                    context.read<ProductItemService>().deleteProductCart(productId: _productsCart[index].id);
                                    setState(() {
                                      _productsCart.removeWhere((product) => product.id == productCart.id);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                return res;
              }
              return null;
            },
            direction: DismissDirection.endToStart,
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            child: POCART(
              productCart: productCart,
              increment: () => context.read<ProductItemService>().incrementPOCART(context: context, selectedPOCART: productCart),
              decrement: () => context.read<ProductItemService>().decrementPOCART(context: context, selectedPOCART: productCart),
            ),
          );
        });
  }

  Widget _buildSummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.2.h),
      margin: EdgeInsets.all(1.2.h),
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
                '${context.watch<ProductItemService>().pocarts.totalItem}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sub Total'),
              Text(
                '\$${context.watch<ProductItemService>().pocarts.subTotal}',
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
                '\$${_productItemService.pocarts.subTotal}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget slideRightBackground() {
    'slideRightBackground....'.log();
    return Container(
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.textColor),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
