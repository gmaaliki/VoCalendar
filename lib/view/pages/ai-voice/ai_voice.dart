import 'package:flutter/material.dart';
import 'package:flutterapi/view/pages/ai-voice/dot_loading.dart';

class AiVoice extends StatelessWidget {
  final ValueNotifier<String> messageNotifier;
  final ValueNotifier<bool> loadingNotifier;
  const AiVoice({
    Key? key,
    required this.messageNotifier,
    required this.loadingNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: messageNotifier,
      builder: (context, message, _) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Icon(
                Icons.face,
                color: Colors.white,
                size: 36,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 6, horizontal: 12),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 14),
                constraints: BoxConstraints(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  minHeight: MediaQuery
                      .of(context)
                      .size
                      .width * 0.25,
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .width * 0.25,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: const Radius.circular(0),
                    bottomRight: const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: !loadingNotifier.value ?
                      Text(
                        message.isEmpty ? 'Press the mic button and start speaking...' : message,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ) :
                      DotLoadingIndicator()
                    ,
                  )
                )
              ),
            ],
          )
        );
      }
    );
  }
}
