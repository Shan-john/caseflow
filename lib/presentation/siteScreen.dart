import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewScreen extends StatefulWidget {
  @override
  _InAppWebViewScreenState createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        _webViewController.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebView Example')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri('https://doj.gov.in/live-streaming-of-court-cases/')),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        pullToRefreshController: _pullToRefreshController,
        onLoadStart: (controller, url) {
          print("Page started loading: $url");
        },
        onLoadStop: (controller, url) async {
          print("Page finished loading: $url");
          _pullToRefreshController.endRefreshing();
        },
      ),
    );
  }
}
