import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants.dart';
import '../main.dart';
import '../model/cash_product.dart';
import '../model/purchasable_product.dart';
import '../model/store_state.dart';
import '../repo/iap_repo.dart';
import 'dash_counter.dart';
import 'firebase_notifier.dart';

class DashPurchases extends ChangeNotifier {
  DashCounter counter;
  FirebaseNotifier firebaseNotifier;
  IAPRepo iapRepo;
  StoreState storeState = StoreState.loading;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<PurchasableProduct> products = [];

  bool get beautifiedDash => _beautifiedDashUpgrade;
  bool _beautifiedDashUpgrade = false;
  final iapConnection = IAPConnection.instance;

  DashPurchases(this.counter, this.firebaseNotifier, this.iapRepo) {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    iapRepo.addListener(purchasesUpdate);
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    print("[loadPurchases] available: ${available}");
    if (!available) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    try {
      await firebaseNotifier.functions;
    } catch (e) {
      storeState = StoreState.notAvailable;
      notifyListeners();
      return;
    }

    var dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.219.101:3000',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ));

    print("[dio] ${dio}");
    final productListresponse = await dio.get('/laudyou-api/cash/product-list-external');
    print("[productListresponse] ${productListresponse}");
    List<CashProductModel> productList = (productListresponse.data).map<CashProductModel>((json) {
      return new CashProductModel(json['productId'], json['productType']);
    }).toList();
    print("[productList] ${productList}");

    Set<String> set = productList.map((e) => e.productId).toSet();
    final response = await iapConnection.queryProductDetails(set);

    products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList();
    storeState = StoreState.available;
    notifyListeners();
  }

  @override
  void dispose() {
    iapRepo.removeListener(purchasesUpdate);
    _subscription.cancel();
    super.dispose();
  }

  Future<void> buy(PurchasableProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);
    print("[buy] product: ${product.toString()}");
    await iapConnection.buyConsumable(purchaseParam: purchaseParam);
    // switch (product.id) {
    //   case storeKeyConsumable:
    //     await iapConnection.buyConsumable(purchaseParam: purchaseParam);
    //     break;
    //   case storeKeySubscription:
    //   case storeKeyUpgrade:
    //     await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
    //     break;
    //   default:
    //     throw ArgumentError.value(
    //         product.productDetails, '${product.id} is not a known product');
    // }
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    print("[_onPurchaseUpdate]");
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    print("[_handlePurchase] purchaseDetails.status: ${purchaseDetails.status}");
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Send to server
      var validPurchase = await _verifyPurchase(purchaseDetails);

      print("[_handlePurchase] validPurchase: ${validPurchase}");

      if (validPurchase) {
        counter.addBoughtDashes(2000);
        // Apply changes locally
        // switch (purchaseDetails.productID) {
        //   case storeKeySubscription:
        //     counter.applyPaidMultiplier();
        //     break;
        //   case storeKeyConsumable:
        //     counter.addBoughtDashes(2000);
        //     break;
        //   case storeKeyUpgrade:
        //     _beautifiedDashUpgrade = true;
        //     break;
        // }
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await iapConnection.completePurchase(purchaseDetails);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    var functions = await firebaseNotifier.functions;
    final callable = functions.httpsCallable('verifyPurchase');

    print("[_verifyPurchase]\n"
        "\tsource: ${purchaseDetails.verificationData.source}\n"
        "\tverificationData: ${purchaseDetails.verificationData.serverVerificationData}\n"
        "\tproductId: ${purchaseDetails.productID}\n");

    final results = await callable({
      'source': purchaseDetails.verificationData.source,
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.productID,
    });

    print("[_verifyPurchase] results: $results");

    return results.data as bool;
  }

  void _updateStreamOnDone() {
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    // ignore: avoid_print
    print(error);
  }

  void purchasesUpdate() {
    var subscriptions = <PurchasableProduct>[];
    var upgrades = <PurchasableProduct>[];
    // Get a list of purchasable products for the subscription and upgrade.
    // This should be 1 per type.
    print("[purchasesUpdate]");
    if (products.isNotEmpty) {
      subscriptions = products
          .where((element) => element.productDetails.id != null)
          .toList();
      // upgrades = products
      //     .where((element) => element.productDetails.id == storeKeyUpgrade)
      //     .toList();
    }

    // Set the subscription in the counter logic and show/hide purchased on the
    // purchases page.
    if (iapRepo.hasActiveSubscription) {
      counter.applyPaidMultiplier();
      for (final element in subscriptions) {
        _updateStatus(element, ProductStatus.purchased);
      }
    } else {
      counter.removePaidMultiplier();
      for (final element in subscriptions) {
        _updateStatus(element, ProductStatus.purchasable);
      }
    }

    // Set the dash beautifier and show/hide purchased on
    // the purchases page.
    if (iapRepo.hasUpgrade != _beautifiedDashUpgrade) {
      _beautifiedDashUpgrade = iapRepo.hasUpgrade;
      for (final element in upgrades) {
        _updateStatus(
            element,
            _beautifiedDashUpgrade
                ? ProductStatus.purchased
                : ProductStatus.purchasable);
      }
      notifyListeners();
    }
  }

  void _updateStatus(PurchasableProduct product, ProductStatus status) {
    if (product.status != status) {
      product.status = status;
      notifyListeners();
    }
  }
}
