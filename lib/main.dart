import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const WavyApp());

class WavyApp extends StatelessWidget {
  const WavyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WAVY',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final List<String> videos = [
    'https://videos.pexels.com/video-files/7677252/7677252-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/5309381/5309381-hd_1080_1920_25fps.mp4',
    'https://videos.pexels.com/video-files/6141647/6141647-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/7677262/7677262-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/5309351/5309351-hd_1080_1920_25fps.mp4',
  ];

  final List<String> captions = [
    '@wavy - Dance vibes in Accra 🔥',
    '@wavy - Street style 💃',
    '@wavy - Real WAVY energy 🌊',
    '@wavy - Kumasi nights ✨',
    '@wavy - WAY-vee forever',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WAVY - WAY-vee',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _index == 0
          ? FeedPage(videos: videos, captions: captions)
          : _index == 1
              ? const UploadPage()
              : const ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white70,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  final List<String> videos;
  final List<String> captions;
  const FeedPage({super.key, required this.videos, required this.captions});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, i) {
        return VideoCard(url: videos[i], caption: captions[i]);
      },
    );
  }
}

class VideoCard extends StatefulWidget {
  final String url;
  final String caption;
  const VideoCard({super.key, required this.url, required this.caption});
  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _c;
  bool _liked = false;
  int likes = 124;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _ready = true);
          _c.play();
          _c.setLooping(true);
        }
      });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _ready
              ? AspectRatio(
                  aspectRatio: _c.value.aspectRatio,
                  child: VideoPlayer(_c),
                )
              : const CircularProgressIndicator(color: Colors.pink),
        ),
        Positioned(
          right: 12,
          bottom: 90,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.red : Colors.white,
                  size: 32,
                ),
                onPressed: () => setState(() {
                  _liked = !_liked;
                  likes += _liked ? 1 : -1;
                }),
              ),
              Text('$likes', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              const Icon(Icons.comment, color: Colors.white, size: 32),
              const Text('45', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              const Icon(Icons.share, color: Colors.white, size: 32),
            ],
          ),
        ),
        Positioned(
          left: 12,
          bottom: 24,
          child: Text(widget.caption,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ),
      ],
    );
  }
}

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_library, size: 80, color: Colors.pink),
            const SizedBox(height: 20),
            const Text('Upload your WAVY video',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Record a dance, lifestyle or street video and share it.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Upload coming in V3 - Feed is live now!')));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.all(18)),
              child: const Text('Tap to Upload Video',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          SizedBox(height: 12),
          Text('@wavy_user',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text('WAVY Creator - Kumasi, Ghana',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
