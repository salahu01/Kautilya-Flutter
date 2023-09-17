import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, this.url = 'https://events.inspirefunclub.com/'});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color.fromARGB(0, 0, 0, 0))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {},
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView(url: request.url)));
                  return NavigationDecision.prevent;
                },
              ),
            )
            ..loadRequest(Uri.parse(url)),
        ),
      ),
    );
  }
}
