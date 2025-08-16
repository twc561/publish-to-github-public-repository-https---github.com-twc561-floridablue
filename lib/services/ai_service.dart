import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../firebase_options.dart';

class AiService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<String> generateText(String query) async {
    try {
      final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
      final response = await model.generateContent([Content.text(query)]);
      return response.text ?? 'No response from model.';
    } catch (e) {
      return 'Error generating text: $e';
    }
  }
}
