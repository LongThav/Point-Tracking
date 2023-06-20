import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/sales/product_list.dart';

class BuildProduct extends StatefulWidget {
  const BuildProduct({super.key});

  @override
  State<BuildProduct> createState() => _BuildProductState();
}

class _BuildProductState extends State<BuildProduct> {
  List dataProduct = [
    {
      "name": "Product Name",
      "weight": "Bag 40Kg",
      "total": 2,
      "description": "Product description ....",
    },
    {
      "name": "Product Name",
      "weight": "Bag 40Kg",
      "total": 2,
      "description": "Product description ....",
    },
    {
      "name": "Product Name",
      "weight": "Bag 40Kg",
      "total": 2,
      "description": "Product description ....",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 1.7.h),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0XFF343434)),
          ),
        ),
        _buildProductList(),
      ],
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 28.h,
      child: ListView.builder(
          itemCount: dataProduct.length,
          itemBuilder: (context, index) {
            return ProductList(
                productName: dataProduct[index]['name'],
                weight: dataProduct[index]['weight'],
                productDescription: dataProduct[index]['description'],
                total: dataProduct[index]['total'],
                callback: () {});
          }),
    );
  }
}
