import 'dart:core';
import 'package:get_it/get_it.dart';
import 'package:remote_health/services/database_service.dart';
import 'package:remote_health/services/media_service.dart';
import 'package:remote_health/services/storage_service.dart';
import 'dart:core' as string ;

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;

  getIt.registerSingleton<MediaService>(
      MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
  getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

string.String generateChatID({required string.String uid1, required string.String uid2}){
  List uids = [uid1, uid2];
  uids.sort();
  string.String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}