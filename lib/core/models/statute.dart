class Statute {
  final String title;
  final String number;
  final String content; // Keep for general content, can be deprecated if not used
  final String severity;
  final String elements;
  final List<String> examples;

  Statute({
    required this.title,
    this.number = '',
    this.content = '',
    this.severity = '',
    this.elements = '',
    this.examples = const [],
  });
}
