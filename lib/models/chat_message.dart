enum ChatMessageAuthor { user, model }

class ChatMessage {
  final String text;
  final ChatMessageAuthor author;

  ChatMessage({required this.text, required this.author});
}
