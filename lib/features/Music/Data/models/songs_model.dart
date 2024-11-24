import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:on_audio_query_forked/on_audio_query.dart';

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
  @HiveField(4)
  final SongModel? songModel;

  SongsModel({
    this.name,
    this.path,
    this.selected = false,  
    this.songModel,
  });

  SongsModel copyWith({
    String? name,
    String? path,
    bool? selected,
    SongModel? songModel
  }) => SongsModel(
        name: name ?? this.name,
        path: path ?? this.path,
        selected: selected ?? this.selected,
        songModel:  songModel ?? this.songModel
      );

  factory SongsModel.fromMap(Map<String, dynamic> json) => SongsModel(
        name: json["name"],
        path: json["path"],
        selected: json['selected'] ?? false,
        songModel: json['songModel'] 
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "path": path,
        "selected": selected,
        "songModel": songModel
      };
}
