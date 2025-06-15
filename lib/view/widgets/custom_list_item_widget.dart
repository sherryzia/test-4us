import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'my_text_widget.dart';



class RandomItemList extends StatefulWidget {
  final List<String> items;

  const RandomItemList({Key? key, required this.items}) : super(key: key);

  @override
  _RandomItemListState createState() => _RandomItemListState();
}

class _RandomItemListState extends State<RandomItemList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(widget.items.length, (index) {
        bool isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? kHintColor : null,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? kTertiaryColor : kHintColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(
                  text: widget.items[index],
                  size: 12,
                  weight: FontWeight.w500,
                  color: isSelected ? kTertiaryColor : kHintColor,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
