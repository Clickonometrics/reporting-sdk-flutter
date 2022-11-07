import 'package:app_settings/app_settings.dart';
import 'package:euvic_sdk_flutter/euvic_sdk_plugin.dart';
import 'package:euvic_sdk_flutter/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ui/event_button_widget.dart';

void main() {
  runApp(const MyApp());

  EuvicSdkPlugin.configure(
    apiKey: "zGvjBvroFc7onruVlmSoy3foBHLG4Upq",
    url: "https://delivery.clickonometrics.pl/tracker=multi/track/multi/track.json",
    currency: "PLN"
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Euvic Ad SDK Flutter app sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    setState(() {});

    _checkIsLocationPermissionEnabled();
    _checkIsTrackingPermissionEnabled();
  }

  bool attachCustomData = false;

  final customData = <String, dynamic>{
    'first_custom_param_text': 'some text here',
    'text_here': 'Lorem ipsu',
    'MagicNumber': 252,
    'myCustomDouble': 0.1337
  };

  Product product = Product('id_17', '29.99', 4);

  final List<Product> productList = [
    Product('1', '23.56', 2, 'PLN'),
    Product('3', '18.30', 3),
    Product('58', '149', 1, 'PLN')
  ];

  void _onAttachCustomDataChanged(bool? newValue) => setState(() {
        if (newValue != null) {
          attachCustomData = newValue;
        }
      });

  Map<String, dynamic>? getCustomData() {
    if (attachCustomData) {
      return customData;
    } else {
      return null;
    }
  }

  Future<String?> _getUserId() async {
    final String? result = await EuvicSdkPlugin.getUserId();
    return result;
  }

  void _openAdPreviewScreen() async {
    await _getUserId().then((value) =>
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewPage(userId: value)),
        )
    );
  }

  void _checkIsLocationPermissionEnabled() async {
   await Permission.location.request();
  }

  void _checkIsTrackingPermissionEnabled() async {
   await Permission.appTrackingTransparency.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text("Click the button to send an event"),
            ),
            EventButtonWidget(
                text: "Homepage Visited Event",
                onPress: () => {
                      EuvicSdkPlugin.homePageVisitedEvent(
                          customData: getCustomData()
                      )
                    }),
            EventButtonWidget(
                text: "Product Browsed Event",
                onPress: () => {
                      EuvicSdkPlugin.productBrowsedEvent(
                          product: product,
                          customData: getCustomData()
                      )
                    }),
            EventButtonWidget(
                text: "Product Added Event",
                onPress: () => {
                  EuvicSdkPlugin.productAddedEvent(
                      product: product,
                      customData: getCustomData()
                  )
                }),
            EventButtonWidget(
                text: "Product Removed Event",
                onPress: () => {
                  EuvicSdkPlugin.productRemovedEvent(
                      product: product,
                      customData: getCustomData()
                  )
                }),
            EventButtonWidget(
                text: "Category Browsed Event",
                onPress: () => {
                  EuvicSdkPlugin.categoryBrowsedEvent(
                      name: "Kategoria testowa",
                      products: productList,
                      customData: getCustomData()
                  )
                }),
            EventButtonWidget(
                text: "Cart Event",
                onPress: () => {
                  EuvicSdkPlugin.cartEvent(
                      products: productList,
                      customData: getCustomData()
                  )
                }),
            EventButtonWidget(
                text: "Order Started Event",
                onPress: () => {
                  EuvicSdkPlugin.orderStartedEvent(
                      customData: getCustomData()
                  )
                }),
            EventButtonWidget(
                text: "Products Ordered Event",
                onPress: () => {
                  EuvicSdkPlugin.productsOrderedEvent(
                      orderId: "Hns8nSOaJNd8bD",
                      saleValue: "400.50",
                      products: productList,
                      currency: "PLN",
                      customData: getCustomData()
                  )
                }),
            CheckboxListTile(
                title: const Text("with custom data"),
                value: attachCustomData,
                onChanged: _onAttachCustomDataChanged,
                controlAffinity: ListTileControlAffinity.leading),
            EventButtonWidget(text: "Preview", onPress: () => {
              _openAdPreviewScreen()
            }),
            EventButtonWidget(
                text: "Open app settings",
                onPress: () => {AppSettings.openAppSettings()})
          ],
        ),
      ),
    );
  }
}
