// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/services/network/api_status.dart';
import '../../../mains/utils/common.dart';
import '../../../mains/utils/logger.dart';
import '../../../mains/constants/colors.dart';
import '../../../sales/service/product_item_service.dart';
import '../../../sales/service/customer_service.dart';
import '../../service/location_service.dart';
import '../../service/purchase_order_service.dart';
import '../../widgets/common_dropdown_button.dart';
import '../../widgets/common_header.dart';
import '../../widgets/next_btn.dart';
import '../common/upload_paten_file.dart';
import '../../models/address_list_model.dart';
import '../../../sales/models/purchase_order_sale_model.dart';

class EditSalePage extends StatefulWidget {
  const EditSalePage({
    super.key,
    required this.purchaseOrder,
  });

  final Data purchaseOrder;

  @override
  State<EditSalePage> createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  late final ProductItemService _productItemService;
  late final CustomerService _customerService;
  late final LocationService _locationService;

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

  String _patenBase64Str = ''; // po file Base64 String
  String _displayAddress = '';
  List<Address> _listAddress = [];

  void _init() {
    setState(() {
      _poInfo['company']['id'] = widget.purchaseOrder.customer.id.toString();
      _poInfo['company']['text'] = widget.purchaseOrder.customer.companyNameEn;
      _poInfo['customer_contact']['id'] = widget.purchaseOrder.poBy.id.toString();
      _poInfo['customer_contact']['text'] = widget.purchaseOrder.poBy.contactName.toString();
      _poInfo['delivery_contact']['id'] = widget.purchaseOrder.poTo.id.toString();
      _poInfo['delivery_contact']['text'] = widget.purchaseOrder.poTo.contactName.toString();

      if (widget.purchaseOrder.poDeliverAddress != null) {
        _poInfo['address']['id'] = widget.purchaseOrder.poDeliverAddress!.id.toString();
        _poInfo['address']['text'] = widget.purchaseOrder.poDeliverAddress!.street.toString();
        _poInfo['address']['latitude'] = widget.purchaseOrder.poDeliverAddress!.lat.toString();
        _poInfo['address']['logitude'] = widget.purchaseOrder.poDeliverAddress!.log.toString();
        _displayAddress = widget.purchaseOrder.poDeliverAddress!.street.toString();
      }

      _poInfo['payment']['id'] = widget.purchaseOrder.paymentMethod?.id.toString();
      _poInfo['payment']['text'] = widget.purchaseOrder.paymentMethod?.name.toString();

      _patenBase64Str = widget.purchaseOrder.poFileUrl ?? '';
    });
    'poInfo: $_poInfo'.log();

    _productItemService = context.read<ProductItemService>();
    _customerService = context.read<CustomerService>();
    _locationService = context.read<LocationService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _productItemService.setLoading();
      await delayed(seconds: 1);
      if (!mounted) return;
      await Future.wait([
        _productItemService.getPOForm(context),
        _customerService.readContact(context, _poInfo['company']['id']),
        _customerService.readLocation(context, _poInfo['company']['id']),
      ]);
    });
  }

  Future<void> _onPOChange() async {
    'Upload PO Reference called...'.log();
    await _customerService.getPatenBase64String(context);
    if (_customerService.patenBase64FileStr.isNotEmpty) {
      setState(() {
        _patenBase64Str = _customerService.patenBase64FileStr;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    /// remove contacts
    if (_customerService.listContacts != null) {
      _customerService.setListContacts(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
      bottomNavigationBar: _buildBottom,
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
      titleSpacing: -13,
      automaticallyImplyLeading: false,
      title: Text(
        widget.purchaseOrder.poNumber,
        style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }

  Widget get _buildBody {
    var status = context.watch<ProductItemService>().loadingStatus;
    var status2 = context.watch<CustomerService>().loadingStatus;

    String? initialCompany = _poInfo['company']['id'] + '|' + _poInfo['company']['text'];
    String? initialCustomerContact = _poInfo['customer_contact']['id'] + '|' + _poInfo['customer_contact']['text'] + '|poBy_contact';
    String? initialDelivery = _poInfo['delivery_contact']['id'] + '|' + _poInfo['delivery_contact']['text'] + '|poTo_contact';

    String initialAddress = _poInfo['address']['id'];
    initialAddress += '|' + _poInfo['address']['text'];
    initialAddress += '|' + _poInfo['address']['latitude'];
    initialAddress += '|' + _poInfo['address']['logitude'];
    if (initialAddress == '|||' || initialAddress.indexOf('|null|null|null') > -1) {
      initialAddress = '';
    }

    String? initialPaymentMethod = _poInfo['payment']['id'] + '|' + _poInfo['payment']['text'];

    _listAddress = _customerService.addressModel?.data ?? [];

    if ((status == Loadingstatus.loading || status2 == Loadingstatus.loading) && _listAddress.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (status == Loadingstatus.error || status2 == Loadingstatus.error) {
      if (_productItemService.errorMsg.isNotEmpty) {
        return Text('An Error:: ${_productItemService.errorMsg}');
      }
      if (_customerService.errorMsg.isNotEmpty) {
        return Text('An Error:: ${_customerService.errorMsg}');
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1.5.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonHeader(title: 'Customer'),
                  Consumer<ProductItemService>(
                    builder: (_, productService, __) {
                      var loading = productService.loadingStatus;
                      var customers = productService.formModel?.data.customers;
                      if ((loading == Loadingstatus.loading || customers == null)) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (loading == Loadingstatus.error) {
                        return Text('Could not getting company name: ${productService.errorMsg}');
                      } else if (customers.isNotEmpty) {
                        'company id: [${_poInfo['company']['id']}] & text: [${_poInfo['company']['text']}]'.log();
                        'initial company name: $initialCompany'.log();
                        return CommonDropDownButton(
                          initialValue: initialCompany,
                          onChanged: (newValue) async {
                            setState(() {
                              _poInfo['company']['id'] = newValue.substring(0, newValue.indexOf('|'));
                              _poInfo['company']['text'] = newValue.substring(newValue.indexOf('|') + 1);

                              /// remove order information
                              _poInfo['customer_contact']['id'] = '';
                              _poInfo['customer_contact']['text'] = '';

                              /// remove delivery information
                              _poInfo['delivery_contact']['id'] = '';
                              _poInfo['delivery_contact']['text'] = '';

                              /// remove address information
                              _poInfo['address']['id'] = '';
                              _poInfo['address']['text'] = '';
                              _poInfo['address']['latitude'] = '';
                              _poInfo['address']['logitude'] = '';
                            });
                            'on select change - id: [${_poInfo['company']['id']}] text: [${_poInfo['company']['text']}]'.log();

                            await Future.wait([
                              _customerService.readContact(context, _poInfo['company']['id']),
                              _customerService.readLocation(context, _poInfo['company']['id'])
                            ]);
                          },
                          textLabel: 'Company',
                          hint: 'Select Company',
                          items: customers.map((customer) {
                            return {
                              'value': '${customer.id}|${customer.companyNameEN}',
                              'text': customer.companyNameEN,
                            };
                          }).toList(),
                        );
                      } else {
                        return const Text('Could not getting company name');
                      }
                    },
                  ),
                  SizedBox(height: 1.2.h),
                  const CommonHeader(title: 'Order Information'),
                  Consumer<CustomerService>(builder: (_, customerService, __) {
                    var loadingStatus = customerService.loadingStatus;
                    var contacts = customerService.listContacts;
                    if (loadingStatus == Loadingstatus.loading || contacts == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (loadingStatus == Loadingstatus.error) {
                      return Text('Could not getting order information: ${customerService.errorMsg}');
                    } else if (contacts.isNotEmpty) {
                      'customer info id: [${_poInfo['customer_contact']['id']}] & text: [${_poInfo['customer_contact']['text']}]'.log();
                      'initial customer contact: $initialCustomerContact'.log();

                      'delivery info id: [${_poInfo['delivery_contact']['id']}] & text: [${_poInfo['delivery_contact']['text']}]'.log();
                      'initial delivery contact: $initialDelivery'.log();
                      return CommonDropDownButton(
                        initialValue: initialCustomerContact,
                        onChanged: (newValue) {
                          setState(() {
                            _poInfo['customer_contact']['id'] = newValue.substring(0, newValue.indexOf('|'));
                            _poInfo['customer_contact']['text'] = newValue.substring(newValue.indexOf('|') + 1) + '|poBy_contact';
                          });

                          'on select change - id: [${_poInfo['customer_contact']['id']}] text: [${_poInfo['customer_contact']['text']}]'.log();
                        },
                        textLabel: 'Contact',
                        hint: 'Select Contact',
                        items: contacts.map((contact) {
                          return {
                            'value': '${contact.id}|${contact.contactName}|poBy_contact',
                            'text': contact.contactName,
                          };
                        }).toList(),
                      );
                    } else {
                      return const Text('Could not getting order information');
                    }
                  }),
                  SizedBox(height: 1.h),
                  const Text('PO Number'),
                  TextField(
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      labelText: widget.purchaseOrder.poNumber,
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                  _uploadPaten(),
                  SizedBox(height: 3.h),
                  const CommonHeader(title: 'Delivery Information'),
                  _customerService.listContacts == null
                      ? const Center(child: CircularProgressIndicator())
                      : _customerService.listContacts!.isEmpty
                          ? const Text('Could not getting delivery information')
                          : CommonDropDownButton(
                              initialValue: initialDelivery,
                              onChanged: (newValue) {
                                setState(() {
                                  _poInfo['delivery_contact']['id'] = newValue.substring(0, newValue.indexOf('|'));
                                  _poInfo['delivery_contact']['text'] = newValue.substring(newValue.indexOf('|') + 1) + '|poTo_contact';
                                });

                                'on select change - id: [${_poInfo['delivery_contact']['id']}] text: [${_poInfo['delivery_contact']['text']}]'.log();
                              },
                              textLabel: 'Contact',
                              hint: 'Select Contact',
                              items: _customerService.listContacts!.map((contact) {
                                return {
                                  'value': '${contact.id}|${contact.contactName}|poTo_contact',
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
                      'address id: [${_poInfo['address']['id']}] & text: [${_poInfo['address']['text']}]'.log();
                      'initial address: $initialAddress'.log();
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
                  SizedBox(height: 1.h),
                  _buildPinDelivery(),
                  SizedBox(height: 2.h),
                  const CommonHeader(title: 'Others'),
                  SizedBox(height: 1.h),
                  Consumer<ProductItemService>(
                    builder: (_, productService, __) {
                      var paymentMethods = _productItemService.formModel?.data.paymentMethods;
                      if (paymentMethods == null || paymentMethods.isEmpty) {
                        return const CircularProgressIndicator();
                      } else if (paymentMethods.isNotEmpty) {
                        'payment method id: [${_poInfo['payment']['id']}] & text: [${_poInfo['payment']['text']}]'.log();
                        'initial payment method: $initialPaymentMethod'.log();
                        return CommonDropDownButton(
                          initialValue: initialPaymentMethod,
                          onChanged: (newValue) {
                            setState(() {
                              _poInfo['payment']['id'] = newValue.substring(0, newValue.indexOf('|'));
                              _poInfo['payment']['text'] = newValue.substring(newValue.indexOf('|') + 1);
                            });
                            'on select change - id: [${_poInfo['payment']['id']}] text: [${_poInfo['payment']['text']}]'.log();
                          },
                          textLabel: 'Payment Method',
                          hint: 'Select Payment Method',
                          items: paymentMethods.map((payment) {
                            return {
                              'value': '${payment.id}|${payment.name}',
                              'text': payment.name,
                            };
                          }).toList(),
                        );
                      } else {
                        'paymentMethods:: $paymentMethods'.log();
                        return const Text('Could not getting payment method');
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
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
                        _patenBase64Str.substring(_patenBase64Str.lastIndexOf('/') + 1),
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

        if (tmpAddress != null) {
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

  Widget get _buildBottom {
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
        'onUpdate general save click...'.log();

        if (_poInfo['address']['id'] == '') {
          alertMsg(context: context, msg: 'Please select address');
          return;
        }

        if (_poInfo['customer_contact']['id'] == '') {
          alertMsg(context: context, msg: 'Please select order information');
          return;
        }

        if (_poInfo['delivery_contact']['id'] == '') {
          alertMsg(context: context, msg: 'Please select delivery information');
          return;
        }

        if (_poInfo['address']['id'] == '') {
          alertMsg(context: context, msg: 'Please select address');
          return;
        }

        Map<String, dynamic> postData = {
          'customer_id': _poInfo['company']['id'].toString(),
          'po_by': _poInfo['customer_contact']['id'].toString(),
          'po_to': _poInfo['delivery_contact']['id'].toString(),
          'po_deliver_address': _poInfo['address']['id'].toString(),
          'payment_method_id': _poInfo['payment']['id'].toString(),
        };

        if (_patenBase64Str.isNotEmpty && _patenBase64Str.lastIndexOf('.pdf') < 0) {
          postData['po_file'] = _patenBase64Str;
        }
        // 'po_notes': _noteCtr.text, // in UI don't have right now
        'postData:: $postData'.log();

        _customerService.setLoadingCustomerService();
        await Future.delayed(const Duration(milliseconds: 500), () {});
        if (!mounted) return;
        _customerService.updateGeneral(context: context, postData: postData, poID: widget.purchaseOrder.id).then((res) {
          if (res) {
            alertMsg(context: context, msg: 'update success...', seconds: 1);

            /// handle callback
            onUpdateSuccess(
                context: context,
                callbackAction: () async {
                  context.read<PoSaleService>().setLoading();
                  await context.read<PoSaleService>().getSinglePO(context: context, poID: widget.purchaseOrder.id);
                });
          } else {
            alertMsg(context: context, msg: 'update failed...');
          }
        });
      },
    );
  }
}
