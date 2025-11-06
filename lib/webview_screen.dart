import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:webviewApp/no_internet_screen.dart';
import 'package:webviewApp/splash_image.dart';
import 'package:webviewApp/utils.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  double progress = 0;
  InAppWebViewController? webViewController;
  //int tripId;
  bool firstTime = true;
  bool showSplash = true;
  DateTime? currentBackPressTime;
  //StreamSubscription<List<ConnectivityResult>>? subscription;

  @override
  void initState() {
    super.initState();

    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((List<ConnectivityResult> result) {
    //   if (result.first == ConnectivityResult.none) {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => const NoInternetScreen()));
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // subscription?.cancel();
  }

  String jsString =
      'document.addEventListener("contextmenu", event => event.preventDefault());';
  Future<bool> _onWillPop() async {
    if (await webViewController!.canGoBack()) {
      webViewController?.goBack();

      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        // Fluttertoast.showToast(msg: exitWarning);
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ds');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(children: [
          SafeArea(
            top: safeAreaTop,
            bottom: safeAreaBottom,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(webSiteUrl),
                ),
                androidOnGeolocationPermissionsShowPrompt:
                    (InAppWebViewController controller, String origin) async {
                  if (haveLocationAccess) {
                    Map<Permission, PermissionStatus> state = await [
                      Permission.location,
                    ].request();
                    Permission.location.request();
                    if (await Permission.location.isPermanentlyDenied) {
                      openAppSettings();
                    }
                    if (await Permission.location.isDenied) {
                      Permission.location.request();
                    }
                    if (await Permission.location.isLimited) {
                      Permission.location.request();
                    }
                    if (await Permission.location.isRestricted) {
                      Permission.location.request();
                    }
                  }

                  return Future.value(GeolocationPermissionShowPromptResponse(
                      origin: origin, allow: true, retain: true));
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      supportZoom: false,
                      useShouldOverrideUrlLoading: true,
                      allowUniversalAccessFromFileURLs: true,
                      useOnDownloadStart: true,
                      mediaPlaybackRequiresUserGesture: false,
                      allowFileAccessFromFileURLs: true,
                      javaScriptEnabled: true,
                      cacheEnabled: true,
                      clearCache: false,
                      javaScriptCanOpenWindowsAutomatically: true),
                  android: AndroidInAppWebViewOptions(
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    allowFileAccess: true,
                    allowContentAccess: true,
                    geolocationEnabled: true,
                    clearSessionCache: false,
                    cacheMode: AndroidCacheMode.LOAD_DEFAULT,
                    useHybridComposition: true,
                  ),
                  ios: IOSInAppWebViewOptions(
                      disallowOverScroll: true,
                      limitsNavigationsToAppBoundDomains: true,
                      allowsInlineMediaPlayback: true,
                      allowsLinkPreview: false,
                      disableLongPressContextMenuOnLinks: true,
                      allowsPictureInPictureMediaPlayback: false,
                      allowsAirPlayForMediaPlayback: false,
                      allowsBackForwardNavigationGestures: true,
                      sharedCookiesEnabled: true),
                ),
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onLoadStart: (controller, url) async {
                  log(url.toString());
                  if (!url.toString().contains(webSiteUrl) &&
                      enableOutsideLinks) {
                    await launchUrl(url ?? Uri.parse(''));
                  }
                  if (url.toString().contains('wa.me')) {
                    await launchUrl(url ?? Uri.parse(''));
                  }
                  if (url.toString().contains('whatsapp://')) {
                    await launchUrl(url ?? Uri.parse(''));
                  }
                },
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
                onLoadStop: (controller, url) async {
                  //  controller.evaluateJavascript(source: jsString);

                  if (firstTime) {
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {
                      showSplash = false;
                      firstTime = false;
                    });
                  }
                },
                onProgressChanged: (controller, progress) {},
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
          ),
          if (showSplash) const SpashImage(),
        ]),
      ),
    );
  }

  Widget loading() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // _launchURL(String url) async {
  //   final uri = Uri(path: url);
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(
  //       Uri.parse(url),
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // _launchUrlWithScheme(String scheme, String path) async {
  //   final uri = Uri(path: path, scheme: scheme);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(
  //       uri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } else {
  //     throw 'Could not launch ${uri.path}';
  //   }
  // }
}
