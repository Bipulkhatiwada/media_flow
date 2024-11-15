import 'package:hive/hive.dart';
import 'dart:convert';

part 'songs_model.g.dart';

SongsModel songsModelFromMap(String str) => SongsModel.fromMap(json.decode(str));

String songsModelToMap(SongsModel data) => json.encode(data.toMap());

@HiveType(typeId: 1)
class SongsModel {
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? path;
  @HiveField(3)
  final bool selected;

  SongsModel({
    this.name,
    this.path,
    this.selected = false,  
  });

  SongsModel copyWith({
    String? name,
    String? path,
    bool? selected,
  }) => SongsModel(
        name: name ?? this.name,
        path: path ?? this.path,
        selected: selected ?? this.selected,
      );

  factory SongsModel.fromMap(Map<String, dynamic> json) => SongsModel(
        name: json["name"],
        path: json["path"],
        selected: json['selected'] ?? false,  // Handle missing "selected" value
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "path": path,
        "selected": selected,
      };
}
