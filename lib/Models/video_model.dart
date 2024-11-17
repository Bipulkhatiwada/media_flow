// To parse this JSON data, do
//
//     final videoModel = videoModelFromMap(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:io';

part 'video_model.g.dart';

VideoModel videoModelFromMap(String str) => VideoModel.fromMap(json.decode(str));

String videoModelToMap(VideoModel data) => json.encode(data.toMap());

@HiveType(typeId: 1)
class VideoModel {
    @HiveField(1)
    final String? name;
    @HiveField(2)
    final String? path;
    @HiveField(3)
    final String? thumbnail;

    // New variable
    final File? videoFile;

    VideoModel({
        this.name,
        this.path,
        this.thumbnail,
        this.videoFile, // Initialize new variable
    });

    VideoModel copyWith({
        String? name,
        String? path,
        String? thumbnail,
        File? videoFile,
    }) => 
        VideoModel(
            name: name ?? this.name,
            path: path ?? this.path,
            thumbnail: thumbnail ?? this.thumbnail,
            videoFile: videoFile ?? this.videoFile, // Add to copyWith
        );

    factory VideoModel.fromMap(Map<String, dynamic> json) => VideoModel(
        name: json["name"],
        path: json["path"],
        thumbnail: json["thumbnail"],
        // Exclude videoFile from JSON deserialization
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "path": path,
        "thumbnail": thumbnail,
        // Exclude videoFile from JSON serialization
    };
}