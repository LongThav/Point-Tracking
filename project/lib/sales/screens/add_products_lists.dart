import 'package:flutter/material.dart';
import 'package:po_project/sales/widgets/next_btn.dart';
import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';
import '../models/product_list.dart';

class AddProductsList extends StatefulWidget {
  const AddProductsList({super.key});

  @override
  State<AddProductsList> createState() => _AddProductsListState();
}

class _AddProductsListState extends State<AddProductsList> {
  TextEditingController searchCtrl = TextEditingController();
  List<ProductListNotfication> products = [
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
    ProductListNotfication(
        'Product Name', 'Bag 40Kg', 'Product description ....', false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
      bottomNavigationBar: _buildBottomNavigationBar,
    );
  }

  get _buildBody {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
        ),
        child: Column(
          children: [
            _buildAppBar(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1.7.h),
              width: double.infinity,
              height: 5.5.h,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromRGBO(164, 180, 220, 0.56),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: _buildTextFieldfrm(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1.7.h),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text(
                    'Sorting By Name',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromRGBO(0, 0, 0, 0.9)),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_drop_down_rounded))
                ],
              ),
            ),
            _buildShowListProduct(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textColor,
            )),
        const Text(
          'Add Product For POID123451 ',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: AppColors.textColor),
        ),
      ],
    );
  }

  Widget _buildTextFieldfrm() {
    return TextField(
      controller: searchCtrl,
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
        hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.textColor),
      ),
    );
  }

  Widget _buildShowListProduct() {
    return Container(
      padding: EdgeInsets.only(left: 0.5.h, top: 0.5.h, right: 0.5.h),
      height: 80.h,
      child: ListView.builder(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          itemCount: products.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return _buildProductData(
                products[index].product,
                products[index].weight,
                products[index].description,
                products[index].isSelect,
                index);
          }),
    );
  }

  Widget _buildProductData(String product, String weight, String description,
      bool isSelect, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          products[index].isSelect = !products[index].isSelect;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        width: double.infinity,
        height: 8.3.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(85, 75, 186, 0.14),
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 7.0,
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
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 1.7.h, top: 1.3.h),
              child: Text(
                product,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0XFF343434)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.7.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weight,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0XFF343434)),
                  ),
                  isSelect
                      ? Container(
                          width: 19.93,
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: const Color(0XFF979797)),
                              shape: BoxShape.circle,
                              color: AppColors.textColor),
                        )
                      : Container(
                          width: 19.93,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: const Color(0XFF979797)),
                            shape: BoxShape.circle,
                          ),
                        ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 1.7.h, top: 0.h),
              child: Text(
                description,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0XFF979797)),
              ),
            )
          ],
        ),
      ),
    );
  }

  get _buildBottomNavigationBar {
    return NextButton(title: 'Back to Edit Product', onPress: () {});
  }
}
