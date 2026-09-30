import 'dart:math';
import 'package:flutter/material.dart';

class QuietSpaceScreen extends StatefulWidget {
  const QuietSpaceScreen({super.key});

  @override
 State<QuietSpaceScreen> createState() => _QuietSpaceScreenState();
}

class _QuietSpaceScreenState extends State<QuietSpaceScreen> {

  final List<String> quotes = [
    "You don't have to have everything figured out to deserve a peaceful moment.",
    "Recovery isn't becoming someone new. It's slowly returning to yourself.",
    "Take today one gentle breath at a time.",
    "Rest is not quitting. Rest is preparation.",
    "Even the darkest night eventually welcomes morning.",
    "Be patient with yourself. Healing has no deadline.",
    "Small progress is still progress.",
    "Peace begins the moment you stop fighting yourself."
  ];

  late String quote;

  @override
  void initState() {
    super.initState();
    quote = quotes[Random().nextInt(quotes.length)];
  }

  void nextQuote() {
    setState(() {
      quote = quotes[Random().nextInt(quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4F46E5),
              Color(0xff7C3AED),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [

                const SizedBox(height: 40),

                const Icon(
                  Icons.self_improvement,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 40),

                const Text(
                  "Quiet Space",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      child: Text(
                        quote,
                        key: ValueKey(quote),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: nextQuote,
                    child: const Text("Another Thought"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}