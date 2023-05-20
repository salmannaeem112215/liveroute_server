import '../header_files.dart';

class StopsSocketApi {
  static late DbCollection collection;
  static final List<WebSocketChannel> _sockets = [];

  static updateAllWs() async {
    final collsJson = await collection.find().toList();
    final String encodedColls = json.encode(collsJson);
    for (final ws in _sockets) {
      ws.sink.add(encodedColls);
    }
  }

  static deleteAllStops(ObjectId trackId) async {
    final res = await collection.deleteMany({'track_id': trackId});
    if (res.isSuccess) {
      updateAllWs();
    }
  }

  Handler get router {
    return webSocketHandler((WebSocketChannel socket) {
      socket.stream.listen((message) async {
        final data = json.decode(message);
        print(data);
        if (data['action'] == 'ADD') {
          await collection.insertOne(Stop.fromJson(data['payload']).toJson());
        }

        if (data['action'] == 'DELETE') {
          await collection.deleteOne({
            '_id': ObjectId.fromHexString(data['payload']),
            // '_id': data['payload'],
          });
        }
        if (data['action'] == 'DELETE_MULTIPLE') {
          final adminsID = data['payload'] as List;
          for (int i = 0; i < adminsID.length; i++) {
            await collection.deleteOne({
              '_id': ObjectId.fromHexString(adminsID[i]),
            });
          }
        }

        if (data['action'] == 'UPDATE') {
          final filter =
              where.eq('_id', ObjectId.fromHexString(data['payload']['_id']));
          await collection.replaceOne(
              filter, Stop.fromJson(data['payload']).toJson());
        }

        updateAllWs();
      });

      _sockets.add(socket);
    });
  }
}
