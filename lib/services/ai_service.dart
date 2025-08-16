import 'dart:async';
import 'dart:developer';
import 'package:firebase_ai/firebase_ai.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';
import '../models/daily_fact.dart';
import '../models/statute.dart';
import '../models/training_scenario.dart';

class AiGenService {
  final _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-1.5-flash');

  Future<Statute> generateStatuteDetails(String statuteTitle) async {
    // ... (existing code)
    final prompt = """
    For the Florida Statute related to "$statuteTitle", provide a detailed breakdown in a strict JSON format.
    The JSON object must have the following keys:
    - "number": The specific Florida Statute number (e.g., "810.02").
    - "severity": A string indicating the severity of the crime (e.g., "Second-Degree Felony").
    - "elements": A markdown formatted string listing the core elements of the crime. Use bullet points.
    - "examples": An array of two distinct, real-world examples of how this crime might be committed. Each example should be a string.

    IMPORTANT: Ensure the output is ONLY the raw JSON object. Do not include any introductory text or markdown formatting like ```json.
    Crucially, ensure that any double quotes within the string values are properly escaped with a backslash (\\").
    """;
    
    String rawResponse = '';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      rawResponse = response.text ?? '';

      final jsonStartIndex = rawResponse.indexOf('{');
      final jsonEndIndex = rawResponse.lastIndexOf('}');

      if (jsonStartIndex != -1 && jsonEndIndex != -1) {
        final jsonString = rawResponse.substring(jsonStartIndex, jsonEndIndex + 1);
        final jsonResponse = json.decode(jsonString);
        return Statute(
          title: statuteTitle,
          number: jsonResponse['number'] ?? '',
          severity: jsonResponse['severity'] ?? '',
          elements: jsonResponse['elements'] ?? '',
          examples: List<String>.from(jsonResponse['examples'] ?? []),
        );
      } else {
        throw const FormatException("Could not find a valid JSON object in the response.");
      }
    } on FormatException catch (e, s) {
      log('Failed to parse JSON response.', error: e, stackTrace: s, name: 'AiGenService');
      throw FormatException("There was an issue decoding the AI's response.", rawResponse);
    } catch (e, s) {
      log('An unexpected error occurred', error: e, stackTrace: s, name: 'AiGenService');
      rethrow;
    }
  }

  ChatSession startTrainingSession(TrainingScenario scenario) {
    // ... (existing code)
    final systemPrompt = """
    You are an AI role-playing as a character in a law enforcement training scenario.
    The user is a police officer, and their messages are what they are saying to you directly.
    Your task is to respond in character based on their dialogue.

    SCENARIO: ${scenario.title}
    SITUATION: ${scenario.description}

    YOUR BEHAVIOR:
    - BE a character, DO NOT be an instructor.
    - Your responses must be short, conversational, and realistic.
    - React to the officer's tone. If they are professional, you may de-escalate. If they are aggressive, you may become more agitated.
    - Stay in character at all times. Do not break the fourth wall or mention that this is a training scenario.
    """;

    final initialHistory = [
      Content('model', [TextPart(systemPrompt)]),
      Content('model', [TextPart(scenario.initialPrompt)]),
    ];

    return _model.startChat(history: initialHistory);
  }

  Future<DailyFact> getDailyFact() async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final prompt = """
    Generate a single, interesting, and little-known "Did You Know?" fact related to Florida law, law enforcement procedures, or legal history.
    The fact should be concise and easily digestible. Use today's date ($date) as a seed to ensure the fact is unique for today.
    Do not include a heading or the phrase "Did you know?". Just return the factual statement.
    """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return DailyFact(text: response.text ?? 'Could not retrieve today\'s fact.');
    } catch (e, s) {
      log('Error fetching daily fact', error: e, stackTrace: s);
      return DailyFact(text: 'Check back tomorrow for another fact!');
    }
  }
}
