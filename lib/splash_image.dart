import 'package:animate_do/animate_do.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:webviewApp/utils.dart';

class SpashImage extends StatefulWidget {
  const SpashImage({super.key});

  @override
  State<SpashImage> createState() => _SpashImageState();
}

class _SpashImageState extends State<SpashImage> {
  //StreamSubscription<List<ConnectivityResult>>? subscription;

  @override
  void initState() {
    super.initState();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((List<ConnectivityResult> result) {
    //   if (result.first == ConnectivityResult.none) {
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const NoInternetScreen()));
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    //subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Center(
        child: ZoomIn(
          child: Image.asset(
            'assets/elitepioneer.png',
            width: MediaQuery.sizeOf(context).width * 0.8,
            fit: BoxFit.scaleDown,
          ),
          animate: true,
          duration: Duration(milliseconds: 0),
        ),
      ),
    );
  }
}
