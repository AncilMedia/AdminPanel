// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoDetailPage extends StatefulWidget {
//   final Map<String, dynamic> item;
//
//   const VideoDetailPage({Key? key, required this.item}) : super(key: key);
//
//   @override
//   _VideoDetailPageState createState() => _VideoDetailPageState();
// }
//
// class _VideoDetailPageState extends State<VideoDetailPage> {
//   VideoPlayerController? _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     final videoUrl = widget.item['mediaUrl']?.isNotEmpty == true
//         ? widget.item['mediaUrl']
//         : widget.item['fileUrl'];
//     if (videoUrl != null && videoUrl.isNotEmpty) {
//       _videoController = VideoPlayerController.network(videoUrl)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   void _openFullScreenVideo() {
//     final videoUrl = widget.item['mediaUrl']?.isNotEmpty == true
//         ? widget.item['mediaUrl']
//         : widget.item['fileUrl'] ??
//             "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
//
//     // Make sure mediaItemId is not null
//     final mediaItemId = widget.item['_id']?.toString(); // Convert to String
//     if (mediaItemId == null || mediaItemId.isEmpty) {
//       debugPrint("❌ mediaItemId is missing or invalid!");
//       return;
//     }
//
//     debugPrint('✅ MediaItemId: \\${widget.item['_id']}');
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             FullScreenVideoPage(videoUrl: videoUrl, mediaItemId: mediaItemId),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final imageUrl = widget.item['thumbnailUrl'] ??
//         "https://images.pexels.com/photos/1271620/pexels-photo-1271620.jpeg";
//     final videoUrl = widget.item['mediaUrl']?.isNotEmpty == true
//         ? widget.item['mediaUrl']
//         : widget.item['fileUrl'];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.item['title'] ?? 'Video Detail'),
//       ),
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: _videoController != null &&
//                     _videoController!.value.isInitialized
//                 ? VideoPlayer(_videoController!)
//                 : videoUrl != null && videoUrl.isNotEmpty
//                     ? VideoPlayer(VideoPlayerController.network(videoUrl))
//                     : Image.network(imageUrl, fit: BoxFit.cover),
//           ),
//           ElevatedButton(
//             onPressed: _openFullScreenVideo,
//             child: Text('Watch Full Screen'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FullScreenVideoPage extends StatelessWidget {
//   final String videoUrl;
//   final String mediaItemId;
//
//   const FullScreenVideoPage(
//       {Key? key, required this.videoUrl, required this.mediaItemId})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Full Screen Video'),
//       ),
//       body: Center(
//         child: VideoPlayer(VideoPlayerController.network(videoUrl)),
//       ),
//     );
//   }
// }