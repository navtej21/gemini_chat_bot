import 'package:chatgpt/views/chat_page.dart';
import 'package:chatgpt/gemini_service/gemini_ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chatgpt/colors/pallete.dart'; // Your custom pallete for colors and styles
import 'package:chatgpt/widgets/suggestion_widgets.dart'; // Your custom widgets

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    // Check and request microphone permission
    PermissionStatus permissionStatus = await Permission.microphone.request();
    if (permissionStatus == PermissionStatus.granted) {
      _speechEnabled = await _speechToText.initialize();
    } else {
      print("Microphone permission not granted");
    }
    setState(() {});
  }

  Future<void> _startListening() async {
    if (_speechToText.isNotListening) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
      );
    }
    setState(() {});
  }

  Future<void> _stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    setState(() {});
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    print("recognized words:${_lastWords}");
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await _speechToText.hasPermission &&
              _speechToText.isNotListening) {
            await _startListening();
          } else if (_speechToText.isListening) {
            await _stopListening();
            await generatecontent(_lastWords);
          } else {
            _initSpeech();
          }
        },
        child: Icon(Icons.mic),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Allen"),
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: screenHeight * 0.15,
                    width: screenHeight * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallete.assistantCircleColor,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: screenHeight * 0.16,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/virtualAssistant.png"),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Good Morning, What task can I do for you?",
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontWeight: FontWeight.w400,
                    color: Pallete.mainFontColor,
                    fontSize: screenHeight * 0.02,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
                    .copyWith(topLeft: Radius.zero, bottomRight: Radius.zero),
                color: Pallete.whiteColor,
                border: Border.all(style: BorderStyle.solid),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 22),
              child: Text(
                "Here are a few features:",
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontFamily: "Cera Pro",
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(19, 61, 95, 1),
                ),
              ),
            ),
            Column(
              children: [
                SuggestionWidgets(
                  title: "ChatGpt",
                  description:
                      "A smarter way to stay organized and informed with ChatGpt",
                  color: Pallete.firstSuggestionBoxColor,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SuggestionWidgets(
                  title: "Dall-E",
                  description:
                      "Get inspired and stay creative with your personal assistant powered by Dall-E",
                  color: Pallete.secondSuggestionBoxColor,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SuggestionWidgets(
                  title: "Smart Voice Assistant",
                  description:
                      "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGpt",
                  color: Pallete.thirdSuggestionBoxColor,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => ChatPage());
                    },
                    child: Text("Start Now"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
