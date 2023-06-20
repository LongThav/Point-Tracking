import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/utils/logger.dart';
import '../../../mains/constants/colors.dart';
import '../../../mains/constants/index_colors.dart';
import '../../../sales/models/purchase_order_sale_model.dart' as purchase;
import '../../models/products_item.dart' as prod_items;
import '../../../sales/screens/purchase_orders/list_po_update_page.dart';
import '../../../mains/utils/common.dart';
import '../../../sales/service/product_item_service.dart';
import '../../../mains/services/network/api_status.dart';
import '../../service/customer_service.dart';
import '../../service/purchase_order_service.dart';
import '../../widgets/next_btn.dart';

class EditCartPage extends StatefulWidget {
  const EditCartPage({
    super.key,
    required this.purchaseOrderID,
    required this.purchaseOrderNumber,
    required this.items,
    required this.totalPrice,
  });

  final int purchaseOrderID;
  final String purchaseOrderNumber;
  final List<purchase.Item> items;
  final int totalPrice;

  @override
  State<EditCartPage> createState() => _EditCartPageState();
}

class _EditCartPageState extends State<EditCartPage> {
  late final CustomerService _customerService;
  late final ProductItemService _productItemService;

  /// Convert purchase orders to list carts of Data class
  List<prod_items.Data> _listCarts = [];

  void _init() {
    _customerService = context.read<CustomerService>();
    _productItemService = context.read<ProductItemService>();
    prod_items.Data item;
    prod_items.Package package;
    for (var i = 0; i < widget.items.length; i++) {
      package = prod_items.Package(
        isDefault: 1,
        id: widget.items[i].package.id,
        label: widget.items[i].package.label,
        stock: widget.items[i].product.stock,
      );
      item = prod_items.Data(
        id: widget.items[i].product.id,
        name: widget.items[i].product.name,
        packages: [
          package,
        ],
        isSelect: true,
        isClickable: false,
        quantity: widget.items[i].quantity,
        price: widget.items[i].price,
        stock: widget.items[i].product.stock,
        total: widget.items[i].price * widget.items[i].quantity,
      );

      _listCarts = [..._listCarts, item];
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    /// remove tmpListCartsUpdate
    if (_productItemService.tmpListCartsUpdate != null) {
      _productItemService.setTmpListCartsUpdate(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      bottomNavigationBar: _buildBottomNavigationBar,
      body: _buildBody,
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
      actions: [
        IconButton(
          onPressed: () async {
            /// Everytimes go to list updates product list - remove old data
            _productItemService.setTmpListCartsUpdate([]);

            /// Go to screen “List Products”.
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (_) => ListPoUpdatePage(
                poNumber: widget.purchaseOrderNumber,
                items: _listCarts,
              ),
            ))
                .then((_) async {
              // back to edit carts list
              _productItemService.setLoading();
              await Future.delayed(const Duration(seconds: 2), () {});
              var carts = await _productItemService.getTmpUpdateListCarts();
              if (carts != null && carts.isNotEmpty) {
                setState(() {
                  _listCarts = [..._listCarts, ...carts];
                });
              }
            });
          },
          icon: const Icon(
            Icons.add,
            color: AppColors.textColor,
          ),
        )
      ],
    );
  }

  Widget get _buildBottomNavigationBar {
    var loadingStatus = context.watch<CustomerService>().loadingStatus;
    var isLoading = loadingStatus == Loadingstatus.loading;
    var errorMsg = _customerService.errorMsg;
    if (errorMsg.isNotEmpty) {
      return Text('Error:: $errorMsg');
    }

    return NextButton(
        loading: isLoading,
        title: 'Save',
        onPress: () async {
          /// handle no carts
          if (_listCarts.isEmpty) {
            alertMsg(context: context, msg: 'There are no carts, cannot update.');
            return;
          }

          var postData = <String, dynamic>{};
          postData['products'] = <Map<String, dynamic>>[];

          prod_items.Package package;
          for (int i = 0; i < _listCarts.length; i++) {
            if (_listCarts[i].packages.isEmpty) {
              continue;
            }
            package = _listCarts[i].packages.firstWhere((package) => package.isDefault == 1);
            postData['products'].add({
              "product_id": _listCarts[i].id,
              "quantity": _listCarts[i].quantity,
              "product_package_id": package.id,
              "price": _listCarts[i].price,
            });
          }

          _customerService.setLoadingCustomerService();
          // await Future.delayed(const Duration(milliseconds: 500), () {});
          if (!mounted) return;
          _customerService.updateProducts(context: context, postData: postData, poID: widget.purchaseOrderID).then(
            (res) {
              if (res) {
                alertMsg(context: context, msg: 'update success...', seconds: 1).then((_) {
                  /// handle callback
                  onUpdateSuccess(
                      context: context,
                      callbackAction: () async {
                        context.read<PoSaleService>().setLoading();
                        await context.read<PoSaleService>().getSinglePO(context: context, poID: widget.purchaseOrderID);
                      });
                });
              } else {
                alertMsg(context: context, msg: 'update failed...');
              }
            },
          );
        });
  }

  Widget get _buildBody {
    var loading = context.watch<ProductItemService>().loadingStatus;
    if (loading == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: [
        ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _listCarts.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(_listCarts[index].name),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    var res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              "Are you sure you want to delete ${_listCarts[index].name}?",
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
                                        setState(() {
                                          _listCarts.removeWhere((product) => product.id == _listCarts[index].id);
                                        });

                                        /// remove from temporary lists cart update
                                        if (_productItemService.tmpListCartsUpdate != null && _productItemService.tmpListCartsUpdate!.isNotEmpty) {
                                          _productItemService.tmpListCartsUpdate!.removeWhere((product) => product.id == _listCarts[index].id);
                                        }
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
                child: EditCardItem(
                  item: _listCarts[index],
                  onDecrementTap: () {
                    if (_listCarts[index].stock > 1 && _listCarts[index].quantity > 1) {
                      setState(() {
                        /// update quantity
                        _listCarts[index].quantity--;

                        /// update total
                        _listCarts[index].total = _listCarts[index].price * _listCarts[index].quantity;
                      });

                      'decrement update quantity: [${_listCarts[index].quantity}]'.log();
                      'decrement update total: [${_listCarts[index].total}]'.log();
                    }
                  },
                  onIncrementTap: () {
                    if (_listCarts[index].stock > 1 && _listCarts[index].quantity < _listCarts[index].stock) {
                      setState(() {
                        /// update quantity
                        _listCarts[index].quantity++;

                        /// update total
                        _listCarts[index].total = _listCarts[index].price * _listCarts[index].quantity;
                      });

                      'increment update quantity: [${_listCarts[index].quantity}]'.log();
                      'increment update total: [${_listCarts[index].total}]'.log();
                    }
                  },
                  onPriceChangeTap: (oldPrice, newPrice) {
                    if (newPrice >= oldPrice) {
                      'onPriceChangeTap old price: [$oldPrice] -- newPrice[$newPrice]'.log();

                      setState(() {
                        /// update price
                        _listCarts[index].price = newPrice;

                        /// update total
                        _listCarts[index].total = newPrice * _listCarts[index].quantity;
                      });

                      'onPriceChangeTap update price: [${_listCarts[index].price}]'.log();
                      'onPriceChangeTap update total: [${_listCarts[index].total}]'.log();
                    }
                  },
                  onSelectPackageChange: (selectedPackage) {
                    prod_items.Package package;
                    for (int i = 0; i < _listCarts[index].packages.length; i++) {
                      package = _listCarts[index].packages[i];
                      if (package.id == selectedPackage.id) {
                        _listCarts[index].packages[i].isDefault = 1;
                      } else {
                        _listCarts[index].packages[i].isDefault = 0;
                      }
                    }
                    // Rebuild-UI
                    setState(() {});
                  },
                ),
              );
            }),
        SizedBox(height: 1.h),
        _buildSummary,
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget get _buildSummary {
    if (_listCarts.isEmpty) {
      return const Center(
        child: Text(
          'No carts',
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      );
    }

    int totalItem = 0;

    /// price from api (close for temporary)
    // double totalPrice = widget.totalPrice.toDouble();
    double totalPrice = 0;
    for (int i = 0; i < _listCarts.length; i++) {
      try {
        /// update total items
        totalItem += _listCarts[i].quantity;

        /// update total prices
        totalPrice += _listCarts[i].total;
      } catch (e) {
        return const Center(child: Text('Cannot get total item...'));
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.6.h),
      margin: EdgeInsets.symmetric(horizontal: 1.h),
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
                '\$$totalPrice',
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
                '\$$totalPrice',
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

class EditCardItem extends StatefulWidget {
  const EditCardItem({
    super.key,
    required this.item,
    required this.onDecrementTap,
    required this.onIncrementTap,
    required this.onPriceChangeTap,
    required this.onSelectPackageChange,
  });
  final prod_items.Data item;
  final VoidCallback onDecrementTap;
  final VoidCallback onIncrementTap;
  final void Function(double oldPrice, double priceUpdate) onPriceChangeTap;
  final void Function(prod_items.Package selectedPackage) onSelectPackageChange;

  @override
  State<EditCardItem> createState() => _EditCardItemState();
}

class _EditCardItemState extends State<EditCardItem> {
  /// declaration states
  late final TextEditingController _priceCtr;
  late final double _originalPrice;

  void _init() {
    _originalPrice = widget.item.price;
    _priceCtr = TextEditingController(text: _originalPrice.toString());
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _priceCtr.dispose();
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
            offset: Offset(3.0, 3.0),
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
              widget.item.name,
              style: const TextStyle(color: IndexColors.boldName, fontWeight: FontWeight.w400, fontSize: 16, height: 1),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _selectOptions,
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
                            if (widget.item.stock == 0 || widget.item.quantity <= 1) {
                              /// do nothing: because the quantity has reach limited
                            } else {
                              widget.onDecrementTap();
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
                            offset: Offset(3.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(color: Colors.white, offset: Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0),
                        ]),
                        child: Text(
                          widget.item.quantity.toString(),
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
                            if (widget.item.stock == 0 || widget.item.quantity >= widget.item.stock) {
                              /// do nothing: because the quantity has reach limited
                            } else {
                              widget.onIncrementTap();
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
              controller: _priceCtr,
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
                  var inputPrice = double.parse(_priceCtr.text);
                  if (inputPrice < _originalPrice) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Price cannot be lower than \$${widget.item.price}')));
                    setState(() {
                      _priceCtr.text = widget.item.price.toString();
                    });
                  }
                  var priceUpdate = double.tryParse(_priceCtr.text) ?? 0;
                  widget.onPriceChangeTap(_originalPrice, priceUpdate);

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
                  "\$${widget.item.total}",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _selectOptions {
    'total packages:: ${widget.item.packages.length}'.log();
    var rows = List.generate(widget.item.packages.length, (index) {
      // check Stock available in packages
      var stock = widget.item.packages[index].stock;
      'total stock:: $stock'.log();

      if (stock > 0) {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  widget.onSelectPackageChange(widget.item.packages[index]);
                  'selected package -- id: [${widget.item.packages[index].id}]'.log();
                  'selected package -- label: [${widget.item.packages[index].label}]'.log();
                },
                child: Container(
                  width: 19.93,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: const Color(0XFF979797)),
                    shape: BoxShape.circle,
                    color: widget.item.packages[index].isDefault == 1 ? AppColors.textColor : null,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 0.h, left: 10),
                child: Text(
                  '${widget.item.packages[index].label} (${widget.item.packages[index].stock})',
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
