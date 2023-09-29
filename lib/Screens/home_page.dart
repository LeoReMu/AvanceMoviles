import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moviles/routes/routes.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:moviles/Screens/variables.dart' as globals;

String menuText = "";

late LatLng currentLocation = LatLng(25.67507, -100.31847);
bool addedMarker = false;

late double lat;
late double long;
late double in_lat;
late double in_long;
late String ID;
late String place_name;
late String place_desc;

Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _mapController = Completer();

  final id_Controller = TextEditingController();
  final lat_Controller = TextEditingController();
  final long_Controller = TextEditingController();
  final name_Controller = TextEditingController();
  final desc_Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLogged = globals.logged;

  @override
  void dispose() {
    id_Controller.dispose();
    lat_Controller.dispose();
    long_Controller.dispose();
    name_Controller.dispose();
    desc_Controller.dispose();
    super.dispose();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Los servicios de ubicación están desactivados.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Los permisos de ubicación fueron denegados.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Los permisos de ubicación fueron negados permanentemente, no se puede dar el permiso.");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogged == false) {
      menuText = "Menú";
    } else {
      menuText = globals.user;
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          addMarker('my_location', currentLocation, "Mi ubicación",
              "Ubicación actual", false);
          dev.log("addedMarker: $addedMarker");
          if (addedMarker == true) {
            addMarker(ID, LatLng(lat, long), place_name, place_desc, true);
          }
          _mapController.complete(controller);
        },
        markers: Set<Marker>.of(_markers.values),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.my_location),
              color: Colors.white,
              onPressed: () async {
                await _getCurrentLocation().then((value) {
                  lat = value.latitude;
                  long = value.longitude;
                  setState(() {
                    currentLocation = LatLng(lat, long);
                    Navigator.pushReplacementNamed(context, routes.HOME);
                  });
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_location),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text("Agregar nueva ubicación"),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Identificador",
                                  icon: Icon(Icons.tag),
                                ),
                                controller: id_Controller,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Ingresa un identificador (cualquier cosa que ayude a identificar el negocio).';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Latitud",
                                  icon: Icon(Icons.location_on),
                                ),
                                controller: lat_Controller,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Ingresa la coordenada de latitud.';
                                  } else if (double.tryParse(value!) == null) {
                                    return "La coordenada debe ser un valor numérico.";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Longitud",
                                  icon: Icon(Icons.location_on),
                                ),
                                controller: long_Controller,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Ingresa la coordenada de longitud.';
                                  } else if (double.tryParse(value!) == null) {
                                    return "La coordenada debe ser un valor numérico.";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Nombre del lugar",
                                  icon: Icon(Icons.text_fields),
                                ),
                                controller: name_Controller,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Ingresa el nombre del negocio.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Descripción del servicio",
                                  icon: Icon(Icons.miscellaneous_services),
                                ),
                                controller: desc_Controller,
                                validator: (value) {
                                  if (value?.isEmpty == true) {
                                    return 'Ingresa una descripción';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text("Enviar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              ID = id_Controller.text;
                              lat = double.parse(lat_Controller.text);
                              long = double.parse(long_Controller.text);
                              place_name = name_Controller.text;
                              place_desc = desc_Controller.text;
                              addedMarker = true;
                              Navigator.pop(context);
                              setState(() {
                                Navigator.pushReplacementNamed(
                                    context, routes.HOME);
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(menuText),
            ),
            ListTile(
              title: const Text('Iniciar sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, routes.INICIARSESION);
              },
            ),
            ListTile(
              title: const Text('Registro'),
              onTap: () {
                Navigator.pushReplacementNamed(context, routes.REGISTRARSE);
              },
            ),
          ],
        ),
      ),
    );
  }

  addMarker(String id, LatLng location, String t, String desc, bool toggle) {
    final marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: t,
        snippet: desc,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          (toggle) ? BitmapDescriptor.hueYellow : BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers[MarkerId(id)] = marker;
    });
  }
}
