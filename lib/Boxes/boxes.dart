
import 'package:hive/hive.dart';
import 'package:media_flow/features/Music/Data/models/songs_model.dart';

class Boxes{

  static Box<SongsModel> getData() => Hive.box<SongsModel>('songs');
  
}