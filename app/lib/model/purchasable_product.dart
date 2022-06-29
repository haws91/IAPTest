import 'package:in_app_purchase/in_app_purchase.dart';

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}

class PurchasableProduct {
  String get id => productDetails.id;
  String get title => productDetails.title;
  String get description => productDetails.description;
  String get price => productDetails.price;
  ProductStatus status;
  ProductDetails productDetails;

  PurchasableProduct(this.productDetails) : status = ProductStatus.purchasable;

  String toString() {
    return
      "{\n"
      "\tid: $id,\n"
      "\ttitle: $title,\n"
      "\tdescription: $description,\n"
      "\tprice: $price,\n"
      "\tstatus: ${status.name},\n"
      "\tproductDetails: {\n"
      "\t\tid: ${productDetails.id}\n"
      "\t\ttitle: ${productDetails.title}\n"
      "\t\tdescription: ${productDetails.description}\n"
      "\t\tprice: ${productDetails.price}\n"
      "\t\trawPrice: ${productDetails.rawPrice}\n"
      "\t\tcurrencyCode: ${productDetails.currencyCode}\n"
      "\t\tcurrencySymbol: ${productDetails.currencySymbol}\n"
      "\t\t}\n"
      "\t}\n";
  }
}
