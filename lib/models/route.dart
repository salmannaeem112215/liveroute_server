import 'package:mongo_dart/mongo_dart.dart' as mongo;

enum RouteType { morning, evening, speacial }

class Route {
  mongo.ObjectId id;
  String name;
  RouteType type;
  mongo.ObjectId? trackId;
  mongo.ObjectId? busId;
  mongo.ObjectId? driverId;

  Route({
    required this.id,
    required this.name,
    required this.type,
    this.trackId,
    this.busId,
    this.driverId,
  });

  Route.fromJson(Map<String, dynamic> json)
      : id = json['_id'].runtimeType == mongo.ObjectId
            ? json['_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['_id']),
        name = json['name'],
        type = stringToRouteType(json['type'] as String),
        trackId = json['track_id'] == null
            ? null
            : json['track_id'].runtimeType == mongo.ObjectId
                ? json['track_id'] as mongo.ObjectId
                : mongo.ObjectId.fromHexString(json['track_id']),
        driverId = json['driver_id'] == null
            ? null
            : json['driver_id'].runtimeType == mongo.ObjectId
                ? json['driver_id'] as mongo.ObjectId
                : mongo.ObjectId.fromHexString(json['driver_id']),
        busId = json['bus_id'] == null
            ? null
            : ['bus_id'].runtimeType == mongo.ObjectId
                ? json['bus_id'] as mongo.ObjectId
                : mongo.ObjectId.fromHexString(json['bus_id']);

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "type": routeTypeToString(type),
      "track_id": trackId,
      "driver_id": driverId,
      "bus_id": busId,
    };
  }

  static RouteType stringToRouteType(String routeType) {
    if (routeType == 'Morning') {
      return RouteType.morning;
    } else if (routeType == 'Evening') {
      return RouteType.evening;
    } else {
      return RouteType.speacial;
    }
  }

  static String routeTypeToString(RouteType routeType) {
    if (routeType == RouteType.morning) {
      return 'Morning';
    } else if (routeType == RouteType.evening) {
      return 'Evening';
    } else {
      return 'Special';
    }
  }
}
