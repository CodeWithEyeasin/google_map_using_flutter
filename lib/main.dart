
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late GoogleMapController _mapController;


  Position? position;

  void initState(){
    super.initState();
    _onScreenStart();
    _listenCurrentLocation();


  }

  void _intializeMapSomting() async{
   print( await _mapController.getVisibleRegion());
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
      body: GoogleMap(
        // mapType: MapType.satellite,
        onMapCreated: (GoogleMapController controller){
          _mapController=controller;
          _intializeMapSomting();
        },
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(23.744287065983727, 90.3841376276092),
          zoom: 17,
          bearing: 90,
          tilt: 10,
        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onTap: (LatLng latLng){
          print('tapped on map: $latLng');
        },
        onLongPress: (LatLng latLng){
          print('on long press: $latLng');
        },
        compassEnabled: true,
        zoomGesturesEnabled: true,
        // liteModeEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('my new restaurant'),
            position: LatLng(23.74340878490067, 90.38375873118639),
            infoWindow: InfoWindow(title: 'My new restaurant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // draggable: true,
            // flat: true,

          ),
          Marker(
            markerId: MarkerId('my new club'),
            position: LatLng(23.743618395806028, 90.38642048835754),
            infoWindow: InfoWindow(title: 'My new restaurant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // draggable: true,
            // flat: true,

          ),
          Marker(
            markerId: MarkerId('my new hotel'),
            position: LatLng(23.744142881937513, 90.3815358504653),
            infoWindow: InfoWindow(title: 'My new restaurant'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            // draggable: true,
            // flat: true,

          ),

        },
        circles: {
          Circle(
            circleId: CircleId('my new restaurant'),
            center: LatLng(23.74340878490067, 90.38375873118639),
            radius:50,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            fillColor: Colors.orange.withOpacity(0.1),

          ),
          Circle(
            circleId: CircleId('my new restaurant for program'),
            center: LatLng(23.74534928409286, 90.38371179252863),
            radius:50,
            strokeColor: Colors.orange,
            strokeWidth: 3,
            fillColor: Colors.orange.withOpacity(0.15),
            onTap: (){
              print('tapped on circle');
            },
            consumeTapEvents: true,

          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('play one'),
            color: Colors.blueAccent,
            width: 5,
            points: [
              LatLng(23.74340878490067, 90.38375873118639),
              LatLng(23.74412324059908, 90.3860654309392),
              LatLng(23.744762196370548, 90.38322497159243),
            ],
          ),
        },
        polygons: {
          Polygon(polygonId: const PolygonId('random id'),
             fillColor: Colors.orange.withOpacity(0.4),
             strokeColor: Colors.orange,
             strokeWidth: 3,
             holes: [],///todo explore it by my self
             points: const [
               LatLng(23.743119073225813, 90.38128305226564),
               LatLng(23.74323538763032, 90.38242600858212),
               LatLng(23.744661841853137, 90.3815770894289),
               LatLng(23.74456516999717, 90.38112547248602)
             ],
          ),
        },
      ),
    );
  }
}

