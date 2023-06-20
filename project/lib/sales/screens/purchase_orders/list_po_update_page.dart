import 'package:flutter/material.dart';
import 'package:po_project/mains/utils/common.dart';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../mains/utils/logger.dart';
import '../../service/product_item_service.dart';
import '../../models/products_item.dart' as prod_item;

class ListPoUpdatePage extends StatefulWidget {
  const ListPoUpdatePage({
    super.key,
    required this.poNumber,
    required this.items,
  });
  final String poNumber;
  final List<prod_item.Data> items;

  @override
  State<ListPoUpdatePage> createState() => _ListPoUpdatePageState();
}

class _ListPoUpdatePageState extends State<ListPoUpdatePage> {
  /// immutable variables
  late final TextEditingController _searchCtrl;
  late final ProductItemService _productItemService;

  /// mutable variables
  List<prod_item.Data> _foundProducts = [];

  void _init() {
    // initialize late variables
    _searchCtrl = TextEditingController();
    _productItemService = context.read<ProductItemService>();
    // end initialize

    // working with async
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _productItemService.setLoading();
      await _productItemService.readProductList(context);
    });
    // end working
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar,
      bottomNavigationBar: _getButtonToEditProduct,
      body: _getBody,
    );
  }

  AppBar get _getAppBar {
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
        widget.poNumber,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.7.h),
          width: double.infinity,
          height: 5.5.h,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color.fromRGBO(164, 180, 220, 0.56),
              ),
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            onChanged: (value) {
              if (value.length >= 3) {
                _productItemService.setLoading();
                Future.delayed(const Duration(milliseconds: 500), () {}).then((_) {
                  _productItemService.readProductList(context, params: '&query=$value');
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
        ),
      ),
    );
  }

  Widget get _getButtonToEditProduct {
    return Container(
      margin: EdgeInsets.only(right: 1.7.h, left: 1.7.h, bottom: 1.h),
      height: 6.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
          Color.fromRGBO(67, 110, 220, 1),
          Color.fromRGBO(44, 54, 145, 1),
        ]),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Back To Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0XFFFFFFFF),
          ),
        ),
      ),
    );
  }

  Widget get _getBody {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  const Text(
                    'Sorting By Name',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.9)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_downward_outlined),
                  )
                ],
              ),
              _getListProducts,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _getListProducts {
    var loadingStatus = context.watch<ProductItemService>().loadingStatus;
    var carts = context.watch<ProductItemService>().productCartFromApi.data;
    if (loadingStatus == Loadingstatus.loading || carts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == Loadingstatus.error) {
      // Connection closed before full header was received (it look like the internet is slow)
      return Center(
        child: Text(
          _productItemService.errorMsg,
          textAlign: TextAlign.center,
        ),
      );
    }

    _foundProducts = _productItemService.productCartFromApi.data;
    if (_foundProducts.isNotEmpty) {
      for (var i = 0; i < _foundProducts.length; i++) {
        for (var j = 0; j < widget.items.length; j++) {
          if (_foundProducts[i].id == widget.items[j].id) {
            _foundProducts[i].isClickable = widget.items[j].isClickable;
            _foundProducts[i].isSelect = widget.items[j].isSelect;
            _foundProducts[i].packages = widget.items[j].packages;
            _foundProducts[i].price = widget.items[j].price;
            _foundProducts[i].total = widget.items[j].total;
          }
        }
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        _productItemService.setLoading();
        _productItemService.readProductList(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 0.5.h,
          top: 0.5.h,
          right: 0.5.h,
          bottom: 14.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            itemCount: _foundProducts.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return _buildProductData(
                item: _foundProducts[index],
                index: index,
                onTapped: () {
                  if (_foundProducts[index].isClickable) {
                    'before update product id: ${_foundProducts[index].id} --- selected:[${_foundProducts[index].isSelect}]'.log();

                    /// update UI
                    setState(() {
                      _foundProducts[index].isSelect = !_foundProducts[index].isSelect;
                    });

                    'after update product id: ${_foundProducts[index].id} --- selected:[${_foundProducts[index].isSelect}]'.log();

                    /// adding to the tmpListCartsUpdate
                    if (_foundProducts[index].isSelect) {
                      /// handle packages doesn't exists
                      if (_foundProducts[index].packages.isEmpty) {
                        alertMsg(context: context, msg: 'Please choose products with packages.');
                        _foundProducts[index].isSelect = false;
                        return;
                      }

                      if (_productItemService.tmpListCartsUpdate == null) {
                        _productItemService.setTmpListCartsUpdate([]);
                      }
                      _productItemService.tmpListCartsUpdate!.add(_foundProducts[index]);
                      'listCartUpdate: ${_productItemService.tmpListCartsUpdate}'.log();
                    }
                  }
                },
              );
            }),
      ),
    );
  }

  Widget _buildProductData({
    required prod_item.Data item,
    required int index,
    required VoidCallback onTapped,
  }) {
    List<prod_item.Package> packages = _foundProducts[index].packages;
    String subLabel = '';
    String subStock = '';
    String stock = '';
    if (packages.isNotEmpty) {
      final package = packages.firstWhere((element) => element.isDefault == 1);
      subLabel = '${package.label}';
      stock = 'Stock: ';
      subStock = '${package.stock}';
    }

    return GestureDetector(
      onTap: onTapped,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 7.0,
            spreadRadius: 0.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(2.0, 2.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ]),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: item.thumbUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(item.thumbUrl),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(
              color: Colors.transparent,
            ),
            errorWidget: (context, url, error) => const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ),
          title: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 0.5.h, top: 1.h),
            child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0XFF343434)),
            ),
          ),
          subtitle: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 0.5.h, top: 1.h),
            child: Row(
              children: [
                Text(
                  subLabel,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: stock,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
                    children: [
                      TextSpan(
                        text: subStock,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0XFF343434)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          trailing: _foundProducts[index].isSelect
              ? Container(
                  width: 19.93,
                  height: 20,
                  decoration:
                      BoxDecoration(border: Border.all(width: 2, color: const Color(0XFF979797)), shape: BoxShape.circle, color: AppColors.textColor),
                )
              : Container(
                  width: 19.93,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: const Color(0XFF979797)),
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }
}
