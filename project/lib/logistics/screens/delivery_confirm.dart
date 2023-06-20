import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/services/network/api_status.dart';
import '../../logistics/models/form_model.dart';
import '../../mains/utils/common.dart';
import '../../mains/utils/logger.dart';
import '../../sales/widgets/next_btn.dart';
import '../../mains/constants/colors.dart';
import '../../sales/widgets/common_dropdown_button.dart';
import '../models/add_po.dart';
import '../service/po_service.dart';
import '../widgets/confirm_items.dart';

class DeliveryConfirm extends StatefulWidget {
  final List<int> listId;
  final String street;
  final List<AddPO> addpo;
  const DeliveryConfirm({
    super.key,
    required this.listId,
    required this.street,
    required this.addpo,
  });

  @override
  State<DeliveryConfirm> createState() => _DeliveryConfirmState();
}

class _DeliveryConfirmState extends State<DeliveryConfirm> {
  late final TextEditingController _noteCtrl;
  late final PurchaseServiceLogistic _purchaseServiceLogistic;
  // late final DBHelperLogisticService _dbHelperLogisticServer;
  final _commonFormLogistic = GlobalKey<FormState>();

  late String _deliveryType = '';
  late String _deliverer = '';
  late String _delivererId = '';
  late String poId = '';
  late String deliveryMethodId = '';

  int activeCurrentStep = 0;

  List<Step> stepList() => [
        Step(
          state: StepState.indexed,
          isActive: activeCurrentStep >= 0,
          title: const Text(''),
          label: const Text(
            'General',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textColor),
          ),
          content: _buildGeneralList(),
        ),
        Step(
          state: StepState.indexed,
          isActive: activeCurrentStep >= 1,
          title: const Text(''),
          label: const Text(
            'Confirm',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textColor),
          ),
          content: _buildConfirm(),
        ),
      ];

  final Map<String, dynamic> _poInfo = {
    'delivery_method': {
      'id': '',
      'text': '',
    },
    'driver': {
      'id': '',
      'text': '',
    }
  };

  void _init() {
    _noteCtrl = TextEditingController();
    _purchaseServiceLogistic = context.read<PurchaseServiceLogistic>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _purchaseServiceLogistic.setLoading();
      _purchaseServiceLogistic.readForm(context);
      // _purchaseServiceLogistic.groupDelivery(widget.listId.join('').toString(), context);
      // _purchaseServiceLogistic.groupDelivery(widget.addpo[0].id.join('').toString(), context);
      // _purchaseServiceLogistic.readPO();
    });
  }

  bool? _onNextPressed({bool isNext = false}) {
    if (_deliveryType == '') {
      alertMsg(context: context, msg: 'Please select Delivery Type');
    } else if (_deliverer == '') {
      alertMsg(context: context, msg: 'Please select Deliverer');
    } else {
      'poInfo:: $_poInfo'.log();
      if (isNext) {
        if (activeCurrentStep == 0) {
          setState(() {
            activeCurrentStep = 1;
          });
        }
        return null;
      } else {
        return true;
      }
    }
    return null;
  }

  Future<void> _onConfirmPressed() async {
    'onConfirm pressed...'.log();
    _purchaseServiceLogistic.setLoading();
    var listIdString = widget.listId.length > 1 ? widget.listId.join(',').toString() : widget.listId.join('').toString();
    var value = await context.read<PurchaseServiceLogistic>().confirmDelivery(
          listIdString,
          deliveryMethodId,
          _noteCtrl.text,
          _delivererId,
          widget.street,
          context,
        );
    if (!mounted) return;
    if (value) {
      alertMsg(context: context, msg: 'Delivery has been Confirm', seconds: 1);

      /// handle callback
      onUpdateSuccess(
          context: context,
          secondPop: true,
          callbackAction: () async {
            _purchaseServiceLogistic.setLoading();
            _purchaseServiceLogistic.readPurchaseOrderLogistic(context);
          });
    } else {
      alertMsg(context: context, msg: 'Confirm Delivery fails');
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
          onPressed: () {
            widget.addpo.clear();
            _purchaseServiceLogistic.setLoading();
            _purchaseServiceLogistic.groupDelivery(widget.listId.first.toString(), context);
            Navigator.pop(context);

            /// clear all
            // widget.addpo.clear();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: -13,
        title: const Text(
          "Confirming Delivery",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody,
      bottomNavigationBar: _buildBottom,
    );
  }

  get _buildBody {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 0.5.h),
      child: Form(
        key: _commonFormLogistic,
        child: Column(
          children: [
            SizedBox(
              // height: 88.3.h,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stepper(
                elevation: 0.0,
                physics: const ClampingScrollPhysics(),
                controlsBuilder: (BuildContext context, ControlsDetails controls) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Row(
                      children: const <Widget>[
                        // if (_activeCurrentStep != 0)
                        //   TextButton(
                        //     onPressed: controls.onStepCancel,
                        //     child: const Text(
                        //       'BACK',
                        //       style: TextStyle(color: Colors.grey),
                        //     ),
                        //   ),
                      ],
                    ),
                  );
                },
                onStepTapped: (step) async {
                  if (activeCurrentStep == 1) {
                    setState(() {
                      /// it is the same
                      // activeCurrentStep = 0;
                      activeCurrentStep = step;
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
                          // activeCurrentStep = 1;
                          activeCurrentStep = step;
                        });
                      }
                    }
                  }
                },
                onStepContinue: () {
                  setState(() {
                    if (activeCurrentStep < stepList().length - 1) {
                      activeCurrentStep += 1;
                    } else {
                      activeCurrentStep = 0;
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (activeCurrentStep > 0) {
                      activeCurrentStep -= 1;
                    } else {
                      activeCurrentStep = 0;
                    }
                  });
                },
                currentStep: activeCurrentStep == -1 ? 0 : activeCurrentStep,
                steps: stepList(),
                type: StepperType.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralList() {
    var status = context.watch<PurchaseServiceLogistic>().loadingstatus;
    if (status == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (status == Loadingstatus.error) {
      return Center(
        child: Text('An error: ${_purchaseServiceLogistic.errorMsg}'),
      );
    }
    var deliveryMethods = _purchaseServiceLogistic.formModel.data.deliveryMethod;
    return Column(
      children: [
        CommonDropDownButton(
          onChanged: (newValue) {
            setState(() {
              _poInfo['delivery_method']['id'] = newValue.substring(0, newValue.indexOf('|'));
              _poInfo['delivery_method']['text'] = newValue.substring(newValue.indexOf('|') + 1);
              deliveryMethodId = '${_poInfo['delivery_method']['id']}';
              ("id:$deliveryMethodId").log();
            });

            _deliveryType = '${_poInfo['delivery_method']['text']}';
          },
          textLabel: 'Delivery Type',
          hint: 'Select delivery method',
          items: deliveryMethods.map((delivery) {
            return {
              'value': '${delivery.id}|${delivery.name}',
              'text': delivery.name,
            };
          }).toList(),
        ),
        _buildDeliver(),
        _buildNote(),
      ],
    );
  }

  Widget _buildDeliver() {
    final List<Delivery> driver = _purchaseServiceLogistic.formModel.data.driver;
    return CommonDropDownButton(
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'please select option';
      //   }
      //   return null;
      // },
      onChanged: (newValue) {
        setState(() {
          _poInfo['driver']['id'] = newValue.substring(0, newValue.indexOf('|'));
          _poInfo['driver']['text'] = newValue.substring(newValue.indexOf('|') + 1);
          _delivererId = '${_poInfo['driver']['id']}';
          print("Deliverer ID:${_delivererId}");
        });
        _deliverer = '${_poInfo['driver']['text']}';
        // print("Deliverer value:${_deliverer}");
      },
      textLabel: 'Deliverer',
      hint: 'Select deliverer',
      items: driver.map((driver) {
        return {
          'value': '${driver.id}|${driver.name}',
          'text': driver.name,
        };
      }).toList(),
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        const Text('Note'),
        TextField(
          controller: _noteCtrl,
          decoration: const InputDecoration(
            hintText: 'Note',
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
        )
      ],
    );
  }

  get _buildBottom {
    var loadingStatus = context.watch<PurchaseServiceLogistic>().loadingstatus;
    var isLoading = loadingStatus == Loadingstatus.loading;
    var errorMsg = context.read<PurchaseServiceLogistic>().errorMsg;
    if (errorMsg.isNotEmpty) {
      return Text('Error:: $errorMsg');
    }
    return NextButton(
        loading: (isLoading && activeCurrentStep == 1),
        title: activeCurrentStep == 0 ? 'Next' : 'Confirm',
        onPress: activeCurrentStep == 0 ? () => _onNextPressed(isNext: true) : () async => await _onConfirmPressed());
  }

  Widget _buildConfirm() {
    return Column(
      children: [
        _buildCard(),
        SizedBox(
          height: 1.7.h,
        ),
        _showItemforConfirm(),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      // height: 19.1.h,
      padding: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(85, 75, 186, 0.14),
          offset: Offset(
            2.0,
            2.0,
          ),
          blurRadius: 5.0,
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
            padding: EdgeInsets.only(left: 1.5.h, top: 2.5.h),
            child: const Text(
              'Delivery Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(52, 52, 52, 1),
              ),
            ),
          ),
          _buildRowItem('Delivery Type', _deliveryType),
          _buildRowItem('Deliverer', _deliverer),
          _buildRowItem('Note', _noteCtrl.text),
        ],
      ),
    );
  }

  Widget _buildRowItem(String title, value) {
    return Container(
      margin: EdgeInsets.only(left: 1.5.h, top: 1.h, right: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromRGBO(52, 52, 52, 1)),
          )
        ],
      ),
    );
  }

  Widget _showItemforConfirm() {
    AddPO? addPO;
    // if(widget.addpo.isNotEmpty){
    //   final showLength = widget.addpo.where((element) => element.poContactName = widget.addpo.)
    // }
    "List of AddPO\n:${widget.addpo}".log();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.addpo.length,
        itemBuilder: (context, index) {
          print("ID:${widget.addpo[index].id}");
          // print("List of PO:${widget.addpo}");
          final item = widget.addpo[index];
          return ConfirmItems(
              poName: item.poIdName,
              edition: item.poStatus,
              dateTime: item.poDate,
              name: item.poContactName,
              phone: item.poPhone,
              delivery: item.poDelivery,
              details: () {});
        },
      ),
    );
  }
}
