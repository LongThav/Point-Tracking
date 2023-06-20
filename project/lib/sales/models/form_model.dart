import 'package:equatable/equatable.dart';

class FormModel {
  const FormModel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final Data data;

  factory FormModel.fromJson(Map<String, dynamic> jsonMap) {
    return FormModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
      data: Data.fromJson(jsonMap['data']),
    );
  }
}

class Data {
  Data({
    required this.customers,
    required this.paymentMethods,
  });

  final List<Customer> customers;
  final List<PaymentMethod> paymentMethods;

  factory Data.fromJson(Map<String, dynamic> jsonMap) {
    var customers = List.from(jsonMap['customers']).map((e) => Customer.fromJson(e)).toList();
    var paymentMethods = List.from(jsonMap['payment_methods']).map((e) => PaymentMethod.fromJson(e)).toList();
    return Data(
      customers: customers,
      paymentMethods: paymentMethods,
    );
  }
}

class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.companyNameEN,
    required this.companyNameKH,
    required this.text,
    required this.avatarURL,
    required this.fullName,
    required this.patenFile,
    this.paymentTermName,
    this.paymentTerms,
  });

  final int id;
  final String companyNameEN;
  final String companyNameKH;
  final String text;
  final String avatarURL;
  final String fullName;
  final String patenFile;
  final String? paymentTermName;
  final String? paymentTerms;

  factory Customer.fromJson(Map<String, dynamic> jsonMap) {
    return Customer(
      id: jsonMap['id'],
      companyNameEN: jsonMap['company_name_en'],
      companyNameKH: jsonMap['company_name_kh'],
      text: jsonMap['text'],
      avatarURL: jsonMap['avatar_url'],
      fullName: jsonMap['full_name'],
      patenFile: jsonMap['paten_file'],
      paymentTermName: jsonMap['payment_term_name'],
      paymentTerms: jsonMap['payment_terms'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyNameEN,
        companyNameKH,
        text,
        avatarURL,
        fullName,
        patenFile,
        paymentTermName,
        paymentTerms,
      ];
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory PaymentMethod.fromJson(Map<String, dynamic> jsonMap) {
    return PaymentMethod(
      id: jsonMap['id'],
      name: jsonMap['name'],
    );
  }
}
