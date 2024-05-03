
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

main(){
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Position? position;

  void initState(){
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();

  }

  //GPS Service Enable/disable
  //App permission enable?
  //getlocation -once
  // listen location

  Future<void> _onScreenStart() async{
    bool isEnable =await Geolocator.isLocationServiceEnabled();
print(isEnable);

print(await Geolocator.getLastKnownPosition());
    LocationPermission permission= await Geolocator.checkPermission();

if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
   position=await Geolocator.getCurrentPosition();
}else{
  LocationPermission requestStatus= await Geolocator.requestPermission();
  if(requestStatus==LocationPermission.whileInUse || requestStatus==LocationPermission.always){
    _onScreenStart();

  }
}



  }
  void _listenCurrentLocation(){
    Geolocator.getPositionStream(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
      // timeLimit: Duration(seconds: 3),
      /// (this is only for real device)
    )).listen((p) {
print(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text(
            'Current Location ${position?.latitude }, ${position?.longitude}'),

      ),
    );
  }
}

