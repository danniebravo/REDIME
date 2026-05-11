import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const Color _primaryColor = Color(0xFF3A8F7D);
  static const Color _backgroundColor = Color(0xFFF5F5F0);

  final List<Map<String, String>> _messages = [];

  final List<String> _suggestions = [
    '¿Cómo deposito mi dispositivo?',
    '¿Qué tipo de dispositivos aceptan?',
    '¿Cómo consulto el estado del dispositivo?',
  ];

  final Map<String, String> _answers = {
    '¿Cómo deposito mi dispositivo?':
        'Puedes registrar una solicitud de recogida desde la opción "Recoger dispositivos" o llevarlo a un punto de recolección disponible.',
    '¿Qué tipo de dispositivos aceptan?':
        'REDIME acepta celulares, tablets, computadores, cargadores, accesorios electrónicos y otros dispositivos RAEE.',
    '¿Cómo consulto el estado del dispositivo?':
        'Puedes consultar la trazabilidad desde la opción "Estado del dispositivo" en el inicio de la app.',
  };

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': cleanText});
    });

    final answer =
        _answers[cleanText] ??
        'Gracias por tu pregunta. Por ahora este chat está en versión inicial, pero REDIME podrá ayudarte con información sobre reciclaje, trazabilidad y puntos de recolección.';

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _messages.add({'role': 'bot', 'text': answer});
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_scrollController.hasClients) return;

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Soporte REDIME',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _ChatHeader(primaryColor: _primaryColor),
            Expanded(
              child: _messages.isEmpty
                  ? _SuggestionsList(
                      suggestions: _suggestions,
                      onSuggestionTap: _sendMessage,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUser = message['role'] == 'user';

                        return _MessageBubble(
                          text: message['text'] ?? '',
                          isUser: isUser,
                          primaryColor: _primaryColor,
                        );
                      },
                    ),
            ),
            _InputBar(
              controller: _controller,
              primaryColor: _primaryColor,
              onSend: () => _sendMessage(_controller.text),
              onSubmitted: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final Color primaryColor;

  const _ChatHeader({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chat de preguntas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Resuelve dudas sobre reciclaje, trazabilidad y recolección.',
            style: TextStyle(
              fontSize: 13,
              color: primaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  const _SuggestionsList({
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            'Preguntas frecuentes:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ...suggestions.map(
            (suggestion) => GestureDetector(
              onTap: () => onSuggestionTap(suggestion),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  suggestion,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color primaryColor;

  const _MessageBubble({
    required this.text,
    required this.isUser,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.74,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isUser ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isUser ? Colors.white : Colors.black87,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final Color primaryColor;
  final VoidCallback onSend;
  final ValueChanged<String> onSubmitted;

  const _InputBar({
    required this.controller,
    required this.primaryColor,
    required this.onSend,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Escribe tus dudas',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF5F5F0),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
