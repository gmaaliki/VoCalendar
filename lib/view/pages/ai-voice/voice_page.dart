import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/view/pages/ai-voice/schedule_card.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutterapi/viewmodels/schedule_viewmodel.dart';
import 'package:flutterapi/view/pages/ai-voice/add_schedule_dialog.dart';
import 'package:flutterapi/models/schedule_model.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _text = 'Press the mic button and start speaking...';
  String _response = 'Response will be shown here';

  String? _userId;
  late ScheduleViewModel _scheduleViewModel;

  @override
  void initState() {
    super.initState();

    // Initialize speech to text
    _speech = stt.SpeechToText();

    // Get user ID from firebase auth
    final currentUser = FirebaseAuth.instance.currentUser;
    _userId = currentUser?.uid;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_userId != null) {
    //     final vm = Provider.of<ScheduleViewModel>(context, listen: false);
    //     if (!vm.hasInitialized) {
    //       vm.listenToSchedules(_userId!);
    //     }
    //   }
    // });
  }

  void _onHoldMic() async {
    setState(() => _isListening = true);
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
        localeId: 'id-ID',
      );
    }
  }

  void _onReleaseMic() async {
    setState(() => _isListening = false);
    if (_text != '') {
      String? results = await _scheduleViewModel.generateScheduleFromQuery(_text);

      if (results == null || results.isEmpty) {
        setState(() {
          _response = 'error';
        });
      } else {
        setState(() {
          _response = results;
        });
        await _flutterTts.setLanguage("id-ID");
        await _flutterTts.speak(_response);
      }
    }
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(_text),
                  Text(_response),
                  Consumer<ScheduleViewModel>(
                    builder: (context, vm, build) {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final _userId = currentUser?.uid;
                      return StreamBuilder<List<Schedule>>(
                        stream: vm.scheduleStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No Events Found'));
                          }
                          final schedules = snapshot.data!;
                          return Column(
                            children: schedules
                                .map((schedule) => ScheduleCard(schedule: schedule))
                                .toList(),
                          );
                        },
                      );
                    }
                  ),
                  FloatingActionButton(
                    onPressed: () => showAddScheduleDialog(context, _userId!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add new event"),
                        Icon(
                          Icons.add,
                          size: 18,
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
            GestureDetector(
              onTapDown: (_) => _onHoldMic(),
              onTapUp: (_) => _onReleaseMic(),
              onTapCancel: _onReleaseMic,
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: null,
                  shape: CircleBorder(),
                  backgroundColor: Color(0xFFBDF152),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_off,
                    size: 36,
                    color: Color(0xFF000000)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}