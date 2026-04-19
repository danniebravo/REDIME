import 'package:flutter/material.dart';
import 'mapa_recoleccion_view.dart';
import 'chat_view.dart';
import '../../features/profile/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _index = 2; // ✅ empieza en Inicio

  final List<Widget> _pantallas = [
    const Center(child: Text('Inicio')),
    const ChatView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Panel superior con hora y batería
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: SafeArea( // ✅ SafeArea para que respete el notch
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('9:41',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt, size: 14),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 14),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _pantallas[_index]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFF3A8F7D),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}