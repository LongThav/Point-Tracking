import 'package:equatable/equatable.dart';

class CustomerModel {
  CustomerModel({
    this.code = 0,
    this.message = "no-message",
    this.data = const [],
  });

  final int code;
  final String message;
  final List<Customer> data;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        code: json["code"],
        message: json["message"],
        data: List<Customer>.from(json["data"].map((x) => Customer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Customer extends Equatable {
  const Customer({
    this.id = 0,
    this.firstName = "no-firstName",
    this.lastName = "no-lastName",
    this.email = "no-email",
    this.emailVerifiedAt = "no-emailVerifiedAt",
    this.phone = "no-phone",
    this.company = "no-company",
    this.designation = "no-designation",
    this.addressLine1 = "no-addressLine1",
    this.addressLine2 = "no-addressLine2",
    this.country = "no-country",
    this.state = "no-state",
    this.city = "no-city",
    this.zipcode = "no-zipcode",
    this.shortAddress = "no-shortAddress",
    this.billingSame = 0, //Noted
    this.bFirstName = "no-bFirstName",
    this.bLastName = "no-bLastName",
    this.bEmail = "no-bEmail",
    this.bPhone = "no-bPhone",
    this.bAddressLine1 = "no-bAddressLine1",
    this.bAddressLine2 = "no-bAddressLine2",
    this.bCountry = "no-bCountry",
    this.bState = "no-bState",
    this.bCity = "no-bCity",
    this.bZipcode = "no-bZipcode",
    this.bShortAddress = "no-bShortAddress",
    this.avatar = "no-avatar", //Noted
    this.status = "no-status",
    this.isVerified = "no-isVerified",
    this.rememberToken = "no-rememberToken",
    this.createdBy = 0,
    this.updatedBy = 0,
    required this.createdAt,
    required this.updatedAt,
    this.companyNameEn = "no-companyNameEn",
    this.companyNameKh = "no-companyNameKh",
    this.companyPaten = "no-companyPaten",
    this.companyStart = "no-companyStart",
    this.paymentTermId = 0,
    this.paymentTermName = "no-paymentTermName",
    this.departmentId = 0,
    this.salesId = 0,
    this.text = "no-text",
    this.avatarUrl = "no-avatarUrl",
    this.fullName = "no-fullName",
    this.contacts = const [],
    this.patenFile = "no-patenFile",
  });

  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? emailVerifiedAt;
  final String? phone;
  final String? company;
  final String? designation;
  final String? addressLine1;
  final String? addressLine2;
  final String? country;
  final String? state;
  final String? city;
  final String? zipcode;
  final String? shortAddress;
  final int? billingSame;
  final String? bFirstName;
  final String? bLastName;
  final String? bEmail;
  final String? bPhone;
  final String? bAddressLine1;
  final String? bAddressLine2;
  final String? bCountry;
  final String? bState;
  final String? bCity;
  final String? bZipcode;
  final String? bShortAddress;
  final String? avatar;
  final String? status;
  final String? isVerified;
  final String? rememberToken;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? companyNameEn;
  final String? companyNameKh;
  final String? companyPaten;
  final String? companyStart;
  final int? paymentTermId;
  final String? paymentTermName;
  final int? departmentId;
  final int? salesId;
  final String? text;
  final String? avatarUrl;
  final String? fullName;
  final List<ContactL>? contacts;
  final String? patenFile;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"],
      phone: json["phone"],
      company: json["company"],
      designation: json["designation"],
      addressLine1: json["address_line_1"],
      addressLine2: json["address_line_2"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
      zipcode: json["zipcode"],
      shortAddress: json["short_address"],
      billingSame: json["billing_same"],
      bFirstName: json["b_first_name"],
      bLastName: json["b_last_name"],
      bEmail: json["b_email"],
      bPhone: json["b_phone"],
      bAddressLine1: json["b_address_line_1"],
      bAddressLine2: json["b_address_line_2"],
      bCountry: json["b_country"],
      bState: json["b_state"],
      bCity: json["b_city"],
      bZipcode: json["b_zipcode"],
      bShortAddress: json["b_short_address"],
      avatar: json["avatar"],
      status: json["status"],
      isVerified: json["is_verified"],
      rememberToken: json["remember_token"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      companyNameEn: json["company_name_en"],
      companyNameKh: json["company_name_kh"],
      companyPaten: json["company_paten"],
      companyStart: json["company_start"],
      paymentTermId: json["payment_term_id"],
      paymentTermName: json["payment_term_name"],
      departmentId: json["department_id"],
      salesId: json["sales_id"],
      text: json["text"],
      avatarUrl: json["avatar_url"],
      fullName: json["full_name"],
      contacts: json["contacts"] != null ? List<ContactL>.from(json["contacts"].map((x) => ContactL.fromJson(x))) : null,
      patenFile: json["paten_file"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "phone": phone,
        "company": company,
        "designation": designation,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "country": country,
        "state": state,
        "city": city,
        "zipcode": zipcode,
        "short_address": shortAddress,
        "billing_same": billingSame,
        "b_first_name": bFirstName,
        "b_last_name": bLastName,
        "b_email": bEmail,
        "b_phone": bPhone,
        "b_address_line_1": bAddressLine1,
        "b_address_line_2": bAddressLine2,
        "b_country": bCountry,
        "b_state": bState,
        "b_city": bCity,
        "b_zipcode": bZipcode,
        "b_short_address": bShortAddress,
        "avatar": avatar,
        "status": status,
        "is_verified": isVerified,
        "remember_token": rememberToken,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "company_name_en": companyNameEn,
        "company_name_kh": companyNameKh,
        "company_paten": companyPaten,
        "company_start": companyStart,
        "payment_term_id": paymentTermId,
        "department_id": departmentId,
        "sales_id": salesId,
        "text": text,
        "avatar_url": avatarUrl,
        "full_name": fullName,
        "contacts": contacts != null ? List<dynamic>.from(contacts!.map((x) => x.toJson())) : null,
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        emailVerifiedAt,
        phone,
        company,
        designation,
        addressLine1,
        addressLine2,
        country,
        state,
        city,
        zipcode,
        shortAddress,
        billingSame,
        bFirstName,
        bLastName,
        bEmail,
        bPhone,
        bAddressLine1,
        bAddressLine2,
        bCountry,
        bState,
        bCity,
        bZipcode,
        bShortAddress,
        avatar,
        status,
        isVerified,
        rememberToken,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        companyNameEn,
        companyNameKh,
        companyPaten,
        companyStart,
        paymentTermId,
        departmentId,
        salesId,
        text,
        avatarUrl,
        fullName,
        contacts,
      ];
}

class ContactL extends Equatable {
  const ContactL({
    this.id = 0,
    this.contactName = "no-contactName",
    this.idCard = 'no-idCard',
    this.contactPhone1 = "no-contactPhone1",
    this.contactPhone2 = "no-contactPhone2",
    this.email = "no-email",
    this.status = "no-status",
    this.customerId = 0,
    this.positionId = 0,
    this.createdBy = 0,
    this.updatedBy = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isMain = 0,
  });

  final int? id;
  final String? contactName;
  final String? idCard;
  final String? contactPhone1;
  final String? contactPhone2;
  final String? email;
  final String? status;
  final int? customerId;
  final int? positionId;
  final int? createdBy;
  final int? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? isMain;

  factory ContactL.fromJson(Map<String, dynamic> json) => ContactL(
        id: json["id"],
        contactName: json["contact_name"],
        idCard: json["id_card"],
        contactPhone1: json["contact_phone1"],
        contactPhone2: json["contact_phone2"],
        email: json["email"],
        status: json["status"],
        customerId: json["customer_id"],
        positionId: json["position_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isMain: json["is_main"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "id_card": idCard,
        "contact_phone1": contactPhone1,
        "contact_phone2": contactPhone2,
        "email": email,
        "status": status,
        "customer_id": customerId,
        "position_id": positionId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_main": isMain,
      };

  @override
  List<Object?> get props => [
        id,
        contactName,
        idCard,
        contactPhone1,
        contactPhone2,
        email,
        status,
        customerId,
        positionId,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        isMain,
      ];
}
