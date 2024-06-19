import 'package:flutter/material.dart';
import '../models/channel_model.dart';
import '../services/yt_api_service.dart';
import 'video_list_screen.dart';
import 'package:remote_health/utils/app_colors.dart';

class ChannelListScreen extends StatefulWidget {
  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  final List<String> _channelIds = [
    'UC3w193M5tYPJqF0Hi-7U-2g',
    'UC5IuDMmKWSsBFB0iKky6aEQ',
    'UCSATV6ZymNE6JjeSwxkR_Zg',
    'UCcq3qLvD6SGFjc839swT9ww',
    'UCts5L1iBQ-ALfy9ozfE40BA',
    'UCvl3G9J0vL4sEPceehnVTKw',
    'UCDcbw8HYti10aPMUZXRJE6Q',
    // Add more channel IDs here
  ];

  late Future<List<Channel>> _channels;

  @override
  void initState() {
    super.initState();
    _channels = _fetchChannels();
  }

  Future<List<Channel>> _fetchChannels() async {
    List<Channel> channels = [];
    for (String id in _channelIds) {
      Channel channel = await APIService.instance.fetchChannel(channelId: id);
      channels.add(channel);
    }
    return channels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Youtube ",
              style: TextStyle(
                  color: AppColors.primaryColor1,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Channels",
              style: TextStyle(
                  color: AppColors.primaryColor2,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Channel>>(
        future: _channels,
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

          List<Channel> channels = snapshot.data!;
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              Channel channel = channels[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoListScreen(channel: channel),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                                    color: AppColors.primaryColor1,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${channel.subscriberCount} subscribers',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor1,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}