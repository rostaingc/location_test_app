import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Web Location Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? position;
  String? error;


Future<Position?> getCurrentPosition() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return null;
  }
  if (permission == LocationPermission.denied) {
    final permission = await Geolocator.requestPermission();
    
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      return null;
    }
  }

  return Geolocator.getCurrentPosition();
}

  Future<void> _getLocation() async {
      
    try {
      final newPosition = await getCurrentPosition();
      setState(() {
        position = newPosition;
      });
    } catch (e) {
      // If an error occurs, we can handle it here.
      setState(() {
        position = null;
        error = e.toString();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('My location:'),
            Text(
              position != null
                  ? 'Lat: ${position!.latitude}, Lon: ${position!.longitude}'
                  : 'Unknown',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (error != null)
              Text(
                'Error: $error',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
