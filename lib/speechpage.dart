import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechHome extends StatefulWidget {
  const SpeechHome({super.key});

  @override
  State<SpeechHome> createState() => _SpeechHomeState();
}

class _SpeechHomeState extends State<SpeechHome> {
  late stt.SpeechToText _speech;
  bool _islistening = false;
  bool _islistening2 = false;
  String _text = "press the button and start speeking";
  TextEditingController textcontroller = TextEditingController();
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Voice to text"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: _text,
                  suffixIcon: AvatarGlow(
                    animate: _islistening,
                    glowColor: Colors.grey,
                    glowRadiusFactor: 0.3,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: IconButton(
                      onPressed: _listenText,
                      icon: Icon(_islistening ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentcontroller,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "comments",
                  suffixIcon: AvatarGlow(
                    animate: _islistening2,
                    glowColor: Colors.grey,
                    glowRadiusFactor: 0.3,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: IconButton(
                      onPressed: _listenComment,
                      icon: Icon(_islistening2 ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenText() async {
    if (!_islistening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("onstatus : $status"),
        onError: (errorNotification) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorNotification.errorMsg)));
          print("onerror : $errorNotification");
        },
      );
      if (available) {
        setState(() {
          _islistening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              textcontroller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _islistening = false;
      });
      _speech.stop();
    }
  }

  void _listenComment() async {
    if (!_islistening2) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("onstatus : $status"),
        onError: (errorNotification) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorNotification.errorMsg)));
          print("onerror : $errorNotification");
        },
      );
      if (available) {
        setState(() {
          _islistening2 = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              commentcontroller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _islistening2 = false;
      });
      _speech.stop();
    }
  }
}
