import "dart:io";

import "package:chatgpt/gemini_service/secrets.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:google_generative_ai/google_generative_ai.dart";

FlutterTts fluttertts = FlutterTts();
Future<void> _speak(String text) async {
  await fluttertts.setLanguage("en-US");
  await fluttertts.setPitch(1.0);
  await fluttertts.speak(text);
}

Future<String> generatecontent(String prompt) async {
  final apikey = Platform.environment[geminikey];
  if (apikey == null) {
    print("No Api key envoirment present");
  }

  final model = GenerativeModel(model: "gemini-1.5-flash", apiKey: geminikey);

  final response = await model.generateContent([Content.text(prompt)]);
  return response.text.toString();
}
