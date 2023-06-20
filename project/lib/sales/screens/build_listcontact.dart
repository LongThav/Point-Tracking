import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';
import '../../mains/services/network/api_status.dart';
import '../../sales/service/customer_service.dart';
import '../models/contact_model.dart';
import '../models/form_detail_model.dart';
import '../widgets/common_text_form_field.dart';
import '../widgets/save_btn.dart';

class BuildListContact extends StatefulWidget {
  final int customerId;

  const BuildListContact({
    super.key,
    required this.customerId,
  });

  @override
  State<BuildListContact> createState() => _BuildListContactState();
}

class _BuildListContactState extends State<BuildListContact> {
  TextEditingController _contactNameCtrl = TextEditingController();
  TextEditingController _phoneNumber1Ctrl = TextEditingController();
  TextEditingController _phoneNumber2CtrII = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _positionCtrl = TextEditingController();
  TextEditingController _cardIDCtrl = TextEditingController();

  late final CustomerService _customerService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? contactId; //contactId
  int _positionId = 0;
  String position = '';
  List<ContactM> _contacts = []; // store list contacts

  Future<void> _alertUpdateContact(BuildContext context) {
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
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0XFFFFFFFF),
              ),
              child: _buildFormList(),
            ),
          );
        });
  }

  @override
  void initState() {
    _customerService = context.read<CustomerService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _customerService.setLoadingCustomerService();
      _customerService.readContact(context, widget.customerId.toString());
      _contacts = _customerService.listContacts ?? [];
    });
    super.initState();
  }

  @override
  void dispose() {
    _contactNameCtrl.dispose();
    _phoneNumber1Ctrl.dispose();
    _phoneNumber2CtrII.dispose();
    _emailCtrl.dispose();
    _positionCtrl.dispose();
    _cardIDCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
    );
  }

  get _buildBody {
    Loadingstatus loadingstatus = context.watch<CustomerService>().loadingStatus;
    switch (loadingstatus) {
      case Loadingstatus.none:
      case Loadingstatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Loadingstatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.read<CustomerService>().errorMsg,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      case Loadingstatus.complete:
        return _buildListContact();
    }
  }

  Widget _buildListContact() {
    _contacts = context.watch<CustomerService>().listContacts ?? [];
    int itemCount = _contacts.length;
    if (itemCount == 0) {
      return const Center(
        child: Text(
          'No contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        _customerService.setLoadingCustomerService();
        _customerService.readContact(context, widget.customerId.toString());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
            itemCount: itemCount >= 2 ? 2 : itemCount,
            itemBuilder: (context, index) {
              final data = _contacts[index];
              String nameAndPosition = '${data.contactName} ';
              if (data.position != null && data.position!.name.isNotEmpty) {
                nameAndPosition += '(${data.position?.name})';
              }
              String phoneAndEmail = '${data.contactPhone1} ';
              if (data.email != null && data.email!.isNotEmpty) {
                phoneAndEmail += '- ${data.email}';
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                // height: 8.3.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(85, 75, 186, 0.14),
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: 1.5.h,
                          ),
                          child: Text(
                            nameAndPosition,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0XFF343434),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 1.5.h, top: 0.4.h),
                          child: Text(
                            phoneAndEmail,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0XFF343434),
                            ),
                          ),
                        ),
                        data.idCard == null
                            ? const SizedBox.shrink()
                            : Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.5.h, top: 0.4.h),
                                child: Text(
                                  data.idCard.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0XFF343434),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          _contactNameCtrl = TextEditingController(text: data.contactName);
                          _phoneNumber1Ctrl = TextEditingController(text: data.contactPhone1);
                          _phoneNumber2CtrII = TextEditingController(text: data.contactPhone2);
                          _emailCtrl = TextEditingController(text: data.email);
                          _positionCtrl = TextEditingController(text: data.position != null ? data.position.toString() : '');
                          _cardIDCtrl = TextEditingController(text: data.idCard != null ? data.idCard.toString() : "");
                          setState(() {
                            contactId = data.id;
                          });
                          _alertUpdateContact(context);
                        },
                        icon: const Icon(
                          Icons.edit_note,
                          color: AppColors.textColor,
                          size: 25,
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _buildFormList() {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Update Contact",
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
                  )),
            ],
          ),
          SizedBox(
            height: height * 0.02,
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
            height: height * 0.02,
          ),
          CommonTextFormField(
            text: 'ID Card',
            keyboardType: TextInputType.number,
            ctr: _cardIDCtrl,
            hintText: '-',
          ),
          SizedBox(
            height: height * 0.02,
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
            height: height * 0.02,
          ),
          CommonTextFormField(
            text: 'Phone 2',
            ctr: _phoneNumber2CtrII,
            keyboardType: TextInputType.number,
            hintText: '-',
          ),
          SizedBox(
            height: height * 0.02,
          ),
          CommonTextFormField(
            text: 'Email',
            keyboardType: TextInputType.emailAddress,
            ctr: _emailCtrl,
            hintText: 'example@email.com',
          ),
          SizedBox(
            height: height * 0.02,
          ),
          _buildPosition(),
          SizedBox(
            height: height * 0.02,
          ),
          SaveBtn(
            title: 'Update Contact',
            onPress: () async {
              if (_formKey.currentState!.validate()) {
                Map<String, dynamic> map = {
                  'contact_name': _contactNameCtrl.text,
                  'id_card': _cardIDCtrl.text,
                  'contact_phone1': _phoneNumber1Ctrl.text,
                  'contact_phone2': _phoneNumber2CtrII.text,
                  'email': _emailCtrl.text,
                  'position_id': _positionId,
                };
                // close alert
                Navigator.pop(context);
                // call loading
                context.read<CustomerService>().setLoadingCustomerService();
                // delay 500 milliseconds
                await Future.delayed(const Duration(milliseconds: 500), () {});
                if (!mounted) return;
                // request update contact
                final response = await context.read<CustomerService>().updateContact(context, map, contactId!);
                if (!mounted) return;
                if (response) {
                  // read contact update
                  await context.read<CustomerService>().readContact(context, widget.customerId.toString());
                  if (!mounted) return;
                  final List<ContactM> updatedContacts = context.read<CustomerService>().listContacts ?? [];
                  // Rebuild UI
                  setState(() {
                    _contacts = updatedContacts;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Update Success...'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Update failed'),
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
    final List<Positions> listposition = _customerService.frmDetailModel.data.positions;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listposition.isEmpty) {
        return const CircularProgressIndicator();
      }
      position = listposition[0].name;
      _positionId = listposition[0].id;
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
            items: List.generate(listposition.length, (index) {
              return DropdownMenuItem(
                value: listposition[index].name,
                child: Text(listposition[index].name),
              );
            }),
            onChanged: (String? value) {
              setState(() {
                position = value ?? '';
              });
              final listObj = listposition.where((element) => element.name == value).toList();
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
}
