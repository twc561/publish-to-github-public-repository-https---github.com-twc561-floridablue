import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FstGuideScreen extends StatelessWidget {
  const FstGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Field Sobriety Test Guide',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FstExpansionTile(
            title: 'Horizontal Gaze Nystagmus (HGN)',
            icon: Icons.visibility,
            children: [
              _InstructionStep(number: '1', text: 'Check for equal pupil size and resting nystagmus.'),
              _InstructionStep(number: '2', text: 'Check for equal tracking in both eyes.'),
              _InstructionStep(number: '3', text: 'Lack of Smooth Pursuit: Move stimulus smoothly side to side. (2 passes)'),
              _InstructionStep(number: '4', text: 'Distinct and Sustained Nystagmus at Maximum Deviation: Hold stimulus at max deviation for 4 seconds.'),
              _InstructionStep(number: '5', text: 'Onset of Nystagmus Prior to 45 Degrees.'),
              _InstructionStep(number: '6', text: 'Vertical Gaze Nystagmus (VGN): Check for up and down jerking.'),
            ],
          ),
          FstExpansionTile(
            title: 'Walk-and-Turn',
            icon: Icons.directions_walk,
            children: [
              _InstructionStep(number: '1', text: 'Instruction Stage: Subject stands heel-to-toe, arms at side.'),
              _InstructionStep(number: '2', text: 'Walking Stage: Take nine heel-to-toe steps down the line.'),
              _InstructionStep(number: '3', text: 'Turn Stage: Turn on the line with a series of small steps.'),
              _InstructionStep(number: '4', text: 'Walking Stage: Take nine heel-to-toe steps back.'),
              _CluesSection(clues: [
                'Cannot keep balance during instructions.',
                'Starts too soon.',
                'Stops while walking.',
                'Does not touch heel-to-toe.',
                'Steps off the line.',
                'Uses arms for balance.',
                'Improper turn.',
                'Incorrect number of steps.',
              ]),
            ],
          ),
          FstExpansionTile(
            title: 'One-Leg Stand',
            icon: Icons.accessibility_new,
            children: [
               _InstructionStep(number: '1', text: 'Instruction Stage: Subject stands with feet together, arms at side.'),
               _InstructionStep(number: '2', text: 'Balance and Counting Stage: Raise one leg 6 inches off the ground, parallel to the ground.'),
               _InstructionStep(number: '3', text: 'Count aloud by thousands ("One thousand-one, one thousand-two...") until told to stop.'),
               _CluesSection(clues: [
                'Sways while balancing.',
                'Uses arms for balance.',
                'Hops to maintain balance.',
                'Puts foot down.',
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class FstExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const FstExpansionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.secondary),
        title: Text(
          title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        children: children,
        childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final String number;
  final String text;
  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            child: Text(number),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _CluesSection extends StatelessWidget {
  final List<String> clues;
  const _CluesSection({required this.clues});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clues to look for:',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...clues.map((clue) => Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Text('• $clue'),
              )),
        ],
      ),
    );
  }
}
