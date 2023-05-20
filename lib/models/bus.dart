import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Bus {
  mongo.ObjectId id;
  String numberPlate;
  int modelNo;
  bool isWorking;
  Bus({
    required this.id,
    required this.numberPlate,
    required this.modelNo,
    this.isWorking = true,
  });

  Bus.fromJson(Map<String, dynamic> json)
      : id = json['_id'].runtimeType == mongo.ObjectId
            ? json['_id'] as mongo.ObjectId
            : mongo.ObjectId.fromHexString(json['_id']),
        numberPlate = json['number_plate'],
        modelNo = json['model_no'],
        isWorking = json['is_working'];

  Bus.fromDecodedJson(Map<String, dynamic> json)
      : id = mongo.ObjectId.fromHexString(json['_id']),
        numberPlate = json['number_plate'],
        modelNo = json['model_no'],
        isWorking = json['is_working'];

  static Map<String, dynamic> addBusJson(Map<String, dynamic> json) {
    return {
      "_id": mongo.ObjectId.fromHexString(json['_id']),
      "number_plate": json['number_plate'],
      "model_no": json['model_no'],
      "is_working": json['is_working'],
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "number_plate": numberPlate,
      "model_no": modelNo,
      "is_working": isWorking,
    };
  }
}
