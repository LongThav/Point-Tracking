import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../mains/utils/logger.dart';
import '../../../mains/constants/index_colors.dart';
import '../../models/customer_model.dart';
import '../../service/customer_service.dart';
import '../../widgets/sales/person_list.dart';
import 'add_customer.dart';
import 'detail_customer_page.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  TextEditingController searchCtrl = TextEditingController();
  late final CustomerModel _customerModel;
  List<Customer> _foundCustomer = [];

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CustomerService>().setLoadingCustomerService();

      /// readCustomerService is a Future request to network
      /// so required to wait it finished first before call next instruction
      await context.read<CustomerService>().readCustomerService(context);
      if (!mounted) return;
      _customerModel = context.read<CustomerService>().customerModel;
      _foundCustomer = _customerModel.data;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Customer> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _customerModel.data;
    } else {
      results = _customerModel.data.where((item) => item.fullName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundCustomer = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
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
      elevation: 0.0,
      backgroundColor: Colors.white,
      leadingWidth: MediaQuery.of(context).size.width * 0.31,
      leading: Padding(
        padding: EdgeInsets.only(left: 0.h, top: 1.h),
        child: const Center(
          child: Text(
            "Customer",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        ),
        IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddCustomer();
              }));
              setState(() {});
            },
            icon: const Icon(
              Icons.person_add_alt_1,
              size: 30,
              color: AppColors.textColor,
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
        child: _buildFrmSearch(),
      ),
    );
  }

  Widget get _buildBody {
    Loadingstatus loadingStatus = context.watch<CustomerService>().loadingStatus;
    switch (loadingStatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        return Center(
          child: Text(context.read<CustomerService>().errorMsg),
        );
      case Loadingstatus.complete:
        return _buildListCustomer();
    }
  }

  Widget _buildFrmSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11),
      width: MediaQuery.of(context).size.width,
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
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.textColor),
      ),
      onChanged: (value) => _runFilter(value),
    );
  }

  Widget _buildListCustomer() {
    return Consumer<CustomerService>(
      builder: (_, customerService, __) {
        return RefreshIndicator(
          onRefresh: () async {
            customerService.setLoadingCustomerService();
            await customerService.readCustomerService(context);
            _foundCustomer = customerService.customerModel.data;
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: ListView.builder(
                // physics: const BouncingScrollPhysics(),
                itemCount: _foundCustomer.length,
                shrinkWrap: true,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return _buildList(_foundCustomer[index], index);
                }),
          ),
        );
      },
    );
  }

  Widget _buildList(Customer data, int index) {
    ContactL? contact;
    if (data.contacts != null && data.contacts!.isNotEmpty) {
      final contacts = data.contacts!.where((element) => element.isMain == 1).map((e) => e).toList();
      contact = contacts.isNotEmpty ? contacts[0] : null;
    }
    return PersonList(
        name: data.fullName ?? '',
        number: contact?.contactPhone1 ?? "",
        detials: () async {
          // go to Detail Customer Page
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            'customer ID: [${data.id}]'.log();
            return DetailCustomerPage(
              customerId: data.id,
              image: data.avatarUrl,
              number: data.phone,
              phoneNumberI: data.phone,
              companyNameEG: data.companyNameEn,
              companyNameKH: data.companyNameKh,
              paten: data.companyPaten,
              companyStart: data.companyStart,
              paymentTermId: data.paymentTermId ?? 1,
              paymentTermName: data.paymentTermName ?? 'COD',
              patenFile: data.patenFile,
            );
          }));
          if (!mounted) return;

          // set loading
          context.read<CustomerService>().setLoadingCustomerService();
          // read the api again
          await context.read<CustomerService>().readCustomerService(context);
          // rebuild UI
          setState(() {
            _foundCustomer = context.read<CustomerService>().customerModel.data;
          });
        },
        image: data.avatarUrl);
  }
}
