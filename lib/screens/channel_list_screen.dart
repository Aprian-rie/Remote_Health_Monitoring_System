import 'package:flutter/material.dart';
import '../models/channel_model.dart';
import '../services/api_service.dart';
import 'video_list_screen.dart';

class ChannelListScreen extends StatefulWidget {
  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  final List<String> _channelIds = [
    'UC_x5XG1OV2P6uZZ5FSM9Ttw',
    'UC3w193M5tYPJqF0Hi-7U-2g',
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
        title: Text('YouTube Channels'),
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
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(channel.profilePictureUrl),
                ),
                title: Text(channel.title),
                subtitle: Text('${channel.subscriberCount} subscribers'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoListScreen(channel: channel),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
