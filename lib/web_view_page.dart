import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.userId}) : super(key: key);

  final String? userId;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  static const String apiKey = 'zGvjBvroFc7onruVlmSoy3foBHLG4Upq';
  static const String userType = 'AAID';
  String? encodedUserId;

 @override
 void initState() {
   super.initState();

   String? userId = widget.userId;
   if(userId != null){
     final bytes = utf8.encode(userId);
     final base = base64.encode(bytes);
     encodedUserId = base;
   }

   setState(() {});
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad preview'),
        automaticallyImplyLeading: false,
        leading: IconButton (
          icon: const Icon(Icons.arrow_back),
          onPressed: () {Navigator.pop(context);}
        ),
      ),
      body: WebView(
          initialUrl: 'https://static.clickonometrics.pl/previews/campaignsPreview.html?key=$apiKey&user_id=$encodedUserId&user_type=$userType',
          javascriptMode: JavascriptMode.unrestricted
      ),
    );
  }
}