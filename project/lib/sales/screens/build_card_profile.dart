import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../sales/screens/common/view_paten_file.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/services/profile_service.dart';
import '../../mains/utils/logger.dart';
import '../models/form_detail_model.dart';
import '../service/customer_service.dart';
import '../widgets/common_text_form_field.dart';
import '../widgets/save_btn.dart';
import 'common/upload_paten_file.dart';

class BuildCardProfile extends StatefulWidget {
  final String phoneNumberI;
  final String companyNameEG;
  final String companyNameKH;
  final String paten;
  final String companyStart;
  final String image;
  final int paymentTermId;
  final String paymentTermName;
  final int customerId;
  final String? patenFile;

  const BuildCardProfile({
    super.key,
    required this.phoneNumberI,
    required this.companyNameEG,
    required this.companyNameKH,
    required this.paten,
    required this.companyStart,
    required this.image,
    required this.paymentTermId,
    required this.paymentTermName,
    required this.patenFile,
    required this.customerId,
  });

  @override
  State<BuildCardProfile> createState() => _BuildCardProfileState();
}

class _BuildCardProfileState extends State<BuildCardProfile> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneNumberICtrl;
  late final TextEditingController _companyNameEGCtrl;
  late final TextEditingController _companyNameKHCtrl;
  late final TextEditingController _companyPatenCtrl;
  late final TextEditingController _companyPatenCtrlFile;
  late final TextEditingController _paymentTermCtrl;
  late final TextEditingController _companyStartCtr;

  String? _avatarUrl; // avatar url for profile photo as link
  File? _imgFile; // img file for profile photo as file
  File? _patenFile; // paten file can be photo or pdf file
  String _patenBase64File = ''; // a paten base64 File
  String? _patenFileUrl = ''; // store patenFileUrl from update & push

  late final CustomerService _customerService; // Customer Service
  String _paymentTerm = ''; // paymentTerm dropDownMenuItem
  int _paymentId = 0; // paymentTerm ID

  final _formKey = GlobalKey<FormState>();

  void _init() {
    /// CustomerService: read
    _customerService = context.read<CustomerService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _customerService.setLoadingCustomerService();
      await _customerService.readFrmDetail(context);
    });

    _paymentTerm = widget.paymentTermName;
    _paymentId = widget.paymentTermId;

    _firstNameCtrl = TextEditingController(text: '');
    _lastNameCtrl = TextEditingController(text: '');
    _emailCtrl = TextEditingController(text: '');
    _phoneNumberICtrl = TextEditingController(text: '');
    _companyNameEGCtrl = TextEditingController(text: widget.companyNameEG);
    _companyNameKHCtrl = TextEditingController(text: widget.companyNameKH);
    _companyPatenCtrl = TextEditingController(text: widget.paten);
    _paymentTermCtrl = TextEditingController(text: _paymentTerm);
    _companyStartCtr = TextEditingController(text: widget.companyStart);
    _avatarUrl = widget.image;

    _patenFileUrl = widget.patenFile;
  }

  Future<void> _onProfileTapped() async {
    'Profile click...'.log();
    final profileService = context.read<ProfileService>();
    final files = await profileService.pickImage(context: context);
    if (files.isNotEmpty) {
      final CroppedFile? croppedFiles = await profileService.crop(
        file: files.first,
        cropStyle: CropStyle.rectangle,
      );
      if (croppedFiles != null) {
        setState(() {
          _imgFile = File(croppedFiles.path);
        });
      }
    }
  }

  Future<void> _onPOChange() async {
    'Upload PO Reference called...'.log();
    await context.read<CustomerService>().getPatenBase64String(context);
    setState(() {
      _patenBase64File = context.read<CustomerService>().patenBase64FileStr;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneNumberICtrl.dispose();
    _companyNameEGCtrl.dispose();
    _companyNameKHCtrl.dispose();
    _companyPatenCtrl.dispose();
    _paymentTermCtrl.dispose();
    _companyStartCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
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
          child: Text(
            context.read<CustomerService>().errorMsg,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        );
      case Loadingstatus.complete:
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: _buildCard(),
          ),
        );
    }
  }

  Widget _buildCard() {
    DecorationImage? decorationImage() {
      DecorationImage? decImg;
      if (_avatarUrl != null) {
        decImg = DecorationImage(image: NetworkImage(_avatarUrl!), fit: BoxFit.fill);
      }
      if (_imgFile != null) {
        decImg = DecorationImage(image: FileImage(_imgFile!));
      }

      return decImg;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
      width: double.infinity,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(85, 75, 186, 0.14),
          offset: Offset(5.0, 5.0),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
                image: decorationImage(),
              ),
              child: _avatarUrl == null
                  ? Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.photo_outlined,
                          size: 30,
                          color: Colors.grey[600],
                        ),
                        onPressed: _onProfileTapped,
                      ),
                    )
                  : InkWell(
                      onTap: _onProfileTapped,
                    ),
            ),
            CommonTextFormField(
              isRequired: true,
              text: 'Name (LATIN)',
              ctr: _companyNameEGCtrl,
              hintText: 'Company Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Input Company Name(LATIN)';
                }
                return null;
              },
            ),
            SizedBox(
              height: 1.5.h,
            ),
            CommonTextFormField(
              text: 'Name (KHMER)',
              ctr: _companyNameKHCtrl,
              hintText: 'Company Name In Khmer',
            ),
            SizedBox(
              height: 1.5.h,
            ),
            CommonTextFormField(
                isRequired: true,
                text: 'Start date',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Input Start date';
                  }
                  return null;
                },
                ctr: _companyStartCtr,
                hintText: '',
                readOnly: true,
                onTap: () async {
                  final dateYYYYMMDD =
                      '${_companyStartCtr.text.substring(6, 10)}-${_companyStartCtr.text.substring(3, 5)}-${_companyStartCtr.text.substring(0, 2)}';
                  'dateYYYYMMDD : $dateYYYYMMDD'.log();
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(dateYYYYMMDD),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    'pickedDate : $pickedDate'.log(); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    'formattedDate : $formattedDate'.log(); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      _companyStartCtr.text = formattedDate; //set output date to TextField value.
                    });
                  } else {}
                }),
            SizedBox(
              height: 1.5.h,
            ),
            CommonTextFormField(
              text: 'Paten',
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Input Paten';
                }
                return null;
              },
              ctr: _companyPatenCtrl,
              hintText: '-',
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 1.5.h,
            ),
            _buildPaymentTerm(),
            SizedBox(
              height: 1.5.h,
            ),
            ViewPatenFile(patenFileUrl: _patenFileUrl),
            SizedBox(
              height: 1.5.h,
            ),
            _buildEditPaten(),
            SizedBox(
              height: 1.5.h,
            ),
            SaveBtn(
                title: 'Save',
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    'Save Btn called...'.log();
                    Map<String, dynamic> map = {
                      "company_name_en": _companyNameEGCtrl.text,
                      "company_start": _companyStartCtr.text,
                      "avatar": "",
                      "company_paten": _companyPatenCtrl.text,
                      "company_paten_file": "",
                      "payment_term_id": _paymentId,
                      "company_name_kh": _companyNameKHCtrl.text.isNotEmpty ? _companyNameKHCtrl.text : '',
                    };

                    if (_imgFile != null) {
                      /// processing image path
                      'imgFile path: ${_imgFile!.path}'.log();
                      final String imgExtension = _imgFile!.path.substring(_imgFile!.path.lastIndexOf('.') + 1);
                      'imgExtension: $imgExtension'.log();

                      List<int> imageBytes = _imgFile!.readAsBytesSync();
                      String base64Image = "data:image/$imgExtension;base64,${base64Encode(imageBytes)}";
                      map['avatar'] = base64Image;
                    }

                    /// processing Upload Paten File or Image File
                    /// base64File can be image or pdf
                    if (_patenFile != null) {
                      map['company_paten_file'] = _patenBase64File;
                    }
                    // call loading
                    context.read<CustomerService>().setLoadingCustomerService();
                    // delay 500 milliseconds
                    await Future.delayed(const Duration(milliseconds: 500), () {});

                    if (!mounted) return;
                    Map<String, dynamic> resultData = {};
                    final result = await context.read<CustomerService>().updateCustomer(context, map, widget.customerId, (data) {
                      resultData = data;
                    });
                    if (result) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Customer successfully')),
                      );
                      _patenFileUrl = resultData['paten_file'];
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Customer failed')),
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTerm() {
    final List<PaymentTerms> listPaymentTerms = _customerService.frmDetailModel.data.paymentTerms;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.none || status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listPaymentTerms.isEmpty) {
        return const CircularProgressIndicator();
      }

      if (_paymentTerm.isEmpty) {
        _paymentTerm = listPaymentTerms[0].name;
        _paymentId = listPaymentTerms[0].id;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Payment Term',
              style: TextStyle(color: Colors.black),
            ),
          ),
          DropdownButtonFormField(
            icon: const Icon(Icons.expand_more),
            borderRadius: BorderRadius.circular(15),
            value: _paymentTerm,
            items: List.generate(listPaymentTerms.length, (index) {
              return DropdownMenuItem(
                value: listPaymentTerms[index].name,
                child: Text(listPaymentTerms[index].name),
              );
            }),
            onChanged: (String? value) {
              final paymentObj = listPaymentTerms.where((element) => element.name == value).toList();
              setState(() {
                _paymentTerm = value ?? '';
                _paymentId = paymentObj[0].id;
              });
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

  Widget _buildEditPaten() {
    return Stack(
      children: [
        UploadPatenFile(title: 'Edit Paten', onTap: _patenBase64File.isEmpty ? _onPOChange : null),
        _patenBase64File.isEmpty
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
                        context.read<CustomerService>().patenName,
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
}
