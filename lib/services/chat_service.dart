import '../models/chat_message.dart';

class ChatService {
  final Map<String, String> _demoResponses = {
    'hello': 'Hello! I\'m EduBot, your TUT virtual assistant. How can I help you today?',
    'hi': 'Hi there! How can I assist you today?',
    'help': 'I can help you with:\n- Course information\n- Campus facilities\n- Student services\n- Registration\n- Financial aid\n- Academic calendar\nWhat would you like to know more about?',
    'courses': 'TUT offers various courses across different faculties including:\n- Engineering\n- Information Technology\n- Business\n- Science\n- Arts\nWhich faculty interests you?',
    'facilities': 'Our campus facilities include:\n- Library\n- Computer labs\n- Sports facilities\n- Student center\n- Health clinic\n- Study areas\nWhich facility would you like to know more about?',
    'registration': 'For registration, you\'ll need:\n1. Valid ID/Passport\n2. Academic records\n3. Proof of residence\n4. Application fee payment\nWould you like to know more about the registration process?',
    'fees': 'Tuition fees vary by course. You can:\n- Pay online through student portal\n- Make bank deposits\n- Set up payment plans\nNeed help with a specific payment option?',
    'financial aid': 'We offer various financial aid options:\n- NSFAS\n- Bursaries\n- Scholarships\n- Study loans\nWould you like details about any specific option?',
    'contact': 'You can contact us through:\n- Email: info@tut.ac.za\n- Phone: (012) 382-5911\n- Visit our campus\nHow would you like to reach us?',
    'default': 'I\'m still learning! Could you please rephrase your question or choose from the topics I mentioned earlier?'
  };

  Future<void> initializeDialogflow() async {
    // No initialization needed for demo mode
    return;
  }

  Future<ChatMessage> getBotResponse(String message) async {
    // Convert message to lowercase for case-insensitive matching
    String lowerMessage = message.toLowerCase();
    
    // Check for keywords in the message
    String response = _demoResponses['default']!;
    
    for (var key in _demoResponses.keys) {
      if (lowerMessage.contains(key)) {
        response = _demoResponses[key]!;
        break;
      }
    }

    return ChatMessage(
      text: response,
      isUser: false,
    );
  }

  void dispose() {
    // No cleanup needed for demo mode
  }
}
