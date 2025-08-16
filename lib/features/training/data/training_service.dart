import '../../../core/models/training_scenario.dart';

class TrainingService {
  static final List<TrainingScenario> _scenarios = [
    TrainingScenario(
      title: "Domestic Disturbance",
      description: "Respond to a verbal dispute between a couple.",
      initialPrompt: 
          "You've been dispatched to a residence for a reported verbal argument. As you approach the front door, you hear yelling inside. "
          "A man opens the door, visibly agitated, and partially blocks the doorway. He says, 'We're just talking, everything is fine. You can go.'",
    ),
    TrainingScenario(
      title: "Traffic Stop - Speeding",
      description: "Conduct a routine traffic stop for a speeding vehicle.",
      initialPrompt:
          "You've pulled over a vehicle for going 15 mph over the speed limit. You approach the driver's side window. "
          "The driver seems nervous and is avoiding eye contact. Before you can ask for their license, they ask, 'Why did you pull me over, officer?'",
    ),
    TrainingScenario(
      title: "Shoplifting Suspect",
      description: "Confront a suspect identified by store security.",
      initialPrompt:
          "You're in a large retail store. Loss prevention has identified a shoplifting suspect who is now walking towards the main exit. "
          "You approach them just as they pass the last point of sale. They look at you and say, 'Can I help you?'",
    ),
     TrainingScenario(
      title: "Suspicious Person",
      description: "Investigate a report of a suspicious person in a residential area.",
      initialPrompt:
          "A caller reported a person looking into car windows in a suburban neighborhood at night. You locate an individual matching the description. "
          "They see your patrol car, immediately change direction, and start walking away. You call out from your car, 'Excuse me, sir, can I have a word?' "
          "He stops, turns around, and replies, 'I haven't done anything wrong.'",
    ),
  ];

  List<TrainingScenario> getScenarios() {
    return _scenarios;
  }
}
