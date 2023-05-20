import '../header_files.dart';

class BusesSocketApi {
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

        if (data['action'] == 'ADD') {
          await collection.insert(Bus.addBusJson(data['payload']));
        }

        if (data['action'] == 'DELETE') {
          await collection.deleteOne({
            '_id': ObjectId.fromHexString(data['payload']),
            // '_id': data['payload'],
          });
        }
        if (data['action'] == 'DELETE_MULTIPLE') {
          final busesID = data['payload'] as List;
          for (int i = 0; i < busesID.length; i++) {
            await collection.deleteOne({
              '_id': ObjectId.fromHexString(busesID[i]),
            });
          }
        }

        if (data['action'] == 'UPDATE') {
          final filter =
              where.eq('_id', ObjectId.fromHexString(data['payload']));
          await collection.replaceOne(filter, Bus.addBusJson(data['payload']));

          // collection
        }

        updateAllWs();
      });

      _sockets.add(socket);
    });
  }
}
