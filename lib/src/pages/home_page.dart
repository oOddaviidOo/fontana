import 'package:Fontana/models/fuente.dart';
import 'package:Fontana/src/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
  //Variables
  bool filtrado = false;

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
  TextEditingController _editingControllerLat;
  TextEditingController _editingControllerLon;
  String nombre = "";
  String descripcion = "";
  String estado = "";
  bool usarUbicacion = false;

  //Variables Fuentes
  Map<int, Fuente> fuentes = <int, Fuente>{};

  void initState() {
    super.initState();
    _editingControllerNom = TextEditingController();
    _editingControllerDesc = TextEditingController();
    _editingControllerLat = TextEditingController();
    _editingControllerLon = TextEditingController();
  }

  /*void dispose() {
    _editingControllerNom.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoginState>(context, listen: false).user.user;
    _userService = new UserService(user);
    final ref = referenceDatabase.reference();
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
                  if (_userService.getProvider() == "google.com") {
                    Provider.of<LoginState>(context, listen: false)
                        .logoutGoogle();
                  }
                  Provider.of<LoginState>(context, listen: false).logoutEmail();
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fontana'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    filtrado = !filtrado;
                  });
                },
                child: filtrado
                    ? Icon(Icons.filter_alt)
                    : Icon(Icons.filter_alt_outlined)),
          )
        ],
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
      floatingActionButton: Opacity(
        opacity: user.isAnonymous ? 0 : 1,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (user.isAnonymous) {
            } else {
              obtenerUbicacion();
              addFuenteDialog(context);
            }
          },
          label: Text('Añadir Fuente'),
          icon: Icon(Icons.add),
        ),
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
    StateSetter _setState;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: Text('Añadir fuente:'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _editingControllerNom,
                        decoration: InputDecoration(
                            hintText: 'Nombre de la Fuente',
                            labelText: 'Nombre de la fuente',
                            helperText: 'Ej: Fuente del parque del colegio',
                            //icon: Icon(Icons.account_circle),
                            //prefixIcon: Icon(Icons.title)
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onChanged: (String s) {
                          nombre = s;
                        },
                      ),
                      Divider(),
                      TextFormField(
                        controller: _editingControllerDesc,
                        decoration: InputDecoration(
                            hintText: 'Descripción',
                            labelText: 'Descripción',
                            helperText: 'Ej: Se encuentra cerca de un banco',
                            //icon: Icon(Icons.account_circle),
                            //prefixIcon: Icon(Icons.title)
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onChanged: (String s) {
                          descripcion = s;
                        },
                      ),
                      Divider(),
                      SwitchListTile(
                          title: RichText(
                              text: TextSpan(
                            text: "Usar ubicación/Escribir coordenadas",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                          value: usarUbicacion,
                          onChanged: (value) {
                            setState(() {
                              usarUbicacion = value;
                            });
                          }),
                      Divider(),
                      TextFormField(
                        enabled: usarUbicacion,
                        controller: _editingControllerLat,
                        //keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Latitud',
                            labelText: 'Latitud',
                            helperText:
                                'Ej: Latitud actual: ' + latitud.toString(),
                            //icon: Icon(Icons.account_circle),
                            //prefixIcon: Icon(Icons.title)
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onChanged: (String s) {
                          double d = double.parse(s);
                          latitud = d;
                          Fluttertoast.showToast(msg: latitud.toString());
                        },
                      ),
                      Divider(),
                      TextFormField(
                        enabled: usarUbicacion,
                        controller: _editingControllerLon,
                        //keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Longitud',
                            labelText: 'Longitud',
                            helperText:
                                'Ej: Longitud actual: ' + longitud.toString(),
                            //icon: Icon(Icons.account_circle),
                            //prefixIcon: Icon(Icons.title)
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onChanged: (String s) {
                          double d = double.parse(s);
                          longitud = d;
                          Fluttertoast.showToast(msg: longitud.toString());
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
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
                  child: Text('Salir')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Enviar petición de cambio de información')),
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
