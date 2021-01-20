import 'package:Fontana/models/fuente.dart';
import 'package:Fontana/src/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../states/log_in_state.dart';
import 'package:Fontana/src/services/user_service.dart';

class HomePage extends StatefulWidget {
  HomePage({this.app});
  final FirebaseApp app;
  //HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variables Database
  final referenceDatabase = FirebaseDatabase.instance;

  //Variables Auth
  User user;
  UserService _userService;

  //Variables Maps
  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int markers_count;
  MarkerId selectedMarker;
  double latitud;
  double longitud;

  //Variables Form
  TextEditingController _editingControllerNom;
  TextEditingController _editingControllerDesc;
  String nombre = "";
  String descripcion = "";
  String estado = "";

  //Variables Fuentes
  Map<int, Fuente> fuentes = <int, Fuente>{};

  void initState() {
    super.initState();
    _editingControllerNom = TextEditingController();
    _editingControllerDesc = TextEditingController();
  }

  /*void dispose() {
    _editingControllerNom.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    user = Provider.of<LoginState>(context, listen: false).user.user;
    _userService = new UserService(user);
    obtenerUbicacion();
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fontana'),
      ),
      body: Container(
        child: GoogleMap(
          buildingsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(zoom: 5.0, target: LatLng(40.416750, -3.703789)),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          obtenerUbicacion();
          addFuenteDialog(context);
        },
        label: Text('Añadir Fuente'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  /*void initMarkers() {
    //Inicializa la colección de markers con algunos en código
    Marker fuente_plaza_almassera = Marker(
        markerId: MarkerId('0'),
        position: LatLng(39.511720, -0.356001),
        //infoWindow: InfoWindow(title: 'Fuente plaza almassera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ));
    markers.add(fuente_plaza_almassera);
    Marker fuente_parque_almassera = Marker(
        onTap: () {
          infoFuente(context);
        },
        markerId: MarkerId('1'),
        position: LatLng(39.509590, -0.354083),
        //infoWindow: InfoWindow(title: 'Fuente parque almassera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan,
        ));
    markers.add(fuente_parque_almassera);
  }*/

  void addFuenteDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text('Añadir fuente:'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _editingControllerNom,
                    decoration: InputDecoration(
                        hintText: 'Nombre de la Fuente',
                        labelText: 'Nombre de la fuente',
                        helperText: 'Ej: Fuente del parque del colegio',
                        icon: Icon(Icons.account_circle),
                        //prefixIcon: Icon(Icons.title)
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onChanged: (String s) {
                      nombre = s;
                    },
                  ),
                  Divider(),
                  TextField(
                    controller: _editingControllerDesc,
                    decoration: InputDecoration(
                        hintText: 'Descripción',
                        labelText: 'Descripción',
                        helperText: 'Ej: Se encuentra cerca de un banco',
                        icon: Icon(Icons.account_circle),
                        //prefixIcon: Icon(Icons.title)
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onChanged: (String s) {
                      descripcion = s;
                    },
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Coordenadas: " +
                          latitud.toString() +
                          " " +
                          longitud.toString())
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () {
                    Fuente f = new Fuente(
                        nombre, descripcion, latitud, longitud, user);
                    setState(() {
                      fuentes[f.id] = f;
                    });
                    f.mostrarDatos();
                    addFuente(f);
                    Navigator.of(context).pop();
                  },
                  child: Text('Añadir fuente')),
            ],
          );
        });
  }

  void addFuente(Fuente f) {
    MarkerId mid = MarkerId(f.id.toString());
    Marker m = Marker(
      visible: true,
      markerId: mid,
      position: LatLng(f.latitud, f.longitud),
      infoWindow: InfoWindow(
        title: f.nombre,
        snippet: "Pulse para ver detalles",
        onTap: () {
          infoFuente(context, f);
        },
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        checkEstado(f),
      ),
    );
    /*MarkerId mid = MarkerId("1");
    Marker m = Marker(
        markerId: mid,
        position: LatLng(39.511720, -0.356001),
        //infoWindow: InfoWindow(title: 'Fuente plaza almassera'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ));*/
    setState(() {
      markers[mid] = m;
    });
  }

  //Aqui se debera pasar como parametro el ID de una fuente para
  //modificar la información
  void infoFuente(BuildContext context, Fuente f) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: RichText(
                text: TextSpan(
              text: f.nombre,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: 'Descripción: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: f.descripcion,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: 'Coordenadas: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: (f.latitud.toString() +
                                      ", " +
                                      f.longitud.toString()),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: 'Estado: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: f.estado,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: 'Añadida por: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: f.creada_por,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  void obtenerUbicacion() async {
    //Funciona
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitud = position.latitude;
      longitud = position.longitude;
    });
  }

  double checkEstado(Fuente f) {
    switch (f.estado) {
      case "Pendiente de Verificación":
        return BitmapDescriptor.hueCyan;
      case "Verificada":
        return BitmapDescriptor.hueAzure;
      default:
        return BitmapDescriptor.hueCyan;
    }
  }
}
