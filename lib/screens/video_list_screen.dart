import 'package:flutter/material.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';
import 'video_screen.dart';

class VideoListScreen extends StatefulWidget {
  final Channel channel;

  const VideoListScreen({Key? key, required this.channel}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!_isLoading &&
              scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent) {
            _loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: widget.channel.videos.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.channel.videos.length) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox.shrink();
            }
            Video video = widget.channel.videos[index];
            return ListTile(
              leading: Image.network(video.thumbnailUrl),
              title: Text(video.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(id: video.id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    setState(() {
      _isLoading = true;
    });
    List<Video> moreVideos = await APIService.instance.fetchVideosFromPlaylist(
      playlistId: widget.channel.uploadPlaylistId,
    );
    setState(() {
      widget.channel.videos.addAll(moreVideos);
      _isLoading = false;
    });
  }
}
