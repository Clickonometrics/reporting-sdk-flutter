import 'dart:async';
import 'package:flutter/services.dart';

/// Represents a product instance
/// @param id represents products unique identifier. Required.
/// @param price represents products value. Required.
/// @param quantity depending on type of event, it can represents added, removed or
///                 in basket quantity of the product. Required.
/// @param currency represents products price currency. Optional.
class Product {
  String id;
  String price;
  int quantity;
  String? currency;

  Product(this.id, this.price, this.quantity, [this.currency]);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'currency': currency
    };
  }
}

class EuvicSdkPlugin {

  /// Static constant private variable to initialize MethodChannel of 'configuration' and 'event'.
  static const MethodChannel _configurationChannel = MethodChannel('configuration_channel');
  static const MethodChannel _eventChannel = MethodChannel('event_channel');

  /// Event channel
  /// Method for SDK configuration.
  static void configure({
    required String apiKey,
    required String url,
    String? userId,
    String? currency,
    bool allowSensitiveData = true
  }) async {
    _configurationChannel.invokeMethod('configure', {
      'apiKey': apiKey,
      'url': url,
      'userId': userId,
      'currency': currency,
      'allowSensitiveData': allowSensitiveData,
    });
  }

  /// Method to get user id
  static Future<String?> getUserId() async {
    String? userId = await _configurationChannel.invokeMethod('get_user_id');
    return userId;
  }

  /// Event channel
  /// HomePageVisitedEvent
  static void homePageVisitedEvent({
    Map<String, dynamic>? customData
  }) async {
    _eventChannel.invokeMethod('home_page_visited_event', {
      'customData': customData
    });
  }

  /// ProductBrowsedEvent
  static void productBrowsedEvent({
    required Product product,
    Map<String, dynamic>? customData
  }) async {
    _eventChannel.invokeMethod('product_browsed_event', {
      'product': product.toJson(),
      'customData': customData
    });
  }

  /// ProductAddedEvent
  static void productAddedEvent({
    required Product product,
    Map<String, dynamic>? customData
  }) async {
    _eventChannel.invokeMethod('product_added_event', {
      'product': product.toJson(),
      'customData': customData
    });
  }

  /// ProductRemovedEvent
  static void productRemovedEvent({
    required Product product,
    Map<String, dynamic>? customData
  }) async {
    _eventChannel.invokeMethod('product_removed_event', {
      'product': product.toJson(),
      'customData': customData
    });
  }

  /// CategoryBrowsedEvent
  static void categoryBrowsedEvent({
    required String name,
    required List<Product> products,
    Map<String, dynamic>? customData
  }) async {
    var productsMap = [ for (var item in products) item.toJson() ];

    _eventChannel.invokeMethod('category_browsed_event', {
      'name': name,
      'products': productsMap,
      'customData': customData
    });
  }

  /// CartEvent
  static void cartEvent({
    required List<Product> products,
    Map<String, dynamic>? customData
  }) async {
    var productsMap = [ for (var item in products) item.toJson() ];

    _eventChannel.invokeMethod('cart_event', {
      'products': productsMap,
      'customData': customData
    });
  }

  /// OrderStartedEvent
  static void orderStartedEvent({
    Map<String, dynamic>? customData
  }) async {
    _eventChannel.invokeMethod('order_started_event', {
      'customData': customData
    });
  }

  /// OrderStartedEvent
  static void productsOrderedEvent({
    required String orderId,
    required String saleValue,
    required List<Product> products,
    String? currency,
    Map<String, dynamic>? customData
  }) async {
    var productsMap = [ for (var item in products) item.toJson() ];

    _eventChannel.invokeMethod('products_ordered_event', {
      'orderId': orderId,
      'saleValue': saleValue,
      'products': productsMap,
      'currency': currency,
      'customData': customData
    });
  }
}
