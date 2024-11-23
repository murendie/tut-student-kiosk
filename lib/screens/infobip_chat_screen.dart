import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

class InfobipChatScreen extends StatefulWidget {
  const InfobipChatScreen({Key? key}) : super(key: key);

  @override
  State<InfobipChatScreen> createState() => _InfobipChatScreenState();
}

class _InfobipChatScreenState extends State<InfobipChatScreen> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Register view factory
      final String viewId = 'infobip-chat-view';
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
        final element = html.IFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..srcdoc = '''
            <!DOCTYPE html>
            <html>
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Chat</title>
              <style>
                body { margin: 0; padding: 0; height: 100vh; }
              </style>
            </head>
            <body>
              <!-- Infobip Live Chat Widget -->
              <script>
                (function(I,n,f,o,b,i,p){
                  I[b]=I[b]||function(){(I[b].q=I[b].q||[]).push(arguments)};
                  I[b].t=1*new Date();i=n.createElement(f);i.async=1;i.src=o;
                  p=n.getElementsByTagName(f)[0];p.parentNode.insertBefore(i,p)
                })(window,document,'script','https://livechat.infobip.com/widget.js','liveChat');
                liveChat('init', '6763fe63-e6fa-405f-967e-94dfeccb46d1');
              </script>
            </body>
            </html>
          ''';
        return element;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        backgroundColor: const Color(0xFF005496),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            label: const Text('Switch to EduBot', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: 'infobip-chat-view')
          : const Center(
              child: Text(
                'Live chat is currently only available on web platform',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
