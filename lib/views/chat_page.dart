import 'package:chatgpt/colors/pallete.dart';
import 'package:chatgpt/gemini_service/gemini_ai_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var items = <Map<String, String>>[].obs;

  void addItem(String message, String sender) {
    if (message.isNotEmpty) {
      items.add({"user": sender, "message": message});
    }
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ListController controller = Get.put(ListController());
    final TextEditingController textcontroller = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Obx(() => ListView.builder(
                    itemCount: controller.items.length, // Set the item count
                    itemBuilder: (context, index) {
                      final user = controller.items[index]["user"];
                      final message = controller.items[index]["message"];

                      return Align(
                        alignment: user == "user"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: user == "user"
                                ? Pallete.firstSuggestionBoxColor
                                : Pallete.secondSuggestionBoxColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cera Pro',
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ),
            // TextField to input and send messages
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textcontroller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (textcontroller.text.isNotEmpty) {
                        controller.addItem(
                            textcontroller.text.toString(), "user");
                        textcontroller.clear();

                        // Fetch AI response
                        try {
                          final response = await generatecontent(
                              controller.items.last["message"].toString());
                          controller.addItem(response.toString(), "ai");
                        } catch (e) {
                          controller.addItem(
                              "Error: Could not get a response.", "ai");
                        }
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                  hintText: "Enter Your Prompt",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
