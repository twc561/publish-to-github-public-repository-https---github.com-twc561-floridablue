import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../models/chat_message.dart';
import '../models/training_scenario.dart';
import '../services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  final TrainingScenario scenario;

  const ChatScreen({super.key, required this.scenario});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final AiGenService _aiGenService = AiGenService();
  final List<ChatMessage> _messages = [];
  
  late ChatSession _chatSession;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatSession = _aiGenService.startTrainingSession(widget.scenario);
    
    // The initial prompt is now part of the chat history, so we just display it.
    _messages.add(
      ChatMessage(
        text: widget.scenario.initialPrompt,
        author: ChatMessageAuthor.model,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    final userMessage = ChatMessage(text: text, author: ChatMessageAuthor.user);
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _textController.clear();

    try {
      final response = await _chatSession.sendMessage(Content.text(text));
      final aiResponse = ChatMessage(
        text: response.text ?? 'Sorry, I am having trouble responding.',
        author: ChatMessageAuthor.model,
      );
      
      setState(() {
        _messages.add(aiResponse);
        _isLoading = false;
      });
    } catch (e) {
       final errorResponse = ChatMessage(
        text: 'Error: Could not get a response. Please try again.',
        author: ChatMessageAuthor.model,
      );
       setState(() {
        _messages.add(errorResponse);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Show the latest messages at the bottom
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return _buildMessageBubble(message, theme);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          _buildTextInput(theme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeData theme) {
    final isUser = message.author == ChatMessageAuthor.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.secondary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Say something...',
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
