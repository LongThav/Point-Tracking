// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/utils/common.dart';
import '../../../sales/widgets/common_block_row.dart';
import '../../../sales/service/location_service.dart';
import '../../models/form_model.dart';
import '../../widgets/common_header.dart';
import '../../../sales/models/address_list_model.dart';
import '../../../mains/utils/logger.dart';
import '../../service/product_item_service.dart';
import '../../../mains/services/network/api_status.dart';
import '../../widgets/common_dropdown_button.dart';
import '../../../mains/constants/colors.dart';
import '../../widgets/next_btn.dart';
import '../../../sales/service/customer_service.dart';
import '../common/upload_paten_file.dart';
import '../../models/products_item.dart' as product_cart_model;
import '../common/view_paten_file.dart';
import '../../../sales/screens/common/show_pin_location.dart';

class POInFormationStepI extends StatefulWidget {
  const POInFormationStepI({
    super.key,
    required this.listPO,
  });
  final List<product_cart_model.Data> listPO;

  @override
  State<POInFormationStepI> createState() => _POInFormationStepIState();
}

class _POInFormationStepIState extends State<POInFormationStepI> {
  late final ProductItemService _productItemService;
  late final CustomerService _customerService;
  late final LocationService _locationService;
  late final TextEditingController _poNumberCtr; // generate PO number
  late final TextEditingController _noteCtr; // customer note
  int _activeCurrentStep = 0;

  /// common select po information
  final Map<String, dynamic> _poInfo = {
    'company': {
      'id': '',
      'text': '',
    },
    'customer_contact': {
      'id': '',
      'text': '',
    },
    'delivery_contact': {
      'id': '',
      'text': '',
    },
    'address': {
      'id': '',
      'text': '',
      'latitude': '',
      'logitude': '',
    },
    'payment': {
      'id': '',
      'text': '',
    }
  };

  /// Hold all the address from api of sales and new address when sales create
  List<Address> _listAddress = [];

  final String _customerEmail = ''; // customer email
  String _patenBase64Str = ''; // po file Base64 String
  final String _deliveryName = ''; // delivery name
  final String _deliveryEmail = ''; // delivery email
  String _displayAddress = '';

  void _init() {
    /// This is a for testing purpose
    // _poNumberCtr = TextEditingController(text: 'POID000006');
    _poNumberCtr = TextEditingController(text: '');
    _noteCtr = TextEditingController(text: '');
    _productItemService = context.read<ProductItemService>();
    _customerService = context.read<CustomerService>();
    _locationService = context.read<LocationService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _productItemService.setLoading();
      await Future.delayed(const Duration(milliseconds: 500), () {}).then((_) {
        _productItemService.getPOForm(context).then((_) {
          if (_productItemService.formModel != null && _productItemService.formModel!.data.customers.isNotEmpty) {
            var id = _productItemService.formModel!.data.customers[0].id;
            _customerService.readContact(context, id.toString());
            _customerService.readLocation(context, id.toString());
          }
        });
      });
    });
  }

  Future<void> _onPOChange() async {
    'Upload PO Reference called...'.log();
    await _customerService.getPatenBase64String(context);
    setState(() {
      _patenBase64Str = _customerService.patenBase64FileStr;
    });
  }

  bool? _onNextPressed({bool isNext = false}) {
    if (_poInfo['company']['id'] == '') {
      alertMsg(context: context, msg: 'Please select company');
    } else if (_poInfo['customer_contact']['id'] == '') {
      alertMsg(context: context, msg: 'Please select order information');
    } else if (_poNumberCtr.text.isEmpty) {
      alertMsg(context: context, msg: 'Please generate PO number');
    } else if (_patenBase64Str.isEmpty) {
      alertMsg(context: context, msg: 'Please Upload PO Reference');
    } else if (_poInfo['delivery_contact']['id'] == '') {
      alertMsg(context: context, msg: 'Please select delivery information');
    } else if (_poInfo['address']['id'] == '') {
      alertMsg(context: context, msg: 'Please select address');
    } else if (_poInfo['payment']['id'] == '') {
      alertMsg(context: context, msg: 'Please select payment method');
    } else {
      'poInfo:: $_poInfo'.log();
      if (isNext) {
        if (_activeCurrentStep == 0) {
          setState(() {
            _activeCurrentStep = 1;
          });
        }
        return null;
      } else {
        return true;
      }
    }
    return null;
  }

  Future<void> _onCreatePressed() async {
    'onCreate pressed...'.log();

    var products = widget.listPO.map((element) => element.getPOPostData()).toList();
    'products:: $products'.log();

    Map<String, dynamic> postData = {
      'customer_id': _poInfo['company']['id'].toString(),
      'po_number': 'POID${_poNumberCtr.text}',
      'po_by': _poInfo['customer_contact']['id'].toString(),
      'po_to': _poInfo['delivery_contact']['id'].toString(),
      'po_deliver_address': _poInfo['address']['id'].toString(),
      'payment_method_id': _poInfo['payment']['id'].toString(),
      'po_file': _patenBase64Str,
      'products': products,
      'po_notes': _noteCtr.text,
    };
    'postData:: $postData'.log();

    _customerService.setLoadingCustomerService();
    await Future.delayed(const Duration(milliseconds: 500), () {});
    if (!mounted) return;
    var res = await _customerService.createNewPO(context, postData);
    if (!mounted) return;
    if (res) {
      /// clear the po number
      _customerService.setPONumber('');
      setState(() {
        _poNumberCtr.clear();
        _noteCtr.clear();
      });

      /// delete all selected products
      _productItemService.deleteAllProducts().then((_) {
        alertMsg(context: context, msg: 'Create success...');
        Navigator.of(context).pop('success_1');
      });
    } else {
      alertMsg(context: context, msg: 'Failed create...');
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _poNumberCtr.dispose();
    _noteCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'PO Information',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textColor),
        ),
      ),
      body: SafeArea(child: _buildBody),
      bottomNavigationBar: _buildBottom,
    );
  }

  Widget get _buildBody {
    var status = context.watch<ProductItemService>().loadingStatus;
    var paymentMethods = _productItemService.formModel?.data.paymentMethods ?? [];
    var companies = _productItemService.formModel?.data.customers ?? [];
    var allEmpty = companies.isEmpty && paymentMethods.isEmpty;

    if (allEmpty && status == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (allEmpty && status == Loadingstatus.error) {
      return Text('An Error:: ${_customerService.errorMsg}');
    } else {
      return Stepper(
        elevation: 0.0,
        physics: const ClampingScrollPhysics(),
        controlsBuilder: (BuildContext context, ControlsDetails controls) => const SizedBox.shrink(),
        onStepTapped: (step) async {
          if (_activeCurrentStep == 1) {
            setState(() {
              /// it is the same
              // _activeCurrentStep = 0;
              _activeCurrentStep = step;
            });
          } else {
            if (step == 0) {
              /// do nothing
            } else {
              /// if step: 1 check process first then continue process
              var res = _onNextPressed();
              if (res != null) {
                setState(() {
                  /// it is the same
                  // _activeCurrentStep = 1;
                  _activeCurrentStep = step;
                });
              }
            }
          }
        },
        currentStep: _activeCurrentStep == -1 ? 0 : _activeCurrentStep,
        steps: [
          getStepGeneral(customers: companies, paymentMethods: paymentMethods),
          _getStepConfirm(),
        ],
        type: StepperType.horizontal,
      );
    }
  }

  Widget? get _buildBottom {
    var loadingStatus = context.watch<CustomerService>().loadingStatus;
    var isLoading = loadingStatus == Loadingstatus.loading;
    var errorMsg = _customerService.errorMsg;
    if (errorMsg.isNotEmpty) {
      return Text('Error:: $errorMsg');
    }
    return NextButton(
        loading: (isLoading && _activeCurrentStep == 1),
        title: _activeCurrentStep == 0 ? 'Next' : 'Create',
        onPress: _activeCurrentStep == 0 ? () => _onNextPressed(isNext: true) : () async => await _onCreatePressed());
  }

  Step getStepGeneral({
    required List<Customer> customers,
    required List<PaymentMethod> paymentMethods,
  }) {
    return Step(
      state: StepState.indexed,
      isActive: _activeCurrentStep == 0,
      title: const SizedBox.shrink(),
      label: const Text(
        'General',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textColor),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonHeader(title: 'Customer'),
          CommonDropDownButton(
            onChanged: (newValue) async {
              'select company newValue: $newValue'.log();
              setState(() {
                _poInfo['company']['id'] = newValue.substring(0, newValue.indexOf('|'));
                _poInfo['company']['text'] = newValue.substring(newValue.indexOf('|') + 1);

                /// remove order information
                _poInfo['customer_contact']['id'] = '';
                _poInfo['customer_contact']['text'] = '';

                /// remove delivery information
                _poInfo['delivery_contact']['id'] = '';
                _poInfo['delivery_contact']['text'] = '';
              });
              'select company change - id: [${_poInfo['company']['id']}] text: [${_poInfo['company']['text']}]'.log();

              await Future.wait([
                _customerService.readContact(context, _poInfo['company']['id']),
                _customerService.readLocation(context, _poInfo['company']['id'])
              ]);

              setState(() {
                _listAddress = _customerService.addressModel?.data ?? [];
              });
            },
            textLabel: 'Company',
            hint: 'Select Company',
            items: customers.map((customer) {
              return {
                'value': '${customer.id}|${customer.companyNameEN}',
                'text': customer.companyNameEN,
              };
            }).toList(),
          ),
          SizedBox(height: 1.2.h),
          const CommonHeader(title: 'Order Information'),
          Consumer<CustomerService>(builder: (_, customerService, __) {
            var loadingStatus = customerService.loadingStatus;
            var contacts = customerService.listContacts;

            if (loadingStatus == Loadingstatus.loading || contacts == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (loadingStatus == Loadingstatus.error) {
              return Text('Could not getting order contact: ${customerService.errorMsg}');
            } else if (contacts.isNotEmpty) {
              return CommonDropDownButton(
                onChanged: (newValue) {
                  setState(() {
                    _poInfo['customer_contact']['id'] = newValue.substring(0, newValue.indexOf('|'));
                    _poInfo['customer_contact']['text'] = newValue.substring(newValue.indexOf('|') + 1);
                  });
                  'on select change - id: [${_poInfo['customer_contact']['id']}] text: [${_poInfo['customer_contact']['text']}]'.log();
                },
                textLabel: 'Contact',
                hint: 'Select Contact',
                items: contacts.map((contact) {
                  return {
                    'value': '${contact.id}|${contact.contactName}',
                    'text': contact.contactName,
                  };
                }).toList(),
              );
            } else {
              return const Text('Could not getting order information');
            }
          }),
          SizedBox(height: 1.h),
          _buildPONumber(),
          SizedBox(height: 3.h),
          _uploadPaten(),
          SizedBox(height: 2.h),
          const CommonHeader(title: 'Delivery Information'),
          SizedBox(height: 1.h),
          _customerService.listContacts == null
              ? const Center(child: CircularProgressIndicator())
              : _customerService.listContacts!.isEmpty
                  ? const Text('Could not getting delivery information')
                  : CommonDropDownButton(
                      onChanged: (newValue) {
                        setState(() {
                          _poInfo['delivery_contact']['id'] = newValue.substring(0, newValue.indexOf('|'));
                          _poInfo['delivery_contact']['text'] = newValue.substring(newValue.indexOf('|') + 1);
                        });
                        'on select change - id: [${_poInfo['delivery_contact']['id']}] text: [${_poInfo['delivery_contact']['text']}]'.log();
                      },
                      textLabel: 'Contact',
                      hint: 'Select Contact',
                      items: _customerService.listContacts!.map((contact) {
                        return {
                          'value': '${contact.id}|${contact.contactName}',
                          'text': contact.contactName,
                        };
                      }).toList(),
                    ),
          SizedBox(height: 1.h),
          Consumer2<CustomerService, LocationService>(builder: (_, customerService, locationService, __) {
            var locationStatusLoading = locationService.tmpAddressStatus == Loadingstatus.loading;
            var customerStatusLoading = customerService.loadingStatus == Loadingstatus.loading;
            _listAddress = customerService.addressModel?.data ?? [];
            if (_listAddress.isEmpty || customerStatusLoading || locationStatusLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            var initialAddress = _poInfo['address']['id'];
            initialAddress += '|' + _poInfo['address']['text'];
            initialAddress += '|' + _poInfo['address']['latitude'];
            initialAddress += '|' + _poInfo['address']['logitude'];

            if (_listAddress.isNotEmpty) {
              _listAddress.removeWhere((addr) => addr.street == null);
            }
            if (_listAddress.isNotEmpty) {
              return CommonDropDownButton(
                onChanged: ((newValue) {
                  'select addreess newValue: $newValue'.log();
                  // 1|12D, Teuk Tla, Sen Sok, Phnom Penh|10.333|93...
                  var strSplit = newValue.split('|');
                  setState(() {
                    _poInfo['address']['id'] = strSplit[0];
                    _poInfo['address']['text'] = strSplit[1];
                    _displayAddress = _poInfo['address']['text'];
                    _poInfo['address']['latitude'] = strSplit[2];
                    _poInfo['address']['logitude'] = strSplit[3];
                  });
                  'select address change - id: [${_poInfo['address']['id']}]'.log();
                  'text: [${_poInfo['address']['text']}]'.log();
                  'latitude: [${_poInfo['address']['latitude']}]'.log();
                  'logitude: [${_poInfo['address']['logitude']}]'.log();
                }),
                initialValue: initialAddress,
                textLabel: 'Address',
                hint: 'Select Address',
                items: _listAddress.map((address) {
                  return {
                    'value': '${address.id}|${address.street}|${address.lat}|${address.log}',
                    'text': address.street,
                  };
                }).toList(),
              );
            } else {
              return const Text('Could not getting address');
            }
          }),
          SizedBox(height: 2.h),
          _poInfo['company']['id'] == '' ? const SizedBox.shrink() : _buildPinDelivery(),
          SizedBox(height: 2.h),
          const CommonHeader(title: 'Others'),
          SizedBox(height: 1.h),
          CommonDropDownButton(
            onChanged: (newValue) {
              'select payment method newValue: $newValue'.log();
              setState(() {
                _poInfo['payment']['id'] = newValue.substring(0, newValue.indexOf('|'));
                _poInfo['payment']['text'] = newValue.substring(newValue.indexOf('|') + 1);
              });
              'select payment method change - id: [${_poInfo['payment']['id']}] text: [${_poInfo['payment']['text']}]'.log();
            },
            textLabel: 'Payment Method',
            hint: 'Select Payment Method',
            items: paymentMethods.map((payment) {
              return {
                'value': '${payment.id}|${payment.name}',
                'text': payment.name,
              };
            }).toList(),
          ),
        ],
      ),
    );
  }

  Step _getStepConfirm() {
    Widget buildNote() {
      return TextFormField(
        controller: _noteCtr,
        onFieldSubmitted: (newValue) {
          FocusScope.of(context).unfocus();
          _noteCtr.text = newValue;
        },
        // onTapOutside: (event) {
        //   FocusScope.of(context).unfocus();
        //   context.read<CustomerService>().setCustomerNote(_noteCtr.text);
        // },
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          label: Text('Note'),
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      );
    }

    Widget buildShowPinLocation() {
      return Container(
        width: double.infinity,
        height: 37,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color.fromRGBO(89, 133, 245, 1),
        ),
        child: Center(
          child: TextButton(
            onPressed: () async {
              double? lat;
              double? log;
              try {
                'lat: ${_poInfo['address']['latitude']}'.log();
                'log: ${_poInfo['address']['logitude']}'.log();
                lat = double.parse(_poInfo['address']['latitude'].toString());
                log = double.parse(_poInfo['address']['logitude'].toString());
              } catch (e) {
                'Error: $e'.log();
              }
              if (lat == null || log == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not view location'),
                  ),
                );
                return;
              }

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowPinLocation(
                    latitude: lat!,
                    longitude: log!,
                    currentAddress: _poInfo['address']['text'],
                  ),
                ),
              );
            },
            child: const Text(
              'Show Pinned Location',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ),
      );
    }

    return Step(
      state: StepState.indexed,
      isActive: _activeCurrentStep == 1,
      title: const SizedBox.shrink(),
      label: const Text(
        'Confirm',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textColor),
      ),
      content: Column(
        children: [
          buildNote(),
          SizedBox(height: 3.h),
          const CommonHeader(title: 'Customer'),
          SizedBox(height: 1.5.h),
          CommonBlockRow(
            rowText: 'Customer Name',
            rowValue: _poInfo['company']['text'] ?? '',
          ),
          SizedBox(height: 1.h),
          CommonBlockRow(
            rowText: 'Phone Number',
            rowValue: _poInfo['customer_contact']['text'] ?? '',
          ),
          SizedBox(height: 1.h),
          CommonBlockRow(rowText: 'Email', rowValue: _customerEmail),
          SizedBox(height: 3.h),
          const CommonHeader(title: 'Order Information'),
          SizedBox(height: 1.5.h),
          CommonBlockRow(rowText: 'OP Number', rowValue: _poNumberCtr.text),
          SizedBox(height: 1.h),
          CommonBlockRow(
            rowText: 'Payment Method',
            rowValue: _poInfo['payment']['text'] == '' ? '' : _poInfo['payment']['text'].substring(_poInfo['payment']['text'].indexOf('|') + 1),
          ),
          SizedBox(height: 1.h),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'OP Reference',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color.fromRGBO(114, 114, 114, 1),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          ViewPatenFile(
            title: 'View PO Reference',
            isAsset: true,
            patenName: _customerService.patenName,
            patenBytes: _customerService.patenBytes,
          ),
          SizedBox(height: 3.h),
          const CommonHeader(title: 'Delivery Information'),
          SizedBox(height: 1.5.h),
          CommonBlockRow(rowText: 'Contact', rowValue: _deliveryName),
          SizedBox(height: 1.h),
          CommonBlockRow(
            rowText: 'Phone',
            rowValue: _poInfo['delivery_contact']['text'] == ''
                ? ''
                : _poInfo['delivery_contact']['text'].toString().substring(_poInfo['delivery_contact']['text'].toString().indexOf('|') + 1),
          ),
          SizedBox(height: 1.h),
          CommonBlockRow(rowText: 'Email', rowValue: _deliveryEmail),
          SizedBox(height: 1.h),
          CommonBlockRow(rowText: 'Note', rowValue: _noteCtr.text),
          SizedBox(height: 1.h),
          CommonBlockRow(
            rowText: 'Location',
            rowValue: _displayAddress,
          ),
          SizedBox(height: 1.h),
          buildShowPinLocation(),
        ],
      ),
    );
  }

  Widget _uploadPaten() {
    return Stack(
      children: [
        UploadPatenFile(title: 'Upload PO Reference', onTap: _patenBase64Str.isEmpty ? _onPOChange : null),
        _patenBase64Str.isEmpty
            ? const SizedBox.shrink()
            : Container(
                color: Colors.blueGrey.shade100,
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _customerService.patenName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: _onPOChange,
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildPONumber() {
    var status = context.watch<CustomerService>().generatePOStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return Text('Generate PO Number Error:: ${_customerService.errorMsg}');
    } else {
      if (_customerService.poNumber.isNotEmpty && _poNumberCtr.text.isEmpty) {
        setState(() {
          _poNumberCtr.text = _customerService.poNumber.substring(4); // POID000006
        });
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PO Number'),
          const SizedBox(height: 10),
          TextField(
            controller: _poNumberCtr,
            onTap: () async {
              /// 1. PO Number - auto generate
              /// po_number
              _customerService.setLoadingGeneratePOStatus();
              await Future.delayed(const Duration(seconds: 3), () {});
              if (!mounted) return;
              await _customerService.generatePONumber(context);
            },
            enabled: _poNumberCtr.text.isNotEmpty ? false : null,
            readOnly: true,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              hintText: 'Generate',
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPinDelivery() {
    var loadingStatus = context.watch<LocationService>().loadingStatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (loadingStatus == Loadingstatus.error) {
      return Text(_locationService.errorMsg);
    }

    return GestureDetector(
      onTap: () async {
        if (_poInfo['company']['id'] == '') {
          return;
        }

        var companyId = int.tryParse(_poInfo['company']['id']);
        if (companyId == null) {
          return;
        }

        // _locationService.setUserID(_userModel.data.user!.id!);
        _locationService.setUserID(companyId);

        /// * All types: 0, 1, 2
        /// - type: 0 Pin
        /// - type: 1 Post
        /// - type: 2 Update
        _locationService.setType(1);

        /// make sure always set tmpAddress -> null before create new address
        _locationService.setTmpAddress(null);

        await _locationService.onPinDeliveryLocationTap(context);

        /// if the tmpAddress is not null so the create address is successful
        var tmpAddress = _locationService.tmpAddress;
        'tmpAddress:: $tmpAddress'.log();

        if (tmpAddress != null && tmpAddress.street != null && tmpAddress.street!.isNotEmpty) {
          /// update select address
          await _locationService.updateSelectedAddress();

          setState(() {
            _listAddress.add(tmpAddress);
            _displayAddress = _listAddress[_listAddress.length - 1].street ?? '';
            _poInfo['address']['id'] = tmpAddress.id.toString();
            _poInfo['address']['text'] = _displayAddress;
            _poInfo['address']['latitude'] = tmpAddress.lat.toString();
            _poInfo['address']['logitude'] = tmpAddress.log.toString();
          });
          'new address id: [${_poInfo['address']['id']}] text: [${_poInfo['address']['text']}]'.log();
        }
      },
      child: Container(
        width: double.infinity,
        height: 37,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromRGBO(89, 133, 245, 1)),
        child: const Center(
          child: Text(
            'Pin Delivery Location',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
  }
}
