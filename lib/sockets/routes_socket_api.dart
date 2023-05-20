import '../header_files.dart';

class RoutesSocketApi {
  static late DbCollection collection;
  static final List<WebSocketChannel> _sockets = [];

  updateAllWs() async {
    final collsJson = await collection.find().toList();
    final String encodedColls = json.encode(collsJson);
    for (final ws in _sockets) {
      ws.sink.add(encodedColls);
    }
  }

  Handler get router {
    return webSocketHandler((WebSocketChannel socket) {
      socket.stream.listen((message) async {
        final data = json.decode(message);
        // function to Add
        print(data);
        if (data['action'] == 'ADD') {
          await collection.insert(Route.fromJson(data['payload']).toJson());
        }

        // function to delete
        if (data['action'] == 'DELETE') {
          await collection.deleteOne({
            '_id': ObjectId.fromHexString(data['payload']),
          });
        }

        if (data['action'] == 'DELETE_MULTIPLE') {
          final routesID = data['payload'] as List;
          for (int i = 0; i < routesID.length; i++) {
            await collection.deleteOne({
              '_id': ObjectId.fromHexString(routesID[i]),
            });
          }
        }
        // function to Update
        if (data['action'] == 'UPDATE') {
          final filter =
              where.eq('_id', ObjectId.fromHexString(data['payload']['_id']));
          await collection.replaceOne(
              filter, Route.fromJson(data['payload']).toJson());
        }

        updateAllWs();
      });

      _sockets.add(socket);
    });
  }
}
