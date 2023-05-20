import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Track {
  mongo.ObjectId id;
  String name;
  bool isAssigned;
  Track({
    required this.id,
    required this.name,
    this.isAssigned = false,
  });

  Track.fromJson(Map<String, dynamic> json)
      : id = json['_id'].runtimeType == mongo.ObjectId
            ? json['_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['_id']),
        name = json['name'],
        isAssigned = json['is_assigned'];

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "is_assigned": isAssigned,
    };
  }
}
