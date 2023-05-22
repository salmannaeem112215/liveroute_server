import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRestApi {
  AuthRestApi();

  static late DbCollection admins;
  static late DbCollection drivers;
  static late DbCollection members;

  Handler get router {
    final app = Router();

    app.get('/', (Request req) async {
      final contacts = await admins.find().toList();
      return Response.ok(
        json.encode({'contacts': contacts}),
        headers: {
          'Content-Type': ContentType.json.mimeType,
        },
      );
    });

    app.post('/', (Request req) async {
      final payload = await req.readAsString();
      final data = json.decode(payload);

      await admins.insert(data);
      final addedEntry = await admins.findOne(where.eq('name', data['name']));

      return Response(
        HttpStatus.created,
        body: json.encode(addedEntry),
        headers: {
          'Content-Type': ContentType.json.mimeType,
        },
      );
    });

    app.delete('/<id|.+>', (Request req, String id) async {
      await admins.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
      return Response.ok('Deleted $id');
    });

    return app;
  }
}
