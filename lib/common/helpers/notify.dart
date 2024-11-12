import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatelessWidget {
  TextToSpeech({super.key});
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  Future<void> speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true); // Ensure it waits until speech is completed
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
            ),
            ElevatedButton(
              onPressed: (){
                speak(textEditingController.text);
              },
              child: Text('start text to speech'),
      
            )
          ],
        ),
      ),
    );
  }
}
