import 'dart:async';
import '../models/chat_message.dart';

class ChatService {
  // Simulated responses for demo purposes
  final Map<String, String> _demoResponses = {
    'hello': 'Hello! How can I assist you today?',
    'hi': 'Hi there! What can I help you with?',
    'help': 'I can help you with:\n- Course information\n- Registration\n- Student services\n- Campus facilities\nWhat would you like to know more about?',
    'course': 'We offer various courses across different faculties. Which faculty are you interested in?',
    'registration': 'For registration, you\'ll need:\n1. ID Document\n2. Academic Records\n3. Proof of Address\nWould you like to start the registration process?',
    'campus': 'Our main campus is located at 1 Aubrey Matlakala St, Soshanguve - K, Soshanguve, 0001. We also have satellite campuses. Which campus would you like to know more about?',
    'contact': 'You can contact us at:\nEmail: info@tut.ac.za\nPhone: 012 382 5911\nOr visit our website: www.tut.ac.za',
    'fees': 'Tuition fees vary by course. Would you like to:\n1. Calculate your fees\n2. View payment methods\n3. Check payment deadlines',
    'default': 'I\'m not sure about that. Could you please rephrase your question or choose from the available options?'
  };

  Future<ChatMessage> getBotResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Convert user message to lowercase for matching
    String lowercaseMessage = userMessage.toLowerCase();
    
    // Find a matching response or use default
    String response = 'default';
    for (var key in _demoResponses.keys) {
      if (lowercaseMessage.contains(key)) {
        response = _demoResponses[key]!;
        break;
      }
    }
    
    return ChatMessage(
      text: response == 'default' ? _demoResponses['default']! : response,
      isUser: false,
    );
  }

  // This method will be implemented later with actual Dialogflow integration
  Future<void> initializeDialogflow() async {
    // TODO: Initialize Dialogflow client with credentials from .env
  }
}
