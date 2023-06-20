class POCARTSHelper {
  static const int DATABASE_VERSION = 7;
  static const String DATABASE_FILE_PATH = 'POCARTS.db';
  static const String TABLE_POCARTS = 'pocarts';

  // POCARTS fields
  static const String productID = 'product_id';
  static const String productCounter = 'product_counter';
  static const String productPackageSelectedId = 'product_package_selected_id';
  static const String productPrice = 'product_price';
  static const String productTotal = 'product_total';
  static const String productTotalItem = 'product_total_item';
  static const String productSubTotal = 'product_subtotal';

  // Add all fields
  static const List<String> values = [
    productID,
    productCounter,
    productPackageSelectedId,
    productPrice,
    productTotal,
    productTotalItem,
    productSubTotal,
  ];
}
