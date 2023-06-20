import 'dart:convert';
import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// import 'package:dotted_border/dotted_border.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../sales/screens/common/upload_paten_file.dart';
import '../../../sales/models/customer_model.dart';
import 'detail_customer_page.dart';
import '../../../mains/services/network/api_status.dart';
import '../../../mains/utils/logger.dart';
import '../../../mains/services/profile_service.dart';
import '../../models/form_detail_model.dart';
import '../../service/customer_service.dart';
import '../../widgets/common_text_form_field.dart';
import '../../widgets/save_btn.dart';

class CreateCustomerProfile extends StatefulWidget {
  const CreateCustomerProfile({super.key});

  @override
  State<CreateCustomerProfile> createState() => _CreateCustomerProfileState();
}

class _CreateCustomerProfileState extends State<CreateCustomerProfile> {
  late final TextEditingController _companyNameLatinCtrl;
  late final TextEditingController _companyNameKhCtrl;
  late final TextEditingController _companyStartCtr;
  late final TextEditingController _patenCtrl;
  late final TextEditingController _paymentTermCtrl;

  String? _avatarUrl; // avatar url for profile photo as link
  File? _imgFile; // img file for profile photo as file
  // File? _patenFile; // paten file can be photo or pdf file
  String _patenBase64File = ''; // a paten base64 File

  late final CustomerService _customerService; // Customer Service
  String _paymentTerm = ''; // paymentTerm dropDownMenuItem
  int _paymentId = 0; // paymentTerm ID
  final _formKey = GlobalKey<FormState>(); // for validate form field when pressed save

  final FocusNode _nameLatinFocusNode = FocusNode();
  final FocusNode _nameKhmerFocusNode = FocusNode();
  final FocusNode _patenFocusNode = FocusNode();

  void _init() {
    '_init called...'.log();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formattedDate = formatter.format(now);
    _companyNameLatinCtrl = TextEditingController();
    _companyNameKhCtrl = TextEditingController();
    _companyStartCtr = TextEditingController(text: formattedDate);
    _patenCtrl = TextEditingController();
    _paymentTermCtrl = TextEditingController();

    /// CustomerService: read
    _customerService = context.read<CustomerService>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _customerService.setLoadingCustomerService();
      await _customerService.readFrmDetail(context);
    });
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _companyNameLatinCtrl.dispose();
    _companyNameKhCtrl.dispose();
    _patenCtrl.dispose();
    _companyStartCtr.dispose();
    _paymentTermCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildCover(),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    final profileService = context.read<ProfileService>();
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
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), boxShadow: [
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
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
                        onPressed: () async {
                          'Profile click...'.log();
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
                        },
                      ),
                    )
                  : null,
            ),
            CommonTextFormField(
              textInputAction: TextInputAction.next,
              text: 'Name (LATIN)',
              isRequired: true,
              ctr: _companyNameLatinCtrl,
              hintText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Input Name';
                }
                return null;
              },
              focusNode: _nameLatinFocusNode,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameLatinFocusNode, _nameKhmerFocusNode);
              },
            ),
            SizedBox(
              height: 1.5.h,
            ),
            CommonTextFormField(
              text: 'Name (KHMER)',
              isRequired: false,
              ctr: _companyNameKhCtrl,
              hintText: 'Name',
              focusNode: _nameKhmerFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameLatinFocusNode, _nameKhmerFocusNode);
              },
            ),
            SizedBox(
              height: 1.5.h,
            ),
            CommonTextFormField(
                text: 'Start date',
                ctr: _companyStartCtr,
                hintText: 'Start date',
                readOnly: true,
                isRequired: true,
                onTap: () async {
                  final String startText = _companyStartCtr.text.replaceAll('-', '');
                  final String dateYYYYMMDD = '${startText.substring(4, 8)}-${startText.substring(2, 4)}-${startText.substring(0, 2)}';
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
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _patenFocusNode,
              text: 'Paten',
              isRequired: true,
              ctr: _patenCtrl,
              hintText: 'Paten',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Input Paten';
                }
                return null;
              },
            ),
            SizedBox(
              height: 1.5.h,
            ),
            _buildPaymentTerm(),
            SizedBox(
              height: 1.5.h,
            ),
            UploadPatenFile(onTap: () async {
              await context.read<CustomerService>().getPatenBase64String(context);
              if (!mounted) return;
              _patenBase64File = context.read<CustomerService>().patenBase64FileStr;
              'patenBase64:: $_patenBase64File'.log();
            }),
            SizedBox(
              height: 1.5.h,
            ),
            buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTerm() {
    final List<PaymentTerms> listPaymentTerms = _customerService.frmDetailModel.data.paymentTerms;
    final Loadingstatus status = context.watch<CustomerService>().loadingStatus;
    if (status == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    } else if (status == Loadingstatus.error) {
      return const Text('Error');
    } else {
      if (listPaymentTerms.isEmpty) {
        return const CircularProgressIndicator();
      }
      // select default value the first option
      _paymentTerm = listPaymentTerms[0].name;
      _paymentId = listPaymentTerms[0].id;
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
            icon: const Icon(
              Icons.expand_more,
              size: 25,
            ),
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

  /// No use: comment for now
  // Widget _uploadPatenFile() {
  //   return GestureDetector(
  //     onTap: () async {
  //       /// Processing Upload Paten File or Photo File as Base64 String
  //       'upload Paten File tapped...'.log();
  //       final result = await FilePicker.platform.pickFiles(
  //         allowMultiple: false,
  //         type: FileType.custom,
  //         allowedExtensions: ['jpeg', 'png', 'jpg', 'pdf'],
  //         // allowedExtensions: ['png', 'pdf'],
  //       );
  //       // if no file is picked
  //       if (result == null) return;

  //       // we will log the name, size and path of the
  //       'name: ${result.files.first.name}'.log();
  //       'size: ${result.files.first.size}'.log();
  //       'path: ${result.files.first.path}'.log();

  //       final filePath = result.files.first.path.toString(); // filePath
  //       final int fileSize = result.files.first.size; // file size
  //       final String fileName = result.files.first.name; // file name
  //       final String fileExtension = fileName.substring(fileName.lastIndexOf('.') + 1);
  //       'fileExtension: $fileExtension'.log();

  //       _patenFile = File(filePath);

  //       /// handle the image file upload ~= 1MB only
  //       if (fileExtension != 'pdf') {
  //         final double totalSize = fileSize / 1000; // 1000 bytes => 1KB
  //         if (totalSize / 1000 > 1) {
  //           // 1000 KB => 1MB
  //           if (!mounted) return;
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text('The file is large, please choose other image...'),
  //             ),
  //           );
  //         } else {
  //           /// handle image processing ...
  //           final List<int> imageBytes = _patenFile!.readAsBytesSync();
  //           _patenBase64File = "data:image/$fileExtension;base64,${base64Encode(imageBytes)}";
  //         }
  //       } else {
  //         /// handling pdf processing
  //         final List<int> pdfBytes = _patenFile!.readAsBytesSync();
  //         _patenBase64File = "data:@file/pdf;base64,${base64Encode(pdfBytes)}";
  //       }
  //     },
  //     child: DottedBorder(
  //         color: Colors.grey,
  //         strokeWidth: 3,
  //         dashPattern: const [10, 5],
  //         child: Container(
  //           width: double.infinity,
  //           height: 45,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(6),
  //           ),
  //           child: const Center(
  //             child: Text(
  //               'Upload Paten File',
  //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(44, 54, 145, 0.52)),
  //             ),
  //           ),
  //         )),
  //   );
  // }

  Widget buildBottomNavigationBar() {
    return SaveBtn(
        title: 'Save',
        onPress: () async {
          if (_formKey.currentState!.validate()) {
            Map<String, dynamic> body = {
              "company_name_en": _companyNameLatinCtrl.text,
              "company_start": _companyStartCtr.text,
              "avatar": "",
              "company_paten": _patenCtrl.text,
              "company_paten_file": "",
              "payment_term_id": _paymentId,
              "company_name_kh": _companyNameKhCtrl.text.isNotEmpty ? _companyNameKhCtrl.text : '',
            };

            if (_imgFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please choose image'),
                ),
              );
            } else {
              /// processing image path
              'imgFile path: ${_imgFile!.path}'.log();
              final String imgExtension = _imgFile!.path.substring(_imgFile!.path.lastIndexOf('.') + 1);
              'imgExtension: $imgExtension'.log();

              List<int> imageBytes = _imgFile!.readAsBytesSync();
              String base64Image = "data:image/$imgExtension;base64,${base64Encode(imageBytes)}";
              body['avatar'] = base64Image;

              /// processing Upload Paten File or Image File
              /// base64File can be image or pdf
              body['company_paten_file'] = _patenBase64File;

              Customer? customer;
              final bool result = await context.read<CustomerService>().createCustomer(context, body, (data) {
                customer = data;
              });
              if (result) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create Customer successfully')),
                );

                final MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) {
                  return DetailCustomerPage(
                    customerId: customer!.id,
                    image: customer!.avatarUrl,
                    number: customer!.phone,
                    phoneNumberI: customer!.phone,
                    companyNameEG: customer!.companyNameEn,
                    companyNameKH: customer!.companyNameKh,
                    paten: customer!.companyPaten,
                    companyStart: customer!.companyStart,
                    paymentTermId: customer!.paymentTermId ?? 1,
                    paymentTermName: customer!.paymentTermName ?? 'COD',
                    patenFile: customer!.patenFile,
                  );
                });
                await Navigator.pushReplacement(context, pageRoute);
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create Customer failed'),
                  ),
                );
              }
            }
          }
        });
  }
}
