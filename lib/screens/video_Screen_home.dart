import 'package:flutter/material.dart';
import 'package:remote_health/models/channel_model.dart';
import 'package:remote_health/screens/video_screen.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';

class VideoScreenHome extends StatefulWidget {
  const VideoScreenHome({Key? key}) : super(key: key);

  @override
  State<VideoScreenHome> createState() => _VideoScreenHomeState();
}

class _VideoScreenHomeState extends State<VideoScreenHome> {
  late Future<Channel> _channelFuture;

  @override
  void initState() {
    super.initState();
    _channelFuture = _initChannel();
  }

  Future<Channel> _initChannel() async {
    return await APIService.instance
        .fetchChannel(channelId: 'UC3w193M5tYPJqF0Hi-7U-2g');
  }

  Widget _buildProfileInfo(Channel channel) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(channel.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  channel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${channel.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMoreVideos(Channel channel) async {
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);
    setState(() {
      channel.videos.addAll(moreVideos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Channel'),
      ),
      body: FutureBuilder<Channel>(
        future: _channelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          Channel channel = snapshot.data!;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
              if (scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent &&
                  channel.videos.length != int.parse(channel.videoCount)) {
                _loadMoreVideos(channel);
              }
              return false;
            },
            child: ListView.builder(
              itemCount: 1 + channel.videos.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildProfileInfo(channel);
                }
                Video video = channel.videos[index - 1];
                return _buildVideo(video);
              },
            ),
          );
        },
      ),
    );
  }
}
