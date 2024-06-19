import 'package:flutter/material.dart';
import 'package:remote_health/utils/app_colors.dart';
import '../defaults/round_gradient_button.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../services/yt_api_service.dart';
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
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.channel.profilePictureUrl),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.channel.title,
                  style: TextStyle(
                    color: AppColors.primaryColor1,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.channel.subscriberCount} subscribers',
                  style: TextStyle(
                    color: AppColors.primaryColor2,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
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
            return Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            video.thumbnailUrl,
                            width: 100,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              video.title,
                              style: TextStyle(
                                color: AppColors.primaryColor1,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      RoundGradientButton(
                        title: "Watch",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoScreen(id: video.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
