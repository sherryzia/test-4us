import 'package:flutter/material.dart';

class ChallengeProgressScreen extends StatefulWidget {
  final String imagePath;
  final String name;
  final String progress;

  const ChallengeProgressScreen({
    super.key,
    required this.imagePath,
    required this.name,
    required this.progress,
  });

  @override
  State<ChallengeProgressScreen> createState() =>
      _ChallengeProgressScreenState();
}

class _ChallengeProgressScreenState extends State<ChallengeProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: widget.imagePath,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('1 November - 30th November',
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 16),
                        SizedBox(width: 16),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.signal_cellular_alt,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Intermediate',
                            style: TextStyle(color: Colors.grey)),
                        Spacer(),
                        Icon(Icons.star_border, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('4.8', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A community-wide challenge to this month, well guide you through simple yet impactful habits that can make a big difference—like unplugging devices when not in use, switching to energy-efficient lighting, and minimizing electricity usage during peak hours. Together, well work to lower our collective carbon footprint, share practical tips, and track our progress towards a more sustainable future. This challenge is open to everyone, whether youre new to energy-saving or an experienced eco-enthusiast',
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: double.parse(widget.progress) / 100,
                      backgroundColor: Colors.grey[200],
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${widget.progress}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
