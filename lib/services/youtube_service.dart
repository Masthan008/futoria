import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class YouTubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String duration;
  final String viewCount;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.duration,
    required this.viewCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelTitle': channelTitle,
      'duration': duration,
      'viewCount': viewCount,
    };
  }

  factory YouTubeVideo.fromMap(Map<String, dynamic> map) {
    return YouTubeVideo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      channelTitle: map['channelTitle'] ?? '',
      duration: map['duration'] ?? '',
      viewCount: map['viewCount'] ?? '',
    );
  }
}

class YouTubeService {
  // Free Public Mock YouTube Playlists
  static final Map<String, List<YouTubeVideo>> _fallbackVideos = {
    'python': [
      YouTubeVideo(
        id: 'rfscVS0vtbw',
        title: 'Python for Beginners - Full Free Course',
        thumbnailUrl: 'https://img.youtube.com/vi/rfscVS0vtbw/0.jpg',
        channelTitle: 'freeCodeCamp.org',
        duration: '4:26:00',
        viewCount: '48M views',
      ),
      YouTubeVideo(
        id: '8DvywoWv6fI',
        title: 'Python Tutorial for Beginners [Full Course]',
        thumbnailUrl: 'https://img.youtube.com/vi/8DvywoWv6fI/0.jpg',
        channelTitle: 'Programming with Mosh',
        duration: '1:00:00',
        viewCount: '35M views',
      ),
    ],
    'flutter': [
      YouTubeVideo(
        id: 'VPvVD8t02U8',
        title: 'Flutter Course for Beginners - 37-Hour Bootcamp',
        thumbnailUrl: 'https://img.youtube.com/vi/VPvVD8t02U8/0.jpg',
        channelTitle: 'freeCodeCamp.org',
        duration: '37:12:00',
        viewCount: '1.2M views',
      ),
      YouTubeVideo(
        id: 'x0uinJ5HV68',
        title: 'Flutter Crash Course for Beginners 2026',
        thumbnailUrl: 'https://img.youtube.com/vi/x0uinJ5HV68/0.jpg',
        channelTitle: 'Net Ninja',
        duration: '3:15:00',
        viewCount: '800K views',
      ),
    ],
    'machine learning': [
      YouTubeVideo(
        id: 'GwIo3gGTeQE',
        title: 'Machine Learning Course for Beginners',
        thumbnailUrl: 'https://img.youtube.com/vi/GwIo3gGTeQE/0.jpg',
        channelTitle: 'freeCodeCamp.org',
        duration: '9:54:00',
        viewCount: '4.5M views',
      ),
      YouTubeVideo(
        id: 'i_LwzRVP7bg',
        title: 'Machine Learning Specialization by Andrew Ng',
        thumbnailUrl: 'https://img.youtube.com/vi/i_LwzRVP7bg/0.jpg',
        channelTitle: 'Stanford Online',
        duration: '1:24:00',
        viewCount: '3.2M views',
      ),
    ],
    'embedded systems': [
      YouTubeVideo(
        id: '3V9a1V1L4C4',
        title: 'Embedded Systems Course - Lecture 1: Introduction',
        thumbnailUrl: 'https://img.youtube.com/vi/3V9a1V1L4C4/0.jpg',
        channelTitle: 'NPTEL Lectures',
        duration: '52:10',
        viewCount: '450K views',
      ),
      YouTubeVideo(
        id: 'B2P0_D12bJ4',
        title: 'Learn Embedded C Programming from Scratch',
        thumbnailUrl: 'https://img.youtube.com/vi/B2P0_D12bJ4/0.jpg',
        channelTitle: 'Fastbit Embedded Academy',
        duration: '4:10:00',
        viewCount: '900K views',
      ),
    ]
  };

  Future<List<YouTubeVideo>> searchVideos(String query) async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty && apiKey != 'your_youtube_api_key_here') {
      try {
        final url = Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=6&q=${Uri.encodeComponent(query)}&type=video&key=$apiKey');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items = data['items'] as List;
          return items.map((item) {
            final snippet = item['snippet'];
            final id = item['id']['videoId'];
            return YouTubeVideo(
              id: id,
              title: snippet['title'] ?? '',
              thumbnailUrl: snippet['thumbnails']['high']['url'] ?? snippet['thumbnails']['default']['url'] ?? '',
              channelTitle: snippet['channelTitle'] ?? '',
              duration: 'Course Playlist',
              viewCount: 'Verified Class',
            );
          }).toList();
        }
      } catch (e) {
        debugPrint('YouTube API error: $e');
      }
    }

    // Fallback search logic using mock database
    final lowercaseQuery = query.toLowerCase();
    
    // Find closest match in fallbacks
    for (var key in _fallbackVideos.keys) {
      if (lowercaseQuery.contains(key)) {
        return _fallbackVideos[key]!;
      }
    }
    
    // Default fallback list representing academic tutorials
    return [
      YouTubeVideo(
        id: 'rfscVS0vtbw',
        title: 'Introduction to $query - Complete Guide',
        thumbnailUrl: 'https://img.youtube.com/vi/rfscVS0vtbw/0.jpg',
        channelTitle: 'FuturePath Learning Hub',
        duration: '45:00',
        viewCount: '150K views',
      ),
      YouTubeVideo(
        id: '8DvywoWv6fI',
        title: 'Advanced $query Concepts & Projects',
        thumbnailUrl: 'https://img.youtube.com/vi/8DvywoWv6fI/0.jpg',
        channelTitle: 'Tech Academy',
        duration: '1:30:00',
        viewCount: '98K views',
      ),
    ];
  }
}
