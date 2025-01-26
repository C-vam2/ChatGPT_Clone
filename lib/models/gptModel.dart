import 'package:flutter/material.dart';

class GptModel {
  late String object;
  late List<Data> data;

  GptModel({required this.object, required this.data});

  GptModel.fromJson(Map<String, dynamic> json) {
    object = json['object'] ?? '';
    data = (json['data'] as List<dynamic>?)
            ?.map((v) => Data.fromJson(v as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    return {
      'object': object,
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  late String id;
  late String object;
  late int created;
  late String ownedBy;

  Data({
    required this.id,
    required this.object,
    required this.created,
    required this.ownedBy,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    object = json['object'] ?? '';
    created = json['created'] ?? 0;
    ownedBy = json['owned_by'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'owned_by': ownedBy,
    };
  }
}
