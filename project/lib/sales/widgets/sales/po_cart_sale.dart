import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';
import '../../../mains/constants/index_colors.dart';
import '../../models/products_item.dart';
import '../../service/product_item_service.dart';
import '../../../mains/utils/logger.dart';

class POCART extends StatefulWidget {
  final Data productCart;
  final VoidCallback increment;
  final VoidCallback decrement;

  const POCART({
    super.key,
    required this.productCart,
    required this.increment,
    required this.decrement,
  });

  @override
  State<POCART> createState() => _POCARTState();
}

class _POCARTState extends State<POCART> {
  late final TextEditingController _priceCtrl;
  late double _priceFromApi;
  Package? _mainPackage;

  void _init() {
    _priceCtrl = TextEditingController(text: widget.productCart.price.toString());
    _priceFromApi = context.read<ProductItemService>().getPriceFromApi(widget.productCart.id);

    if (widget.productCart.packages.isNotEmpty) {
      _mainPackage = widget.productCart.packages.firstWhere((package) => package.isDefault == 1);
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(0.5.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(85, 75, 186, 0.14),
            offset: Offset(
              3.0,
              3.0,
            ),
            blurRadius: 5.0,
            spreadRadius: 3.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 1.h, top: 1.h),
            child: Text(
              widget.productCart.name,
              style: const TextStyle(color: IndexColors.boldName, fontWeight: FontWeight.w400, fontSize: 16, height: 1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selectOptions(),
                Container(
                  padding: EdgeInsets.only(right: 1.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 0.2.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: GestureDetector(
                          onTap: () {
                            if (_mainPackage == null || _mainPackage!.stock == 0 || widget.productCart.quantity <= 1) {
                              /// do nothing: because the quantity has reach limited
                            } else {
                              widget.decrement();
                            }
                          },
                          child: const Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.7.h),
                        padding: EdgeInsets.symmetric(horizontal: 2.5.h, vertical: 0.6.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: Text(
                          widget.productCart.quantity.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 0.2.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: GestureDetector(
                          onTap: () {
                            if (_mainPackage == null || _mainPackage!.stock == 0 || widget.productCart.quantity >= _mainPackage!.stock) {
                              /// do nothing: because the quantity has reach limited
                            } else {
                              widget.increment();
                            }
                          },
                          child: const Text(
                            '+',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 1.h, top: 1.h),
            child: const Text(
              'Price',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _priceCtrl,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixText: '\$',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price cannot be empty';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onEditingComplete: () {
                'onEditingComplete called...'.log();
                try {
                  var inputPrice = double.parse(_priceCtrl.text);
                  if (inputPrice < _priceFromApi) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Price cannot be lower than \$$_priceFromApi')));
                    _priceCtrl.text = _priceFromApi.toString();
                    widget.productCart.price = _priceFromApi;
                    widget.productCart.total = _priceFromApi;
                  } else {
                    widget.productCart.total = inputPrice;
                    widget.productCart.price = inputPrice;
                  }

                  context.read<ProductItemService>().updatePOCart(widget.productCart, quantity: widget.productCart.quantity);

                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                } catch (e) {
                  'error: $e'.log();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  '\$ ${context.watch<ProductItemService>().getPOCARTByID(widget.productCart.id).total}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectOptions() {
    var rows = List.generate(widget.productCart.packages.length, (index) {
      // check Stock available in packages
      var stock = widget.productCart.packages[index].stock;
      // CustomLog.instance.log('available stock ${widget.productCart.packages[index].label}: $stock');

      if (stock > 0) {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await context.read<ProductItemService>().onSelectedPackage(
                        context: context,
                        selectedPackage: widget.productCart.packages[index],
                        productCart: widget.productCart,
                        totalItem: context.read<ProductItemService>().pocarts.totalItem,
                        subTotal: context.read<ProductItemService>().pocarts.subTotal,
                      );
                },
                child: Container(
                  width: 19.93,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: const Color(0XFF979797)),
                    shape: BoxShape.circle,
                    color: widget.productCart.packages[index].isDefault == 1 ? AppColors.textColor : null,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 0.h, left: 10),
                child: Text(
                  '${widget.productCart.packages[index].label} (${widget.productCart.packages[index].stock})',
                  style: const TextStyle(color: IndexColors.boldName, fontWeight: FontWeight.w400, fontSize: 14, height: 1),
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
