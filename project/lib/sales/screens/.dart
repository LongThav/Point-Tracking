import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';
import '../widgets/sales/selected_filterby_sale.dart';
import '../widgets/sales/widget_list.dart';
import 'detail_sale_page.dart';

class OrderSalePage extends StatefulWidget {
  const OrderSalePage({super.key});

  @override
  State<OrderSalePage> createState() => _OrderSalePageState();
}

class _OrderSalePageState extends State<OrderSalePage>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  // late TabController _tabController;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 2, vsync: this);
  //   // _tabController.animateTo(2);
  // }

  PageController pageController = PageController();
  int selected = 0;
  List data = [
    {
      "po_id": "POID83729",
      "edition": "New",
      "price": "\$ 2,300",
      "date": "26/12/2022",
      "contact": "name",
      "phone": "85513245679",
      "Delivery": "City Center Boulevard Phnom Penh"
    },
    {
      "po_id": "POID83729",
      "edition": "New",
      "price": "\$ 2,300",
      "date": "26/12/2022",
      "contact": "name",
      "phone": "85513245679",
      "Delivery": "City Center Boulevard Phnom Penh"
    },
    {
      "po_id": "POID83729",
      "edition": "New",
      "price": "\$ 2,300",
      "date": "26/12/2022",
      "contact": "name",
      "phone": "85513245679",
      "Delivery": "City Center Boulevard Phnom Penh"
    },
    {
      "po_id": "POID83729",
      "edition": "New",
      "price": "\$ 2,300",
      "date": "26/12/2022",
      "contact": "name",
      "phone": "85513245679",
      "Delivery": "City Center Boulevard Phnom Penh"
    },
    {
      "po_id": "POID83729",
      "edition": "In service",
      "price": "\$ 2,300",
      "date": "26/12/2022",
      "contact": "name",
      "phone": "85513245679",
      "Delivery": "City Center Boulevard Phnom Penh"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
    );
  }

  get _buildBody {
    return SafeArea(
      child: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 0.5.h),
        child: Column(
          children: [
            _buildAppBar(),
            _buildFrmSearch(),
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
                )),
            SelectedFilterBySale(
              callBack: (int value) {
                setState(() {
                  selected = value;
                });
                // pageController.jumpToPage(value);
              },
              selected: selected,
            ),
            SizedBox(
              height: 2.h,
            ),
            _buildDataList(),
            // PageView(
            //   scrollDirection: Axis.horizontal,
            //   controller: pageController,
            //   onPageChanged: (value){
            //     setState(() {
            //       selected = value;
            //     });
            //   },
            //   children: [
            //     Container(
            //       width: 200,
            //       height: 200,
            //       color: Colors.red,
            //     ),
            //     Container(
            //       width: 200,
            //       height: 200,
            //       color: Colors.yellow,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Purchase Orders',
          style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 22),
        ),
        _buildIcon(),
      ],
    );
  }

  Widget _buildIcon() {
    return Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: AppColors.textColor,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message_outlined,
              size: 30,
              color: AppColors.textColor,
            )),
      ],
    );
  }

  Widget _buildFrmSearch() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      width: 100.h,
      height: 6.h,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: IndexColors.frmSearch),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildTextFieldfrm(),
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

  Widget _buildDataList() {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListDataofSale(
              id: data[index]['po_id'],
              edition: data[index]['edition'],
              price: data[index]['price'],
              dateTime: data[index]['date'],
              name: data[index]['contact'],
              phone: data[index]['phone'],
              delivery: data[index]['Delivery'],
              details: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 200),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DetailSalePage(
                        id: data[index]['po_id'],
                        edition: data[index]['edition'],
                        price: data[index]['price'],
                        dateTime: data[index]['date'],
                        name: data[index]['contact'],
                        phone: data[index]['phone'],
                        delivery: data[index]['Delivery'],
                      );
                    }));
              },
            );
          }),
    );
  }
}
