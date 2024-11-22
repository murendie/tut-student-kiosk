import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

class ExamTimetableScreen extends StatefulWidget {
  const ExamTimetableScreen({super.key});

  @override
  State<ExamTimetableScreen> createState() => _ExamTimetableScreenState();
}

class _ExamTimetableScreenState extends State<ExamTimetableScreen> {
  final String _examUrl = 'https://os.tut.ac.za/ExamsLegacy/TimeTable';
  bool _isLoading = true;
  late final WebViewController _controller;
  late final String _iframeElementId;

  @override
  void initState() {
    super.initState();
    _iframeElementId = 'exam-timetable-iframe-${DateTime.now().millisecondsSinceEpoch}';
    
    if (!kIsWeb) {
      _initializeWebViewController();
    } else {
      _initializeIframe();
    }
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading timetable: ${error.description}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_examUrl));
  }

  void _initializeIframe() {
    // Register view factory for web
    ui_web.platformViewRegistry.registerViewFactory(
      _iframeElementId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = _examUrl
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..onLoad.listen((event) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        return iframe;
      },
    );
  }

  Widget _buildWebView() {
    if (kIsWeb) {
      return HtmlElementView(viewType: _iframeElementId);
    } else {
      return WebViewWidget(controller: _controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Timetable'),
        backgroundColor: const Color(0xFF005496),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: Stack(
        children: [
          _buildWebView(),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF005496),
              ),
            ),
        ],
      ),
    );
  }
}
