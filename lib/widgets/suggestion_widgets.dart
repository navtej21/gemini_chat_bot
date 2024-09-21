import 'package:chatgpt/colors/pallete.dart';
import 'package:flutter/material.dart';

class SuggestionWidgets extends StatelessWidget {
  const SuggestionWidgets(
      {super.key,
      required this.title,
      required this.description,
      required this.color});
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: Pallete.blackColor,
                  fontFamily: "Cera Pro",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: TextStyle(
                  color: Pallete.blackColor,
                  fontFamily: "Cera Pro",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
