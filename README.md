This repository contains the source code and resources for an AI-driven interactive touchscreen kiosk designed to enhance student services and navigation on university campuses. The kiosk integrates cutting-edge features like natural language processing (NLP), real-time campus navigation, personalised services, and a modular architecture for scalability. The primary deployment was tailored for Tshwane University of Technology (TUT), but the solution is adaptable for other educational and public service institutions.

Key Features
Dynamic Wayfinding
Provides campus navigation with real-time routing and building information powered by Google Maps API.

Natural Language Processing (NLP)
Integrates Dialogflow CX and OpenAI GPT for conversational interactions and complex query resolution.

Student Services
Includes personalised timetable management, student card ordering, and academic results display.

News and Updates
Displays real-time campus news such as admission deadlines, events, and exam schedules.

Administrative Tools
Facilitates registration assistance, tuition payment workflows, and secure user authentication.

Scalable Architecture
Built using Flutter for the frontend and Firebase for backend services to ensure scalability and robust performance.

Tech Stack
Frontend: Flutter
Backend: Firebase (for authentication, real-time updates, and data storage)
AI & NLP: Dialogflow CX, OpenAI GPT
Navigation: Google Maps API
Programming Language: Dart
Getting Started
Prerequisites
Install Flutter: Flutter Installation Guide
Obtain API keys for:
Google Maps API (for navigation services)
Firebase (for backend integration)
Dialogflow CX (for NLP capabilities)
Ensure Dart SDK is installed with Flutter.
Installation Steps
Clone this repository:

bash
Copy code
git clone https://github.com/<username>/ai-driven-kiosk.git
cd ai-driven-kiosk
Install dependencies:

bash
Copy code
flutter pub get
Configure API keys:

Replace placeholders in lib/config/api_keys.dart with your API keys for Google Maps, Firebase, and Dialogflow.
Run the app:

bash
Copy code
flutter run
Project Structure
bash
Copy code
.
├── lib/
│   ├── main.dart           # Entry point
│   ├── screens/            # UI components
│   ├── services/           # Backend integration services
│   ├── widgets/            # Reusable UI components
│   ├── config/             # API keys and app configurations
├── assets/
│   ├── images/             # App assets
│   ├── data/               # Sample datasets
├── test/                   # Unit and integration tests
├── README.md
How to Contribute
We welcome contributions to improve this project! Here’s how you can contribute:

Fork the repository.
Create a feature branch:
bash
Copy code
git checkout -b feature-name
Commit your changes:
bash
Copy code
git commit -m "Add new feature"
Push to your branch:
bash
Copy code
git push origin feature-name
Open a pull request.
Future Roadmap
Multilingual Support: Incorporate additional languages to improve accessibility.
Scalability Enhancements: Optimise backend to handle concurrent user sessions effectively.
Predictive Analytics: Add machine learning models for personalised recommendations and usage insights.
Field Deployment: Extend real-world testing in diverse university environments.
License
This project is licensed under the MIT License.
