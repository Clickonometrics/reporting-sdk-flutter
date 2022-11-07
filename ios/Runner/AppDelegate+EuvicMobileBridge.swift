//
//  AppDelegate+EuvicMobileBridge.swift
//  Runner
//
//  Created by Kamil Modzelewski on 02/11/2022.
//

import Foundation
import EuvicMobileSDK
import Flutter

extension AppDelegate {
    internal func setupEuvicMobileBridge() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }

        let configurationChannel = FlutterMethodChannel(name: "configuration_channel", binaryMessenger: controller.binaryMessenger)
        configurationChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let args = call.arguments as? Dictionary<String, Any>

            switch call.method {
            case "configure":
                guard let url = args?["url"] as? String, let apiKey = args?["apiKey"] as? String else { return }
                let userId = args?["userId"] as? String
                let currency = args?["currency"] as? String
                let allowSensitiveData = args?["allowSensitiveData"] as? Bool

                EuvicMobile.shared.configure(url: url, apiKey: apiKey, userId: userId, currency: currency)
                EuvicMobile.shared.config.allowSensitiveData = allowSensitiveData ?? true
            case "get_user_id":
                let userId = EuvicMobile.shared.currentUserId
                result(userId)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        let eventChannel = FlutterMethodChannel(name: "event_channel", binaryMessenger: controller.binaryMessenger)
        eventChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let args = call.arguments as? Dictionary<String, Any>

            switch call.method {
            case "home_page_visited_event":
                let custom = call.getCustomData()
                EuvicMobile.shared.homepageVisitedEvent(custom: custom)
            case "product_browsed_event":
                guard let product = call.getProduct() else { return }
                let custom = call.getCustomData()
                EuvicMobile.shared.productBrowsedEvent(product: product, custom: custom)
            case "product_added_event":
                guard let product = call.getProduct() else { return }
                let custom = call.getCustomData()
                EuvicMobile.shared.productAddedEvent(product: product, custom: custom)
            case "product_removed_event":
                guard let product = call.getProduct() else { return }
                let custom = call.getCustomData()
                EuvicMobile.shared.productRemovedEvent(product: product, custom: custom)
            case "category_browsed_event":
                guard let name = args?["name"] as? String else { return }
                let products = call.getProducts()
                let custom = call.getCustomData()
                EuvicMobile.shared.browsedCategoryEvent(name: name, products: products, custom: custom)
            case "cart_event":
                let products = call.getProducts()
                let custom = call.getCustomData()
                EuvicMobile.shared.cartEvent(products: products, custom: custom)
            case "order_started_event":
                let custom = call.getCustomData()
                EuvicMobile.shared.orderStartedEvent(custom: custom)
            case "products_ordered_event":
                guard let orderId = args?["orderId"] as? String, let saleValue = args?["saleValue"] as? String else { return }
                let currency = args?["currency"] as? String
                let products = call.getProducts()
                let custom = call.getCustomData()
                EuvicMobile.shared.productsOrderedEvent(orderId: orderId, saleValue: saleValue, products: products, currency: currency, custom: custom)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

extension FlutterMethodCall {
    fileprivate func getProduct() -> EuvicMobileProduct? {
        let args = arguments as? [String: Any]
        let product = args?["product"] as? [String: Any]
        guard
            let id = product?["id"] as? String,
            let price = product?["price"] as? String,
            let quantity = product?["quantity"] as? Int
        else { return nil }
        
        let currency = product?["currency"] as? String
        return .init(id: id, price: price, currency: currency, quantity: quantity)
    }
    
    fileprivate func getProducts() -> [EuvicMobileProduct] {
        let args = arguments as? [String: Any]
        let products = args?["products"] as? [[String: Any]]
        var items = [EuvicMobileProduct]()
        
        for product in products ?? [] {
            guard
                let id = product["id"] as? String,
                let price = product["price"] as? String,
                let quantity = product["quantity"] as? Int
            else {  continue }
            let currency = product["currency"] as? String
            items.append(.init(id: id, price: price, currency: currency, quantity: quantity))
        }
        
        return items
    }
    
    fileprivate func getCustomData() -> [String: Any] {
        let args = arguments as? [String: Any]
        let custom = args?["customData"] as? [String: Any]
        return custom ?? [:]
    }
}
