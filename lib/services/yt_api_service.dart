import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remote_health/utils/constants.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';


class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();
  final String _baseUrl = 'www.googleapis.com';
  static const String API_KEY = YT_API_KEY;

  String? _nextPageToken;

  Future<Channel> fetchChannel({required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);
      channel.videos = await fetchVideosFromPlaylist(playlistId: data['contentDetails']['relatedPlaylists']['uploads']);
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '20',
      'key': API_KEY,
      if (_nextPageToken != null) 'pageToken': _nextPageToken!,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken']; // Save the next page token
      List<dynamic> items = data['items'];
      List<Video> videos = [];
      items.forEach((item) => videos.add(Video.fromMap(item['snippet'])));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
