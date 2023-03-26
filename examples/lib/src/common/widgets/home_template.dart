import 'package:flutter/material.dart';

class HomeTemplate extends StatelessWidget {
  final Map<String, Route Function()> destinations;
  final String title;

  const HomeTemplate({
    required this.destinations,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: destinations.entries
                .map(
                  (e) => ElevatedButton(
                    onPressed: () => Navigator.of(context).push(e.value()),
                    child: Text(e.key),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
