# Florida Blue Guide: AI-Powered Field Assistant

## App Concept & Vision

The Vision: To create a premier, AI-driven mobile application for Florida law enforcement officers that serves as an indispensable digital field guide. This app will empower officers by providing immediate, context-aware access to legal information, procedural guidance, and interactive training scenarios. It aims to enhance decision-making, ensure compliance, and improve officer safety and effectiveness in high-pressure situations. The app should feel like a trusted, intelligent partner in the officer's pocket—authoritative, reliable, and incredibly fast.

## Target Audience

Primary Users: Sworn law enforcement officers in the state of Florida, from rookie patrol officers to seasoned detectives and supervisors.

Environment: They will use this app in the field, often under stressful and rapidly evolving conditions. This includes patrol cars, during traffic stops, at crime scenes, and while interviewing subjects.

Technical Proficiency: Varies widely. The UI must be exceptionally intuitive and require minimal training.

## Core Features & Functionality

*   **AI-Powered "Street Smart" Search:** Enables officers to use plain-language queries to get concise summaries of legal information, including relevant statutes, case law, and procedural checklists.
*   **Dynamic Legal Library:** Provides quick access to the full text of Florida Statutes, official annotations, and related landmark case summaries.
*   **Contextual Guidance Engine:** Uses location data to provide context-specific information, such as local ordinances and BOLO alerts.
*   **AI Role-Play Scenario Trainer:** Offers interactive, AI-driven training scenarios covering a range of situations, with instant feedback based on Florida law and best practices.
*   **Officer's Dashboard / Home Screen:** A clean and intuitive dashboard with a prominent search bar, quick access to recent and favorite articles, and a link to training scenarios.

## UI/UX Design Goals & Principles

*   **Aesthetic:** Professional, authoritative, and modern, with a clean and serious design.
*   **Clarity:** High-contrast, legible fonts, and a design optimized for both day and night visibility.
*   **Speed:** Minimalistic and fast interactions, with a highly responsive UI.
*   **Fluid & Tactile Interaction:** Smooth animations, gesture-based navigation, and meaningful haptic feedback.
*   **One-Handed Operation:** Key functions are easily accessible for one-handed use.
*   **Information Hierarchy:** A logical structure with clear headings, collapsible sections, and visual cues.

## Branding & Visual Identity

*   **Color Palette:** Deep navy blues, charcoal grays, and crisp whites, with a single strong accent color (e.g., "safety" gold or muted red).
*   **Typography:** A modern, highly-legible sans-serif font family (e.g., Inter, Roboto).
*   **Iconography:** Clear, universally understood icons (e.g., Material Design Icons).

## Implementation Details

### AI-Powered "Street Smart" Search

1.  **Dependencies**: Add `firebase_core` and `firebase_ai` to `pubspec.yaml`. These packages provide the necessary tools to interface with Firebase and use the Gemini API.
2.  **Firebase Initialization**: Ensure Firebase is initialized in `lib/main.dart`.
3.  **Gemini API Usage**: Implement the search functionality using the Gemini API. The `generateText` method will take a plain-language query as input and return a concise, actionable summary.
4.  **UI Integration**: Integrate the search functionality into the `DashboardScreen`. Display the search results in the UI, categorized by type (Statute, Case Law, Scenario).
