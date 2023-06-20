class ProductDetailModel {
    int code;
    String message;
    List<Datum> data;

    ProductDetailModel({
        this.code = 0,
        this.message = 'no-message',
        this.data = const [],
    });

    factory ProductDetailModel.fromMap(Map<String, dynamic> json) => ProductDetailModel(
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    int id;
    String poNumber;
    String poStatus;
    String createdDate;
    CreatedBy createdBy;
    Po poTo;
    Po poBy;
    PoDeliverAddress? poDeliverAddress;
    Customer customer;
    CreatedBy? deliveryMethod;
    CreatedBy paymentMethod;
    String? driver;
    String? notes;
    String poFileUrl;
    String poFile;
    List<Item> items;
    Progress progress;
    int total;

    Datum({
        this.id = 0,
        this.poNumber = 'no-poNumber',
        this.poStatus = 'no-poStatus',
        this.createdDate = 'no-createdDate',
        required this.createdBy,
        required this.poTo,
        required this.poBy,
        this.poDeliverAddress,
        required this.customer,
        this.deliveryMethod,
        required this.paymentMethod,
        this.driver,
        this.notes,
        this.poFileUrl = 'no-poFileUrl',
        this.poFile = 'no-poFile',
        this.items = const [],
        required this.progress,
        this.total = 0,
    });

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        poNumber: json["po_number"],
        poStatus: json["po_status"],
        createdDate: json["created_date"],
        createdBy: CreatedBy.fromMap(json["created_by"]),
        poTo: Po.fromMap(json["po_to"]),
        poBy: Po.fromMap(json["po_by"]),
        poDeliverAddress: json["po_deliver_address"] == null ? null : PoDeliverAddress.fromMap(json["po_deliver_address"]),
        customer: Customer.fromMap(json["customer"]),
        deliveryMethod: json["delivery_method"] == null ? null : CreatedBy.fromMap(json["delivery_method"]),
        paymentMethod: CreatedBy.fromMap(json["payment_method"]),
        driver: json["driver"],
        notes: json["notes"],
        poFileUrl: json["po_file_url"],
        poFile: json["po_file"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        progress: Progress.fromMap(json["progress"]),
        total: json["total"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "po_number": poNumber,
        "po_status": poStatus,
        "created_date": createdDate,
        "created_by": createdBy.toMap(),
        "po_to": poTo.toMap(),
        "po_by": poBy.toMap(),
        "po_deliver_address": poDeliverAddress?.toMap(),
        "customer": customer.toMap(),
        "delivery_method": deliveryMethod?.toMap(),
        "payment_method": paymentMethod.toMap(),
        "driver": driver,
        "notes": notes,
        "po_file_url": poFileUrl,
        "po_file": poFile,
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "progress": progress.toMap(),
        "total": total,
    };
}

class CreatedBy {
    int id;
    String name;

    CreatedBy({
        this.id = 0,
        this.name = 'no-name',
    });

    factory CreatedBy.fromMap(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}

class Customer {
    int id;
    String companyNameKh;
    String companyNameEn;

    Customer({
        this.id = 0,
        this.companyNameKh = 'no-companyNameKh',
        this.companyNameEn = 'no-companyNameEn',
    });

    factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json["id"],
        companyNameKh: json["company_name_kh"],
        companyNameEn: json["company_name_en"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "company_name_kh": companyNameKh,
        "company_name_en": companyNameEn,
    };
}

class Item {
    int id;
    String quantity;
    Product product;
    Package package;

    Item({
        this.id = 0,
        this.quantity = 'no-',
        required this.product,
        required this.package,
    });

    factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"],
        quantity: json["quantity"],
        product: Product.fromMap(json["product"]),
        package: Package.fromMap(json["package"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "quantity": quantity,
        "product": product.toMap(),
        "package": package.toMap(),
    };
}

class Package {
    int id;
    String label;

    Package({
        this.id = 0,
        this.label = 'no-label',
    });

    factory Package.fromMap(Map<String, dynamic> json) => Package(
        id: json["id"],
        label: json["label"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "label": label,
    };
}

class Product {
    int id;
    String name;
    String desc;
    int stock;

    Product({
        this.id = 0,
        this.name = 'no-name',
        this.desc = 'no-desc',
        this.stock = 0,
    });

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        stock: json["stock"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "desc": desc,
        "stock": stock,
    };
}

class Po {
    int id;
    String contactName;
    String? idCard;
    String contactPhone1;
    String? contactPhone2;
    String? email;
    CreatedBy position;
    int isMain;

    Po({
        this.id = 0,
        this.contactName = 'no-contactName',
        this.idCard,
        this.contactPhone1 = 'no-contactPhone1',
        this.contactPhone2,
        this.email,
        required this.position,
        this.isMain = 0,
    });

    factory Po.fromMap(Map<String, dynamic> json) => Po(
        id: json["id"],
        contactName: json["contact_name"],
        idCard: json["id_card"],
        contactPhone1: json["contact_phone1"],
        contactPhone2: json["contact_phone2"],
        email: json["email"],
        position: CreatedBy.fromMap(json["position"]),
        isMain: json["is_main"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "contact_name": contactName,
        "id_card": idCard,
        "contact_phone1": contactPhone1,
        "contact_phone2": contactPhone2,
        "email": email,
        "position": position.toMap(),
        "is_main": isMain,
    };
}

class PoDeliverAddress {
    int id;
    String homeAddress;
    String street;
    CreatedBy sangkat;
    CreatedBy khan;
    CreatedBy province;
    String log;
    String lat;
    int isMain;
    String type;

    PoDeliverAddress({
        this.id = 0,
        this.homeAddress = 'no-homeAddress',
        this.street = 'no-street',
        required this.sangkat,
        required this.khan,
        required this.province,
        this.log = 'no-log',
        this.lat = 'no-lat',
        this.isMain = 0,
        this.type = 'no-type',
    });

    factory PoDeliverAddress.fromMap(Map<String, dynamic> json) => PoDeliverAddress(
        id: json["id"],
        homeAddress: json["home_address"],
        street: json["street"],
        sangkat: CreatedBy.fromMap(json["sangkat"]),
        khan: CreatedBy.fromMap(json["khan"]),
        province: CreatedBy.fromMap(json["province"]),
        log: json["log"],
        lat: json["lat"],
        isMain: json["is_main"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "home_address": homeAddress,
        "street": street,
        "sangkat": sangkat.toMap(),
        "khan": khan.toMap(),
        "province": province.toMap(),
        "log": log,
        "lat": lat,
        "is_main": isMain,
        "type": type,
    };
}

class Progress {
    Confirm progressNew;
    Confirm inService;
    Confirm confirm;
    String? control;
    String? delivered;

    Progress({
        required this.progressNew,
        required this.inService,
        required this.confirm,
        this.control,
        this.delivered,
    });

    factory Progress.fromMap(Map<String, dynamic> json) => Progress(
        progressNew: Confirm.fromMap(json["new"]),
        inService: Confirm.fromMap(json["in_service"]),
        confirm: Confirm.fromMap(json["confirm"]),
        control: json["control"],
        delivered: json["delivered"],
    );

    Map<String, dynamic> toMap() => {
        "new": progressNew.toMap(),
        "in_service": inService.toMap(),
        "confirm": confirm.toMap(),
        "control": control,
        "delivered": delivered,
    };
}

class Confirm {
    String status;
    String date;
    String by;

    Confirm({
        this.status = 'no-status',
        this.date = 'no-date',
        this.by = 'no-by',
    });

    factory Confirm.fromMap(Map<String, dynamic> json) => Confirm(
        status: json["status"],
        date: json["date"],
        by: json["by"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "date": date,
        "by": by,
    };
}
