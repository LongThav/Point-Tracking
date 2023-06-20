import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../sales/models/customer_model.dart';
import '../../../mains/services/network/api_status.dart';
// import '../../../sales/models/contact_model.dart';
import '../../../sales/models/form_detail_model.dart';
import '../../service/location_service.dart';
import 'build_location.dart';
import '../../../mains/utils/logger.dart';
import '../../../sales/widgets/save_btn.dart';
import '../../../mains/constants/colors.dart';
// import '../../models/address_list_model.dart';
import '../../service/customer_service.dart';
import '../../widgets/common_text_form_field.dart';
import '../build_card_profile.dart';
import '../build_listcontact.dart';

class DetailCustomerPage extends StatefulWidget {
  final String? number;
  final String? image;
  final int customerId;
  final String? phoneNumberI;
  final String? companyNameEG;
  final String? companyNameKH;
  final String? paten;
  final String? patenFile;
  final String? companyStart;
  final int paymentTermId;
  final String paymentTermName;

  const DetailCustomerPage({
    super.key,
    this.image,
    this.companyNameEG,
    this.companyNameKH,
    this.companyStart,
    this.paten,
    required this.paymentTermId,
    required this.paymentTermName,
    required this.customerId,
    this.number,
    this.patenFile,
    this.phoneNumberI,
  });

  @override
  State<DetailCustomerPage> createState() => _DetailCustomerPageState();
}

class _DetailCustomerPageState extends State<DetailCustomerPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _contactNameCtrl;
  late final TextEditingController _phoneNumber1Ctrl;
  late final TextEditingController _phoneNumber2CtrII;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _positionCtrl;
  late final TextEditingController _cardIDCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _homeCtrl;
  late final TextEditingController _khanCtrl;
  late final TextEditingController _sangkatCtrl;
  late final TextEditingController _provinceCtrl;
  late final TextEditingController _statusCtrl;

  // List<Address> _address = [];
  late final CustomerService _customerService;
  // double _width = 0;
  double _height = 0;

  int _positionId = 0;
  String position = '';
  String _khan = '';
  int _khanID = 0;
  String _sangkat = ' ';
  int _sangkatId = 0;
  String _province = ' ';
  int _provinceId = 0;
  List<Customer> customerModel = [];
  final List<String> _tabNames = const <String>['Profile', 'Contact', 'Location'];
  bool _hideAddBtn = true;
  String _appBarTitle = 'View Customer';

  final GlobalKey<FormState> _createContactKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _createLocationKey = GlobalKey<FormState>();

  List<Text> _getTabText(List<String> tabNames) {
    final fixedTabs = List.generate(tabNames.length, (index) {
      return Text(tabNames[index], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18));
    }, growable: false);

    return fixedTabs;
  }

  Future<void> _alertCreateContact(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.all(15),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0XFFFFFFFF),
            ),
            child: _buildFormList(),
          ),
        );
      },
    );
  }

  Future<void> _alertCreateLocation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            insetPadding: const EdgeInsets.all(15),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0XFFFFFFFF),
              ),
              child: _buildLocation(),
            ),
          );
        });
  }

  Future<void>? _onPressed() async {
    var contacts = _customerService.listContacts;
    if (contacts == null) {
      return;
    }
    var addressModel = _customerService.addressModel;
    if (addressModel == null) {
      return;
    }
    if (_appBarTitle.indexOf('Contact') > -1) {
      "Contact Length::${contacts.length}".log();
      if (contacts.length >= 2) {
      } else {
        return _alertCreateContact(context);
      }
    } else {
      "Address Length::${addressModel.data.length}".log();
      if (addressModel.data.length >= 3) {
        /// do nothing
      } else {
        return _alertCreateLocation(context);
      }
    }
  }

  void _init() {
    '[detail customer page] init...'.log();
    _tabController = TabController(length: _tabNames.length, vsync: this, initialIndex: 0);
    _tabController.animateTo(0);
    _customerService = context.read<CustomerService>();
    _contactNameCtrl = TextEditingController(text: '');
    _phoneNumber1Ctrl = TextEditingController(text: '');
    _phoneNumber2CtrII = TextEditingController(text: '');
    _emailCtrl = TextEditingController(text: '');
    _positionCtrl = TextEditingController(text: '');
    _cardIDCtrl = TextEditingController(text: '');
    _streetCtrl = TextEditingController(text: '');
    _homeCtrl = TextEditingController(text: '');
    _khanCtrl = TextEditingController(text: '');
    _sangkatCtrl = TextEditingController(text: '');
    _provinceCtrl = TextEditingController(text: '');
    _statusCtrl = TextEditingController(text: '');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
    });
  }

  void _dispose() {
    _contactNameCtrl.dispose();
    _phoneNumber1Ctrl.dispose();
    _phoneNumber2CtrII.dispose();
    _emailCtrl.dispose();
    _positionCtrl.dispose();
    _cardIDCtrl.dispose();
    _streetCtrl.dispose();
    _homeCtrl.dispose();
    _khanCtrl.dispose();
    _sangkatCtrl.dispose();
    _provinceCtrl.dispose();
    _statusCtrl.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _dispose();
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
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: AppColors.textColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        _appBarTitle,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleSpacing: -10,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: TabBar(
          indicatorColor: AppColors.textColor,
          indicatorWeight: 2.0,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.textColor,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          labelPadding: EdgeInsets.only(bottom: 1.7.h),
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          onTap: (tabNumber) async {
            'onTap: $tabNumber'.log();
            // hints:
            // tab 0: Profile, tab 1: Contact, tab 2: Location
            // tab: 0 is profile tab, so disabled add action
            if (tabNumber == 0) {
              // rebuild UI
              setState(() {
                _hideAddBtn = true;
              });
              _appBarTitle = 'View Customer';
            } else {
              // tab 1, 2
              if (tabNumber == 1) {
                _appBarTitle = 'View Contact';
              } else {
                _appBarTitle = 'View Location';
              }
              setState(() {
                _hideAddBtn = false;
              });
            }
          },
          tabs: _getTabText(_tabNames),
        ),
      ),
      actions: _hideAddBtn
          ? null
          : [
              IconButton(
                onPressed: _onPressed,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.textColor,
                  size: 30,
                ),
              ),
            ],
    );
  }

  SafeArea get _buildBody {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            BuildCardProfile(
              phoneNumberI: widget.phoneNumberI ?? '',
              companyNameEG: widget.companyNameEG ?? '',
              companyNameKH: widget.companyNameKH ?? '',
              paten: widget.paten ?? '',
              companyStart: widget.companyStart ?? '',
              image: widget.image ?? '',
              paymentTermId: widget.paymentTermId,
              paymentTermName: widget.paymentTermName,
              patenFile: widget.patenFile,
              customerId: widget.customerId,
            ),
            BuildListContact(
              customerId: widget.customerId,
            ),
            BuildLocation(
              customerId: widget.customerId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormList() {
    return Form(
      key: _createContactKey,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Create Contact",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          CommonTextFormField(
            text: 'Name',
            isRequired: true,
            ctr: _contactNameCtrl,
            hintText: 'Contact Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Input Name';
              }
              return null;
            },
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          CommonTextFormField(
            text: 'ID Card',
            keyboardType: TextInputType.number,
            ctr: _cardIDCtrl,
            hintText: '-',
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          CommonTextFormField(
            text: 'Phone 1',
            isRequired: true,
            ctr: _phoneNumber1Ctrl,
            keyboardType: TextInputType.number,
            hintText: '85512345678',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Input phone 1';
              }
              return null;
            },
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          CommonTextFormField(
            text: 'Phone 2',
            ctr: _phoneNumber2CtrII,
            keyboardType: TextInputType.number,
            hintText: '-',
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          CommonTextFormField(
            text: 'Email',
            keyboardType: TextInputType.emailAddress,
            ctr: _emailCtrl,
            hintText: 'example@email.com',
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          _buildPosition(),
          SizedBox(
            height: _height * 0.02,
          ),
          SaveBtn(
            title: 'Create Contact',
            onPress: () async {
              if (_createContactKey.currentState!.validate()) {
                Map<String, dynamic> map = {
                  'contact_name': _contactNameCtrl.text,
                  'id_card': _cardIDCtrl.text,
                  'contact_phone1': _phoneNumber1Ctrl.text,
                  'contact_phone2': _phoneNumber2CtrII.text,
                  'email': _emailCtrl.text,
                  'position_id': _positionId,
                };
                "Map::$map".log();
                // close alert
                Navigator.pop(context);
                // call loading
                _customerService.setLoadingCustomerService();
                // delay 500 milliseconds
                await Future.delayed(const Duration(milliseconds: 500), () {});
                // request API to create contact
                if (!mounted) return;
                final result = await _customerService.createContacts(context, map);
                if (!mounted) return;
                if (result) {
                  _contactNameCtrl.text = '';
                  _cardIDCtrl.text = '';
                  _phoneNumber1Ctrl.text = '';
                  _phoneNumber2CtrII.text = '';
                  _emailCtrl.text = '';

                  await _customerService.readContact(context, widget.customerId.toString());
                  setState(() {});

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create Contact success'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create Contact failed'),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPosition() {
    final List<Positions> listPosition = _customerService.frmDetailModel.data.positions;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listPosition.isEmpty) {
        return const CircularProgressIndicator();
      }
      position = listPosition[0].name;
      _positionId = listPosition[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Position',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: position,
            items: List.generate(listPosition.length, (index) {
              return DropdownMenuItem(
                value: listPosition[index].name,
                child: Text(listPosition[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                position = value ?? '';
              });
              final listObj = listPosition.where((element) => element.name == value).toList();
              _positionId = listObj[0].id;
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      );
    }
  }

  /// No use: comment for now
  // Widget _showData() {
  //   List<Positions> position = context.watch<CustomerService>().frmDetailModel.data.positions;
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 1.h),
  //     child: DropdownButtonFormField(
  //       icon: const Icon(Icons.expand_more),
  //       borderRadius: BorderRadius.circular(15),
  //       items: const [
  //         DropdownMenuItem(
  //           value: 'Owner',
  //           child: Text('Owner'),
  //         )
  //       ],
  //       onChanged: (String? value) {
  //         setState(() {});
  //       },
  //       decoration: const InputDecoration(
  //         hintText: 'Position',
  //         labelStyle: TextStyle(
  //           color: Color.fromRGBO(0, 0, 0, 0.87),
  //           fontSize: 16,
  //           fontWeight: FontWeight.w400,
  //         ),
  //         contentPadding: EdgeInsets.symmetric(vertical: 10),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLocation() {
    return Form(
      key: _createLocationKey,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Create Location",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          CommonTextFormField(
            text: 'Street',
            isRequired: true,
            ctr: _streetCtrl,
            hintText: 'Street Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Input Street';
              }
              return null;
            },
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          CommonTextFormField(
            text: 'Home',
            isRequired: true,
            ctr: _homeCtrl,
            hintText: 'Home No',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Input Home';
              }
              return null;
            },
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          _buildKhan(),
          SizedBox(
            height: _height * 0.02,
          ),
          _buildSangKat(),
          SizedBox(
            height: _height * 0.02,
          ),
          _buildProvince(),
          SizedBox(
            height: _height * 0.02,
          ),
          SaveBtn(
            title: 'Create Location',
            onPress: () async {
              if (_createLocationKey.currentState!.validate()) {
                /// * All types: 0, 1, 2
                /// - type: 0 Pin
                /// - type: 1 Post
                /// - type: 2 Update
                context.read<LocationService>().setType(0);
                // await context.read<LocationService>().onPinDeliveryLocationTap(context);

                Map<String, dynamic> map = {
                  'home_address': _homeCtrl.text,
                  'street': _streetCtrl.text,
                  'province_id': _provinceId,
                  'khan_id': _khanID,
                  'sangkat_id': _sangkatId,
                };
                Navigator.pop(context);
                _customerService.setLoadingCustomerService();
                final result = await _customerService.createLocation(context, map);
                if (!mounted) return;
                if (result) {
                  _homeCtrl.text = '';
                  _streetCtrl.text = '';
                  // _customerService.setUserID(widget.userId);
                  _customerService.readLocation(context, widget.customerId.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create location success'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create location failed'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKhan() {
    final List<Khan> listkhan = _customerService.frmDetailModel.data.khan;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listkhan.isEmpty) {
        return const CircularProgressIndicator();
      }
      _khan = listkhan[0].name;
      _khanID = listkhan[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Khan',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _khan,
            items: List.generate(listkhan.length, (index) {
              return DropdownMenuItem(
                value: listkhan[index].name,
                child: Text(listkhan[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _khan = value ?? '';
              });
              final khanObj = listkhan.where((element) => element.name == value).toList();
              _khanID = khanObj[0].id;
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              isDense: true,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
            focusColor: Colors.transparent,
          ),
        ],
      );
    }
  }

  Widget _buildSangKat() {
    final List<Sangkat> listSangkat = _customerService.frmDetailModel.data.sangkat;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listSangkat.isEmpty) {
        return const CircularProgressIndicator();
      }
      _sangkat = listSangkat[0].name;
      _sangkatId = listSangkat[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'SangKat',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _sangkat,
            items: List.generate(listSangkat.length, (index) {
              return DropdownMenuItem(
                value: listSangkat[index].name,
                child: Text(listSangkat[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _sangkat = value ?? '';
              });
              final paymentObj = listSangkat.where((element) => element.name == value).toList();
              _sangkatId = paymentObj[0].id;
              "ProvinceId::$_sangkatId".log();
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              isDense: true,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
            focusColor: Colors.transparent,
          ),
        ],
      );
    }
  }

  Widget _buildProvince() {
    final List<Provinces> listProvince = _customerService.frmDetailModel.data.provinces;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listProvince.isEmpty) {
        return const CircularProgressIndicator();
      }
      _province = listProvince[0].name;
      _provinceId = listProvince[0].id;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'City',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _province,
            items: List.generate(listProvince.length, (index) {
              return DropdownMenuItem(
                value: listProvince[index].name,
                child: Text(listProvince[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                _province = value ?? '';
              });
              final paymentObj = listProvince.where((element) => element.name == value).toList();
              _provinceId = paymentObj[0].id;
              "ProvinceId::$_provinceId".log();
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.87),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              isDense: true,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
            focusColor: Colors.transparent,
          ),
        ],
      );
    }
  }
}
