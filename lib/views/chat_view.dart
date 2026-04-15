import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Color primaryColor = const Color(0xFF3A8F7D);

  final List<Map<String, String>> _messages = [];

  final List<String> _sugerencias = [
    '¿Cómo deposito mi dispositivo?',
    '¿Qué tipo de dispositivos aceptan?',
    'Estado del dispositivo',
  ];

  final Map<String, String> _respuestas = {
    '¿Cómo deposito mi dispositivo?':
        'Para depositar tu dispositivo, ve a la sección de mapa, selecciona un punto de recolección cercano y lleva tu dispositivo en el horario indicado.',
    '¿Qué tipo de dispositivos aceptan?':
        'Aceptamos teléfonos celulares, tablets, computadores portátiles, cargadores y accesorios electrónicos en general.',
    'Estado del dispositivo':
        'Puedes consultar el estado de tu dispositivo en la sección "Dispositivos Redimidos" dentro de tu perfil.',
  };

  void _enviarMensaje(String texto) {
    if (texto.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': texto});
    });

    final respuesta = _respuestas[texto] ??
        'Gracias por tu pregunta. Un agente de REDIME te responderá pronto.';

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({'role': 'bot', 'text': respuesta});
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'REDIME',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Encabezado
          Container(
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
                const SizedBox(height: 2),
                Text(
                  '¡Bienvenido USUARIO!',
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Área de mensajes
          Expanded(
            child: _messages.isEmpty
                ? _buildSugerencias()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final esUsuario = msg['role'] == 'user';
                      return _buildBurbuja(msg['text']!, esUsuario);
                    },
                  ),
          ),

          // Campo de texto
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildSugerencias() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Preguntas comunes sugeridas:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ..._sugerencias.map(
            (s) => GestureDetector(
              onTap: () => _enviarMensaje(s),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  s,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBurbuja(String texto, bool esUsuario) {
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: esUsuario ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: esUsuario
              ? null
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 13,
            color: esUsuario ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Escribe tus dudas',
                hintStyle:
                    TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF5F5F0),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _enviarMensaje,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _enviarMensaje(_controller.text),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor,
              child: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}