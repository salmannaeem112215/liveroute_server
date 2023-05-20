import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Stop {
  mongo.ObjectId id;
  mongo.ObjectId trackId;
  String name;
  String time;
  bool isStop;
  int stopNo;
  double latitude;
  double longitude;

  Stop({
    required this.id,
    required this.trackId,
    required this.name,
    required this.time,
    required this.isStop,
    required this.stopNo,
    required this.latitude,
    required this.longitude,
  });

  Stop.fromJson(Map<String, dynamic> json)
      : id = json['_id'].runtimeType == mongo.ObjectId
            ? json['_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['_id']),
        trackId = json['track_id'].runtimeType == mongo.ObjectId
            ? json['track_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['track_id']),
        name = json['name'],
        time = json['time'],
        isStop = json['is_stop'],
        stopNo = json['stop_no'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        "_id": id,
        "track_id": trackId,
        "name": name,
        "time": time,
        "is_stop": isStop,
        "stop_no": stopNo,
        "latitude": latitude,
        "longitude": longitude,
      };
}
