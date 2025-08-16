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
  // A standard model for general tasks
  final _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-1.5-flash');

  // A specifically configured model for the training scenarios
  GenerativeModel? _trainingModel;

  Future<Statute> generateStatuteDetails(String statuteTitle) async {
    final prompt = """
    For the Florida Statute related to "$statuteTitle", provide a detailed breakdown in a strict JSON format.
    The JSON object must have the following keys:
    - "number": The specific Florida Statute number (e.g., "810.02").
    - "severity": A string indicating the severity of the crime (e.g., "Second-Degree Felony").
    - "elements": A markdown formatted string listing the core elements of the crime. Use bullet points.
    - "examples": An array of two distinct, real-world examples of how this crime might be committed. Each example should be a string.
    IMPORTANT: Ensure the output is ONLY the raw JSON object. Do not include any introductory text or markdown formatting. Crucially, ensure that any double quotes within the string values are properly escaped with a backslash (\\").
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
        throw FormatException("Could not find a valid JSON object in the AI's response.", rawResponse);
      }
    } on FormatException catch (e, s) {
      log('Failed to parse JSON response.', error: e, stackTrace: s, name: 'AiGenService');
      rethrow;
    } catch (e, s) {
      log('An unexpected error occurred', error: e, stackTrace: s, name: 'AiGenService');
      rethrow;
    }
  }

  ChatSession startTrainingSession(TrainingScenario scenario) {
    // Define the AI's core instructions. This is the new, more robust method.
    final systemInstruction = Content.system(
      """
      You are an AI role-playing as a character in a law enforcement training scenario.
      The user is a police officer. Their messages are what they are saying to you directly.
      Your task is to respond IN-CHARACTER based on their dialogue.

      **DO NOT BREAK CHARACTER.**
      **DO NOT act as an instructor or provide feedback.**
      **DO NOT use phrases like "As the suspect..." or "The man responds...".**
      **Just speak as the character.**

      Your behavior:
      - Your responses must be short, conversational, and realistic.
      - React to the officer's tone. If they are professional, you may de-escalate. If they are aggressive, you may become more agitated.
      
      SCENARIO: ${scenario.title}
      SITUATION: ${scenario.description}
      """
    );

    // Initialize the model with these locked-in instructions
    _trainingModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-1.5-flash',
      systemInstruction: systemInstruction,
    );
    
    // The chat history now ONLY contains the AI's opening line.
    final initialHistory = [
      Content.model([TextPart(scenario.initialPrompt)])
    ];

    return _trainingModel!.startChat(history: initialHistory);
  }

  Future<DailyFact> getDailyFact() async {
    // ... (rest of the method remains the same)
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
