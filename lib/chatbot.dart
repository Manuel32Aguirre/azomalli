import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _userInput = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;

  static const apiKey = "AIzaSyCQS48fdzRQNrU_dYdU1ePNPHZlgI9NrJ8";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  Future<void> sendMsg() async {
    String text = _userInput.text;
    _userInput.clear();

    if (text.isNotEmpty) {
      setState(() {
        msgs.insert(0, Message(true, text));
        isTyping = true;
      });

      scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );

      try {
        // Crear el contenido que se enviará al modelo
        final content = [Content.text(text)];
        final response = await model.generateContent(content);

        if (response.text != null) {
          setState(() {
            isTyping = false;
            msgs.insert(
              0,
              Message(
                false,
                response.text!.trim(),
              ),
            );
          });

          scrollController.animateTo(
            0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
          );
        } else {
          setState(() {
            isTyping = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: No response from API")),
          );
        }
      } catch (e) {
        setState(() {
          isTyping = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AZOMALLI - AI"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: isTyping ? msgs.length + 1 : msgs.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (context, index) {
                if (isTyping && index == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Typing..."),
                    ),
                  );
                } else {
                  int adjustedIndex = isTyping ? index - 1 : index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: BubbleNormal(
                      text: msgs[adjustedIndex].msg,
                      isSender: msgs[adjustedIndex].isSender,
                      color: msgs[adjustedIndex].isSender
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _userInput,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (value) {
                          sendMsg();
                        },
                        textInputAction: TextInputAction.send,
                        showCursor: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter text",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  sendMsg();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isSender;
  final String msg;

  Message(this.isSender, this.msg);
}
