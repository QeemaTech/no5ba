//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget? child;
  const NoInternetScreen({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/no_internet.png', width: 150, height: 150),
              const SizedBox(height: 8),
              const Text(
                'no_internet_connection',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  // if (await Connectivity().checkConnectivity() !=
                  //     ConnectivityResult.none) {
                  //   Navigator.pop(context);
                  // }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: Center(
                        child: Icon(Icons.refresh,
                            size: 34, color: Theme.of(context).cardColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
