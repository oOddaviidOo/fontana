import 'dart:async';

import 'package:Fontana/src/models/fuente.dart';
import 'package:Fontana/src/models/peticion.dart';
import 'package:Fontana/src/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
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
  DatabaseReference _fuentes;
  DatabaseReference _fuentesRef;
  DatabaseReference _peticionesRef;
  DatabaseReference _n_fuentesRef;
  DatabaseReference _n_peticionesRef;
  FirebaseList firebaseList;

  //Variables Auth
  User user;
  UserService _userService;

  //Variables Maps
  Timer timer;
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
  TextEditingController _editingControllerMot;
  String nombre = "";
  String descripcion = "";
  String estado = "";
  bool usarUbicacion = false;
  List<String> dropdownops = [
    "Verificada",
    "Averiada",
    "Pendiente de eliminacion",
    "Pendiente de cambio de ubicacion"
  ];
  String opdropdown = 'Verificada';
  String motivo;

  //Variables Fuentes
  Map<String, Fuente> fuentes = <String, Fuente>{};
  int n_fuentes;

  //Variables Peticiones
  Map<String, Peticion> peticiones = <String, Peticion>{};
  int n_peticiones;

  void initState() {
    timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => recargarMarcadores());
    user = Provider.of<LoginState>(context, listen: false).user.user;
    _userService = new UserService(user);
    obtenerUbicacion();
    FirebaseDatabase db = FirebaseDatabase();
    _fuentesRef = db.reference().child('fuentes');
    _peticionesRef = db.reference().child('peticiones');
    _n_fuentesRef = db.reference().child('n_fuentes');
    _n_peticionesRef = db.reference().child('n_peticiones');
    _editingControllerNom = TextEditingController();
    _editingControllerDesc = TextEditingController();
    _editingControllerLat = TextEditingController();
    _editingControllerLon = TextEditingController();
    _editingControllerMot = TextEditingController();
    obtenerNFuentes();
    obtenerNPeticiones();
    obtenerMarcadores();
    super.initState();
  }

  obtenerMarcadores() async {
    _fuentesRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        Map<dynamic, dynamic> fuentest = value;

        Fuente f = new Fuente(
            id: fuentest['id'].toString(), //Obtener valor n_fuentes de la bdd
            nombre: fuentest['nombre'].toString(),
            descripcion: fuentest['descripcion'].toString(),
            latitud: double.parse(fuentest['latitud'].toString()),
            longitud: double.parse(fuentest['longitud'].toString()),
            estado: fuentest['estado'].toString(),
            usuario: fuentest['usuario'].toString());

        if (filtrado) {
          if (f.estado == "Verificada") {
            fuentes[f.id] = f;
            addFuente(f);
          }
        } else {
          fuentes[f.id] = f;
          addFuente(f);
        }
      });
    });
  }

  void recargarMarcadores() {
    markers.clear();
    fuentes.clear();
    obtenerMarcadores();
    //Fluttertoast.showToast(msg: "Mapa actualizado");
  }

  obtenerNFuentes() async {
    _n_fuentesRef.once().then((DataSnapshot snapshot) {
      n_fuentes = int.parse(snapshot.value.toString());
    });
  }

  obtenerNPeticiones() async {
    _n_peticionesRef.once().then((DataSnapshot snapshot) {
      n_peticiones = int.parse(snapshot.value.toString());
    });
  }

  updateNFuentes() async {
    _n_fuentesRef.parent().update({"n_fuentes": n_fuentes});
  }

  updateNPeticiones() async {
    _n_peticionesRef.parent().update({"n_peticiones": n_peticiones});
  }

  void dispose() {
    _editingControllerNom.dispose();
    _editingControllerDesc.dispose();
    _editingControllerLat.dispose();
    _editingControllerLon.dispose();
    _editingControllerMot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (filtrado) {
                    Fluttertoast.showToast(
                        msg: "Mostrando solo fuentes verificadas");
                  } else {
                    Fluttertoast.showToast(msg: "Mostrando todas las fuentes");
                  }
                },
                child: filtrado
                    ? Icon(Icons.filter_alt)
                    : Icon(Icons.filter_alt_outlined)),
          ), /*
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    recargarMarcadores();
                  },
                  child: Icon(Icons.history)))*/
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

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();
    dropdownops.forEach((op) {
      lista.add(DropdownMenuItem(
        child: Text(op),
        value: op,
      ));
    });
    return lista;
  }

  void peticionDialog(Fuente f) {
    StateSetter _setState;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            title: RichText(
                text: TextSpan(
              text: ("Petición para " + f.nombre),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _editingControllerMot,
                      decoration: InputDecoration(
                          hintText: 'Motivo de la peticion',
                          labelText: 'Motivo de la peticion',
                          helperText: 'Verificar fuente/Fuente averiada',
                          //icon: Icon(Icons.account_circle),
                          //prefixIcon: Icon(Icons.title)
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (String s) {
                        motivo = s;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          text: 'Introduce el nuevo estado: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButton(
                            value: opdropdown,
                            items: getOpcionesDropdown(),
                            onChanged: (opt) {
                              setState(() {
                                opdropdown = opt;
                              });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar')),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          n_peticiones++;
                        });
                        String idt = "0" + n_peticiones.toString();
                        Peticion p = new Peticion(
                            id: idt, //Obtener valor n_fuentes de la bdd
                            idFuente: f.id,
                            motivo: motivo,
                            tipo: opdropdown,
                            usuario: _userService.getNombre());
                        setState(() {
                          peticiones[p.id] = p;
                        });
                        _peticionesRef.child(p.id).set({
                          "id": p.id,
                          "idFuente": p.idFuente,
                          "motivo": p.motivo,
                          "tipo": p.tipo,
                          "usuario": f.usuario,
                        }).asStream();
                        updateNPeticiones();
                        Fluttertoast.showToast(msg: "Peticion enviada");
                        Navigator.of(context).pop();
                      },
                      child: Text('Enviar petición')),
                ],
              )
            ],
          );
        });
  }

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
                    //Código para añadir fuente local
                    setState(() {
                      n_fuentes++;
                    });
                    String idt = "0" + n_fuentes.toString();
                    Fuente f = new Fuente(
                        id: idt, //Obtener valor n_fuentes de la bdd
                        nombre: nombre,
                        descripcion: descripcion,
                        latitud: latitud,
                        longitud: longitud,
                        usuario: _userService.getNombre());
                    setState(() {
                      fuentes[f.id] = f;
                    });
                    _fuentesRef.child(f.id).set({
                      "id": f.id,
                      "nombre": f.nombre,
                      "descripcion": f.descripcion,
                      "estado": "Pendiente de verificacion",
                      "latitud": f.latitud,
                      "longitud": f.longitud,
                      "usuario": f.usuario,
                    }).asStream();
                    updateNFuentes();
                    addFuente(f);
                    Navigator.of(context).pop();
                  },
                  child: Text('Añadir fuente')),
            ],
          );
        });
  }

  void addFuente(Fuente f) {
    MarkerId mid = MarkerId(f.id);
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
                                  text: f.usuario,
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
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Salir')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        peticionDialog(f);
                      },
                      child: Text('Enviar petición de actualización')),
                ],
              )
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
      case "Pendiente de verificación":
        return BitmapDescriptor.hueCyan;
      case "Verificada":
        return BitmapDescriptor.hueAzure;
      case "Averiada":
        return BitmapDescriptor.hueYellow;
      case "Pendiente de eliminacion":
        return BitmapDescriptor.hueRed;
      case "Pendiente de cambio de ubicacion":
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueCyan;
    }
  }
}
