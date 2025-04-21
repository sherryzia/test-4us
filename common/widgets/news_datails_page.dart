import 'package:flutter/material.dart';

class NewsDatailsPage extends StatefulWidget {
  final String? imagetag;
  final String img;

  const NewsDatailsPage({
    super.key,
    this.imagetag,
    required this.img,
  });

  @override
  State<NewsDatailsPage> createState() => _NewsDatailsPageState();
}

class _NewsDatailsPageState extends State<NewsDatailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.img,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.img,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const Text(
                "It was originally taken from a Latin text written by a Roman Scholar, Sceptic and Philosopher by the name of Marcus Tullius Cicero, who influenced the Latin language greatly\n text we know today has been altered over the years (in fact Lorem isn't actually a Latin word. It is suggested that the reason that the text starts with Lorem is because there was a page break spanning the word Do-lorem. If you a re looking for a translation of the text, it's meaningless. The original text talks about the pain and love involved in the pursuit of pleasure or something like that The reason we use Lorem Ipsum is simple. If we used real text, it would possibly distract from the DESIGN of a page (or indeed, might even be mistakenly inappropriate. Or if we used something like Insert Text Here..., this would also distract from the design. Using Lorem Ipsum allows us to SEE the design without being distracted by readable or unrealistic text."),
          ],
        ),
      )),
    );
  }
}
