import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: NativeAdExample(),
  ));
}


///An App to demonstrate how to use admob native ads in flutter
///make sure to change the value of APPLICATION_ID in android manifest
///make sure to use a real ad unit id from admob and change it below

class NativeAdExample extends StatefulWidget {
  const NativeAdExample({Key? key}) : super(key: key);

  @override
  _NativeAdExampleState createState() => _NativeAdExampleState();
}

class _NativeAdExampleState extends State<NativeAdExample> {
  
  late NativeAd _ad;
  bool isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    loadNativeAd();
  }

  ///Important make sure to dispose the ad when disposing the screen
  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }


  void loadNativeAd() {
    _ad = NativeAd(
      request: const AdRequest(),
      ///This is a test adUnitId make sure to change it
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (ad){
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error){
          ad.dispose();
          print('failed to load the ad ${error.message}, ${error.code}');
        }
      )
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Native Ad'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index){
            if(isLoaded && index == 2){
              return Container(
                child: AdWidget(ad: _ad,),
                alignment: Alignment.center,
                height: 170,
                color: Colors.black12,
              );
            }else{
              return ListTile(
                title: Text('Item ${index + 1}'),
                leading: const FlutterLogo(size: 25,),
                subtitle: Text('Sub Title for item ${index + 1}'),
              );
            }

            }
        ),
      ),
    );
  }
}


