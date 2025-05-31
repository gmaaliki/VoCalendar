import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/view/pages/intro/intro_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../api/chat_api.dart';
import '../../viewmodels/schedule_viewmodel.dart';

class SpeechHomePage extends StatefulWidget {
  const SpeechHomePage({super.key});

  @override
  _SpeechHomePageState createState() => _SpeechHomePageState();
}

class _SpeechHomePageState extends State<SpeechHomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the mic button and start speaking...';
  String _response = 'Response will be shown here';

  // TODO: gunakan provider
  final vm = ScheduleViewModel(ChatApi());

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          localeId: 'id-ID',
        );
      }
    } else {
      if (_text != '') {
        String? results = await vm.generateScheduleFromQuery(_text);
        print('ini hasil $results');
        if (results == null || results.isEmpty) {
          setState(() {
            _response = 'error';
          });
        } else {
          setState(() {
            _response = results;
          });
        }
      }
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const IntroPage()),
                );
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
                    children: [
                      Text(_text),
                      Text(_response),
                    ]
                )
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_off),
            ),
          ],
        ),
      ),
    );
  }
}
