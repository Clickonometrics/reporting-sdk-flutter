# Euvic Mobile SDK Flutter

## System Requirements

Android 7.0+\
iOS 13.0+
## Installation

### Android
Add this dependency to your module's `build.gradle` file:

**Kotlin**
```kotlin
dependencies {
	...
	implementation("io.github.clickonometrics.android:clickonometrics:1.+")
}
```

**Groovy**
```groovy
dependencies {
	...
	implementation 'io.github.clickonometrics.android:clickonometrics:1.+'
}
```

Make sure the `minSdkVersion` in `build.gradle` file is at least 24.

**Kotlin**
```kotlin
android {
	...
	defaultConfig {
		...
		// 24 or greater
		minSdkVersion(24)
	}	
}
```

**Groovy**
```groovy
android {
	...
	defaultConfig {
		...
		// 24 or greater
		minSdkVersion 24
	}	
}
```

### iOS


The library is available via Cocapods so you need add dependency to your Podfile
```
pod 'EuvicMobileSDK', '~> 1.0'
```
You can also use framework binary file `EuvicMobileSDK.xcframework` and add it to your project.


## Configuration

Create a new file called `euvic_sdk_plugin.dart` and paste all the code you find [here]().

### Android Advertising ID
To use system ad identifier add this line to your ```AndroidManifest.xml``` file.
```xml
<manifest xlmns:android...>
 ...
 <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
 <application ...
</manifest>
```

### iOS Advertising ID
To use system ad identifier you need to request for tracking authorization in your app.\
Remember to add `NSUserTrackingUsageDescription` in your Info.plist

### Android Location Tracking

To allow library to track user's location you need to request about location permission in your app before sending an event.\
Remember to add this line to your ```AndroidManifest.xml``` file.
```xml
<manifest xlmns:android...>
 ...
 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
 <application ...
</manifest>
```

### iOS Location Tracking

To send current user location you need to request for tracking authorization in your app.\
Remember to add `NSLocationWhenInUseUsageDescription` in your Info.plist

## Flutter <-> Android communication bridge

In order for the library to do its job, you need to add a bridge that communicates between Flutter and Android. [Click here]() and copy the code to `MainActivity.kt` in your `android/app/src/main/kotlin/your_project_path/`.

## Flutter <-> iOS communication bridge

In order for the library to do its job, you need to add a bridge that communicates between Flutter and iOS. [Click here]() and copy content of `AppDelegate+EuvicMobileBridge.swift` file into your project and add the following to `AppDelegate.swift`

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      setupEuvicMobileBridge()

      GeneratedPluginRegistrant.register(with: self)
      ...
    }
```
## Libary Configuration

Before sending events configuration is required. We recommend to do it just after starting the app, because all events submitted earlier will not be sent.

| Param      | Type    | Description                                                                                                                                                                                          | Note     |
|------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `url`      | String  | represents events api                                                                                                                                                                                | Required |
| `apiKey`   | String  | Euvic SDK api key                                                                                                                                                                                    | Required |
| `userId`   | String  | Unique ID representing user. Will be overwritten if AAID (Android) or IDFA (IOS) is available                                                                                                                                | Optional |
| `currency` | String  | Optional value, represents shop currency. If currency is not provided for each product, this value will be used. Should be a three letter value consistent with ISO 4217 norm. Default value is EUR. | Optional |
| `allowSensitiveData` | bool  | Optional value, allows collecting and send sensitive data like location (also permission must be granted and GPS turned on), IP address, list of installed application on the device. Default value is true. | Optional |

Example:

**Dart**
```dart
EuvicSdkPlugin.configure(
    apiKey: "your_api_key",
    url: "https://your-event-tracker.com",
    currency: "EUR"
  );
```

## Sending events

### Homepage Visited Event

This event should be sent when user has visited a home page
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Product Browsed Event

This event should be sent when user has browsed a product.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents browsed product | Required |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Product Added Event

This event should be sent when user adds product to the shopping cart.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents product added to cart | Required |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Product Removed Event

This event should be sent when user removes product from the shopping cart.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents product removed from cart | Required |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Browsed Category Event

This event should be sent when user has browsed category.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `name` | String | represents category name | Required |
| `products` | List<Product> | represents products from the category | Required |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Cart Event

This event should be sent when user views products in the cart.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `products` | List<Product> | represents products from cart | Required |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Order Started Event

This event should be sent when user has started the order process.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Products Ordered Event

This event should be sent when user has completed the order process.
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `orderId` | String | represents the unique id of the order process | Required |
| `saleValue` | String | represents the value of the products user has ordered | Required |
| `products` | List<Product> | represents ordered products | Required |
| `currency` | String | represents the currency of the sale value. Should be a three letter value consistent with ISO 4217 norm | Optional |
| `customData` | Map<String, dynamic> | represents custom data | Optional |

### Appending custom data

For each event there is possibility to append custom data. Sample below:

**Dart**
```dart
EuvicSdkPlugin.productsOrderedEvent(
     orderId: "your_order_id",
     saleValue: "299.99",
     products: Product('id_1', '299.99', 1, 'PLN'),
     currency: "PLN",
     customData: {
           'someText': 'Lorem ipsu',
           'customNumber': 124,
           'myCustomDouble': 0.1337
        }
  );
```

## Types

### Product

Represents a product instance
| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `id` | String | represents products unique identifier | Required |
| `price` | String | represents products value | Required |
| `quantity` | int | depending on type of event, it can represents added, removed or in basket quantity of the product | Required |
| `currency` | String | represents products price currency | Optional |
