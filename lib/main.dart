import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can change the primary color here
        brightness: Brightness.dark,
      ),
      home: const GeneratorOptionsPage(),
    );
  }
}

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  ImageDisplayPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Image'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

class GeneratorOptionsPage extends StatelessWidget {
  const GeneratorOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Image Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OptionButton(
              text: 'Midjourney',
              onPressed: () {
                // Navigate to the Midjourney Generator page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MidjourneyGeneratorPage(),
                ));
              },
            ),
            OptionButton(
              text: 'Stable Diffusion',
              onPressed: () {
                // Navigate to the Stable Diffusion Generator page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StableDiffusionGeneratorPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OptionButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class MidjourneyGeneratorPage extends StatefulWidget {
  @override
  _MidjourneyGeneratorPageState createState() =>
      _MidjourneyGeneratorPageState();
}

class _MidjourneyGeneratorPageState extends State<MidjourneyGeneratorPage> {
  String enteredText = '';
  String apiResponse = '';
  bool isLoading = false; // Track the loading state

  final TextEditingController _textController = TextEditingController();

  void _handleSubmit() async {
    final enteredText = _textController.text.replaceAll(' ', '%20');

    // Set isLoading to true to show the loading indicator
    setState(() {
      isLoading = true;
    });

    final apiUrl = 'https://boredhumans.com/api_text-to-image.php';
    final payload = {
      'prompt': enteredText,
      'model': 'midjourney',
    };

    final response = await http.post(Uri.parse(apiUrl), body: payload);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final output = responseData['output'];

      // Check if the API response contains an image URL
      if (output != null && output is String && output.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageDisplayPage(imageUrl: output),
        ));
      } else {
        // Handle the case where the API response doesn't contain an image URL
        setState(() {
          this.apiResponse = 'No image URL found in the API response.';
        });
      }
    } else {
      // Handle API request error
      setState(() {
        this.apiResponse = 'Error occurred while making the API request.';
      });
    }

    // Set isLoading back to false to hide the loading indicator
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midjourney Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
            if (isLoading)
              CircularProgressIndicator() // Show loading indicator
            else if (apiResponse.isNotEmpty)
              Text(
                'API Response: $apiResponse',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class StableDiffusionGeneratorPage extends StatefulWidget {
  @override
  _StableDiffusionGeneratorPageState createState() =>
      _StableDiffusionGeneratorPageState();
}

class _StableDiffusionGeneratorPageState extends State<StableDiffusionGeneratorPage> {
  String enteredText = '';
  String apiResponse = '';
  bool isLoading = false; // Track the loading state

  final TextEditingController _textController = TextEditingController();

  void _handleSubmit() async {
    final enteredText = _textController.text.replaceAll(' ', '%20');

    // Set isLoading to true to show the loading indicator
    setState(() {
      isLoading = true;
    });

    final apiUrl = 'https://boredhumans.com/api_text-to-image.php';
    final payload = {
      'prompt': enteredText,
      'model': 'stablediffusion',
    };

    final response = await http.post(Uri.parse(apiUrl), body: payload);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final output = responseData['output'];

      // Check if the API response contains an image URL
      if (output != null && output is String && output.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageDisplayPage(imageUrl: output),
        ));
      } else {
        // Handle the case where the API response doesn't contain an image URL
        setState(() {
          this.apiResponse = 'No image URL found in the API response.';
        });
      }
    } else {
      // Handle API request error
      setState(() {
        this.apiResponse = 'Error occurred while making the API request.';
      });
    }

    // Set isLoading back to false to hide the loading indicator
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stable Diffusion Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
            if (isLoading)
              CircularProgressIndicator() // Show loading indicator
            else if (apiResponse.isNotEmpty)
              Text(
                'API Response: $apiResponse',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}

