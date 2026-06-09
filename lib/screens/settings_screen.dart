import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool soundEnabled = true;
  Future<void> openTerms() async {
    final Uri url = Uri.parse(
        'https://www.termsfeed.com/live/sample-terms'
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> rateApp() async {
    final Uri url = Uri.parse(
        'https://play.google.com/store'
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          SwitchListTile(
            title: const Text(
              "Sound Effects",
            ),
            value: soundEnabled,
            onChanged: (value) {
              setState(() {
                soundEnabled = value;
              });
            },
          ),

          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Privacy Policy",
                    ),
                    content: const Text(
                      "This Quiz App stores scores locally on the device.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "OK",
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              "Privacy Policy",
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: openTerms,
            child: const Text(
              "Terms & Conditions",
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: rateApp,
            child: const Text(
              "Rate App",
            ),
          ),
        ],
      ),
    );
  }
}