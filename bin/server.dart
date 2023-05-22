import 'dart:io';

import 'package:liveroute/header_files.dart';
import 'package:liveroute/rest/contacts_rest_api.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  // Connect and load collection
  final db = await Db.create(MONGO_CONN_URL);
  await db.open();

  // WEBSOCKETS
  BusesSocketApi.collection = db.collection(BUSES_COLLECTION);
  RoutesSocketApi.collection = db.collection(ROUTES_COLLECTION);
  MembersSocketApi.collection = db.collection(MEMBERS_COLLECTION);
  AdminsSocketApi.collection = db.collection(ADMINS_COLLECTION);
  DriversSocketApi.collection = db.collection(DRIVERS_COLLECTION);
  TracksSocketApi.collection = db.collection(TRACKS_COLLECTION);
  TrackingsSocketApi.collection = db.collection(TRACKINGS_COLLECTION);
  StopsSocketApi.collection = db.collection(STOPS_COLLECTION);
  PathsSocketApi.collection = db.collection(PATHS_COLLECTION);

  // Rest API
  AuthRestApi.admins = db.collection(ADMINS_COLLECTION);
  AuthRestApi.drivers = db.collection(DRIVERS_COLLECTION);
  AuthRestApi.members = db.collection(MEMBERS_COLLECTION);

  // Create server
  final app = Router();

  // Create routes
  // WEBSOCKETS
  app.mount('/$TRACKINGS_WEBSOCKET', TrackingsSocketApi().router);
  app.mount('/$BUSES_WEBSOCKET', BusesSocketApi().router);
  app.mount('/$ROUTES_WEBSOCKET', RoutesSocketApi().router);
  app.mount('/$ADMINS_WEBSOCKET', AdminsSocketApi().router);
  app.mount('/$DRIVERS_WEBSOCKET', DriversSocketApi().router);
  app.mount('/$MEMBERS_WEBSOCKET', MembersSocketApi().router);
  app.mount('/$PATHS_WEBSOCKET', PathsSocketApi().router);
  app.mount('/$STOPS_WEBSOCKET', StopsSocketApi().router);
  app.mount('/$TRACKS_WEBSOCKET', TracksSocketApi().router);
  //REST API
  app.mount('/$AUTH_REST_API', AuthRestApi().router);

  // Listen for incoming connections
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, PORT));

  print('Server listing at port $PORT');
}
