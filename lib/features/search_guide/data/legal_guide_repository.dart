class LegalGuideRepository {
  // Simulated knowledge base of legal principles for search and seizure.
  static const Map<String, String> _knowledgeBase = {
    'plain_view_doctrine': 
        'The Plain View Doctrine allows an officer to seize evidence and contraband found in plain view during a lawful observation. '
        'For it to apply, the officer must be lawfully in the spot from where the evidence can be seen, and it must be immediately apparent that the item is contraband or evidence of a crime.',
    'terry_frisk': 
        'A Terry frisk, or a "pat-down," is a brief, non-intrusive search of a person\'s outer clothing for weapons. '
        'It is permitted without a warrant if an officer has a reasonable suspicion that the person is armed and dangerous. '
        'This is not a full search for evidence.',
    'search_incident_to_arrest': 
        'When making a lawful arrest, an officer is permitted to search the person arrested and the area within their immediate control (the "grab zone"). '
        'The purpose is to prevent the arrestee from gaining possession of a weapon or destroying evidence.',
    'exclusionary_rule': 
        'The Exclusionary Rule is a legal principle that prevents evidence collected or analyzed in violation of the defendant\'s constitutional rights from being used in a court of law. '
        'It is designed to deter police misconduct.',
    'warrantless_searches': 
        'Warrantless searches are searches and seizures conducted without a court-issued search warrant. While the Fourth Amendment protects against unreasonable searches, there are several exceptions to the warrant requirement, '
        'including consent, plain view, search incident to arrest, and exigent circumstances.',
    'consent_search': 
        'A consent search occurs when a person voluntarily waives their Fourth Amendment rights and allows a law enforcement officer to search their person, property, or belongings. '
        'The consent must be given freely and intelligently. A person has the right to refuse a consent search.',
    'exigent_circumstances': 
        'Exigent circumstances are exceptions to the warrant requirement that apply when there is an emergency situation. '
        'This includes situations where there is an immediate risk of evidence being destroyed, a suspect is likely to escape, or there is a danger to the public or officers.',
  };

  // Keywords to help the AI match user queries to the knowledge base.
  static const Map<String, List<String>> _keywords = {
    'plain_view_doctrine': ['see', 'evidence', 'plain sight', 'car seat', 'open view'],
    'terry_frisk': ['pat-down', 'frisk', 'feel', 'weapon', 'outside clothing'],
    'search_incident_to_arrest': ['arrest', 'search person', 'grab zone', 'immediate control'],
    'exclusionary_rule': ['bad search', 'evidence thrown out', 'illegal search', 'fruit of the poisonous tree'],
    'warrantless_searches': ['no warrant', 'search without warrant', 'exceptions'],
    'consent_search': ['ask to search', 'permission', 'can I look', 'refuse search'],
    'exigent_circumstances': ['emergency', 'destroying evidence', 'chasing', 'hot pursuit'],
  };

  /// Simulates an AI search by finding the best match for a query in the knowledge base.
  Future<MapEntry<String, String>?> search(String query) async {
    // Simulate a network delay for a realistic loading state.
    await Future.delayed(const Duration(milliseconds: 600));

    final processedQuery = query.toLowerCase().trim();
    if (processedQuery.isEmpty) {
      return null;
    }

    // Direct match check
    for (var entry in _knowledgeBase.entries) {
      if (entry.key.replaceAll('_', ' ').contains(processedQuery)) {
        return entry;
      }
    }

    // Keyword match check
    for (var entry in _keywords.entries) {
      for (var keyword in entry.value) {
        if (processedQuery.contains(keyword)) {
          return _knowledgeBase.entries.firstWhere((kb) => kb.key == entry.key);
        }
      }
    }

    // No match found
    return null;
  }
}
