import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Tracking {
  mongo.ObjectId id;
  mongo.ObjectId routeId;
  double latitude;
  double longitude;
  int stopCovered;
  String updateTime;
  Tracking({
    required this.id,
    required this.routeId,
    required this.latitude,
    required this.longitude,
    required this.stopCovered,
    required this.updateTime,
  });

  Tracking.fromJson(Map<String, dynamic> json)
      : id = json['_id'].runtimeType == mongo.ObjectId
            ? json['_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['_id']),
        routeId = json['route_id'].runtimeType == mongo.ObjectId
            ? json['route_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['route_id']),
        latitude = json['latitude'],
        longitude = json['longitude'],
        stopCovered = json['stop_covered'],
        updateTime = json['update_time'];

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "route_id": routeId,
      "latitude": latitude,
      "longitude": longitude,
      "stop_covered": stopCovered,
      "update_time": updateTime,
    };
  }
}
