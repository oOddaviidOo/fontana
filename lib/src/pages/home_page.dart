import 'dart:async';
import 'package:Fontana/src/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../states/log_in_state.dart';
import 'package:Fontana/src/services/user_service.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool _showAppBar = true;
  User user;
  UserService _userService;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoginState>(context, listen: false).user.user;
    _userService = new UserService(user);
    initMarkers();
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage: _userService.getImage(),
                        radius: 50,
                      ),
                      RichText(
                          text: TextSpan(
                              text: (_userService.getNombre()),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ))),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfilePage();
                    },
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Cerrar Sesión'),
                onTap: () {
                  if (Provider.of<LoginState>(context, listen: false)
                      .user
                      .user
                      .isAnonymous) {
                    Provider.of<LoginState>(context, listen: false)
                        .logoutAnonymous();
                  } else {
                    Provider.of<LoginState>(context, listen: false)
                        .logoutGoogle();
                  }
                },
              ),
            ],
          ),
        ),
        appBar:AppBar(
                centerTitle: true,
                title: Text('Fontana'),
              ), /*_showAppBar
            ? AppBar(
                centerTitle: true,
                title: Text('Fontana'),
              )
            : null,*/
        body: Container(
          child: GoogleMap(
            //onTap: (LatLng) => setState(() => _showAppBar = !_showAppBar),
            buildingsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(zoom: 5.0, target: LatLng(40.416750, -3.703789)),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
          ),
        ));
  }

  void initMarkers() {
    //Inicializa la colección de markers con algunos en código
    Marker fuente_plaza_almassera = Marker(
        markerId: MarkerId('0'),
        position: LatLng(39.511720, -0.356001),
        infoWindow: InfoWindow(title: 'Fuente plaza almassera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ));
    markers.add(fuente_plaza_almassera);
    Marker fuente_parque_almassera = Marker(
        markerId: MarkerId('1'),
        position: LatLng(39.509590, -0.354083),
        infoWindow: InfoWindow(title: 'Fuente parque almassera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan,
        ));
    markers.add(fuente_parque_almassera);
  }
}
