import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'sale_po_cart.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../mains/constants/colors.dart';
import '../../models/products_item.dart';
import '../../service/product_item_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  late ProductItemService _productItemService;

  List<Data> _foundProducts = [];
  final List<Data> _tmpSelectedProducts = [];

  void init() {
    _productItemService = context.read<ProductItemService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _productItemService.setLoading();
      _foundProducts = _productItemService.productCartFromApi.data;
      await _productItemService.readProductList(context);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
      backgroundColor: Colors.white,
      elevation: 0.0,
      leadingWidth: MediaQuery.of(context).size.width * 0.28,
      leading: Padding(
        padding: EdgeInsets.only(left: 0.h, top: 1.h),
        child: const Center(
          child: Text(
            "Product",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 1.5.h,
        ),
        IconButton(
          onPressed: () async {
            // tapped go to cart screen
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SalePOCart();
            }));
            // back to product lists
            _productItemService.setLoading();
            await Future.delayed(const Duration(milliseconds: 100), () {});
            if (!mounted) return;
            await _productItemService.readProductList(context);
            setState(() {
              _foundProducts = _productItemService.productCartFromApi.data;
            });
          },
          icon: const Icon(
            BootstrapIcons.cart_fill,
            color: AppColors.textColor,
            size: 30,
          ),
        ),
      ],
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
          child: _buildTextFieldForm,
        ),
      ),
    );
  }

  Widget get _buildTextFieldForm {
    return TextField(
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
    );
  }

  Widget get _buildBody {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            _buildShowListProduct,
          ],
        ),
      ),
    );
  }

  Widget get _buildShowListProduct {
    Loadingstatus loadingStatus = context.watch<ProductItemService>().loadingStatus;
    switch (loadingStatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        // Connection closed before full header was received (it look like the internet is slow)
        return Center(
          child: Text(
            context.read<ProductItemService>().errorMsg,
            textAlign: TextAlign.center,
          ),
        );
      case Loadingstatus.complete:
        return _buildProductList;
    }
  }

  Widget get _buildProductList {
    _foundProducts = context.watch<ProductItemService>().productCartFromApi.data;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductItemService>().setLoading();
        context.read<ProductItemService>().readProductList(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 0.5.h,
          top: 0.5.h,
          right: 0.5.h,
          bottom: 14.h,
        ),
        // color: const Color.fromRGBO(164, 180, 220, 0.56),
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
                _foundProducts[index],
                index,
              );
            }),
      ),
    );
  }

  Widget _buildProductData(Data item, int index) {
    List<Package> packages = _foundProducts[index].packages;
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
      onTap: () async {
        // update UI
        setState(() {
          _foundProducts[index].isSelect = !_foundProducts[index].isSelect;
        });

        if (_foundProducts[index].isSelect) {
          int packageId = 0;
          if (_foundProducts[index].packages.isNotEmpty) {
            packageId = _foundProducts[index].packages.firstWhere((package) => package.isDefault == 1).id;
          }
          await _productItemService.addProductToCart(
            newProduct: _foundProducts[index],
            packageId: packageId,
          );
        } else {
          await _productItemService.deleteProductCart(productId: _foundProducts[index].id);
        }

        _tmpSelectedProducts.add(_foundProducts[index]);
      },
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
                  subLabel, // isDefault
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
        // child: Column(
        //   children: [
        //     Container(
        //       alignment: Alignment.centerLeft,
        //       padding: EdgeInsets.only(left: 1.7.h, top: 1.3.h),
        //       child: Text(
        //         item.name,
        //         style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0XFF343434)),
        //       ),
        //     ),
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             subLabel, // isDefault
        //             style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
        //           ),
        //           RichText(
        //             textAlign: TextAlign.end,
        //             text: TextSpan(
        //               text: stock,
        //               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
        //               children: [
        //                 TextSpan(
        //                   text: subStock,
        //                   style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0XFF343434)),
        //                 ),
        //                 // TextSpan(
        //                 //   text: subStock,
        //                 //   style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
        //                 // )
        //               ],
        //             ),
        //           ),
        //           SizedBox(width: MediaQuery.of(context).size.width * 0.22),
        //           _foundProducts[index].isSelect
        //               ? Container(
        //                   width: 19.93,
        //                   height: 20,
        //                   decoration: BoxDecoration(border: Border.all(width: 2, color: const Color(0XFF979797)), shape: BoxShape.circle, color: AppColors.textColor),
        //                 )
        //               : Container(
        //                   width: 19.93,
        //                   height: 20,
        //                   decoration: BoxDecoration(
        //                     border: Border.all(width: 2, color: const Color(0XFF979797)),
        //                     shape: BoxShape.circle,
        //                   ),
        //                 ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       alignment: Alignment.centerLeft,
        //       padding: EdgeInsets.only(left: 1.7.h, top: 0.h),
        //       child: Text(
        //         item.notes,
        //         style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF979797)),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
