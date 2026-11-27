import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const WavyApp());
class WavyApp extends StatelessWidget {
  const WavyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'WAVY', theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black), home: const HomePage());
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _index = 0;
  // REAL videos - real people dancing / lifestyle / street
  List<String> videos = [
    'https://videos.pexels.com/video-files/7677252/7677252-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/5309381/5309381-hd_1080_1920_25fps.mp4',
    'https://videos.pexels.com/video-files/6141647/6141647-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/7677262/7677262-hd_1080_1920_30fps.mp4',
    'https://videos.pexels.com/video-files/5309351/5309351-hd_1080_1920_25fps.mp4',
  ];
  List<String> captions = ['@wavy - Dance vibes in Accra 🔥','@wavy - Street style 💃','@wavy - Real WAVY energy 🌊','@wavy - Kumasi nights ✨','@wavy - WAY-vee forever'];
  File? myVideo;

  Future<void> pickVideo() async {
    final XFile? f = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (f != null) { setState(() { myVideo = File(f.path); _index = 0; }); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video added to your feed!'))); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WAVY - WAY-vee', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Colors.black),
      body: _index == 0 ? FeedPage(videos: videos, captions: captions, myVideo: myVideo) : _index == 1 ? Center(child: ElevatedButton(onPressed: pickVideo, style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.all(20)), child: const Text('Tap to Upload REAL Video From Your Phone', style: TextStyle(fontSize: 16)))) : const ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black, selectedItemColor: Colors.pink, unselectedItemColor: Colors.white70, currentIndex: _index, onTap: (i) => setState(() => _index = i), items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'), BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Upload'), BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')]),
    );
  }
}
class FeedPage extends StatelessWidget {
  final List<String> videos; final List<String> captions; final File? myVideo;
  const FeedPage({super.key, required this.videos, required this.captions, this.myVideo});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: videos.length + (myVideo != null ? 1 : 0), itemBuilder: (context, i) {
      if (myVideo != null && i == 0) return VideoCardFile(file: myVideo!, caption: '@you - My real WAVY video 🔥');
      int idx = myVideo != null ? i - 1 : i;
      return VideoCard(url: videos[idx], caption: captions[idx]);
    });
  }
}
class VideoCard extends StatefulWidget {
  final String url; final String caption; const VideoCard({super.key, required this.url, required this.caption});
  @override
  State<VideoCard> createState() => _VideoCardState();
}
class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _c; bool _liked = false; int likes = 124;
  @override
  void initState() { super.initState(); _c = VideoPlayerController.networkUrl(Uri.parse(widget.url))..initialize().then((_) { setState((){}); _c.play(); _c.setLooping(true); }); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(child: _c.value.isInitialized ? AspectRatio(aspectRatio: _c.value.aspectRatio, child: VideoPlayer(_c)) : const CircularProgressIndicator()),
      Positioned(right: 12, bottom: 90, child: Column(children: [IconButton(icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? Colors.red : Colors.white, size: 32), onPressed: () => setState(() { _liked = !_liked; likes += _liked ? 1 : -1; })), Text('$likes', style: const TextStyle(color: Colors.white)), const SizedBox(height: 12), const Icon(Icons.comment, color: Colors.white, size: 32), const Text('45', style: TextStyle(color: Colors.white)), const SizedBox(height: 12), const Icon(Icons.share, color: Colors.white, size: 32)])),
      Positioned(left: 12, bottom: 24, child: Text(widget.caption, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
    ]);
  }
}
class VideoCardFile extends StatefulWidget {
  final File file; final String caption; const VideoCardFile({super.key, required this.file, required this.caption});
  @override
  State<VideoCardFile> createState() => _VideoCardFileState();
}
class _VideoCardFileState extends State<VideoCardFile> {
  late VideoPlayerController _c;
  @override
  void initState() { super.initState(); _c = VideoPlayerController.file(widget.file)..initialize().then((_) { setState((){}); _c.play(); _c.setLooping(true); }); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) { return Stack(children: [Center(child: _c.value.isInitialized ? AspectRatio(aspectRatio: _c.value.aspectRatio, child: VideoPlayer(_c)) : const CircularProgressIndicator()), Positioned(left: 12, bottom: 24, child: Text(widget.caption, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]); }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)), SizedBox(height: 12), Text('@wavy_user', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text('WAVY Creator - Kumasi, Ghana', style: TextStyle(color: Colors.white70))])); }
}
