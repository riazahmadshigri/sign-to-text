import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:http/http.dart' as http; // Added HTTP package
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class SignCameraScreen extends StatefulWidget {
  const SignCameraScreen({super.key});

  @override
  _SignCameraScreenState createState() => _SignCameraScreenState();
}

class _SignCameraScreenState extends State<SignCameraScreen> {
  TextEditingController originalTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  String selectedLanguage = 'English';
   CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription>? cameras;
  bool _isCapturing = false;

  WebSocketChannel? _channel;  // WebSocket channel for communication
  bool _isStreaming = false;
  String label='';
  double confidence=0;
  static const String apiKey = "YOUR_YANDEX_API_KEY"; // Replace with your Yandex API Key
  static const String apiUrl = "https://translate.api.cloud.yandex.net/translate/v2/translate";

  void _disposeCamera() {
    if (_controller != null) {
      print("🛑 Disposing camera...");
      _controller!.dispose().then((_) {
        print("✅ Camera disposed successfully.");
      }).catchError((error) {
        print("❌ Error disposing camera: $error");
      });

      _controller = null; // Ensure controller is reset
    } else {
      print("⚠ Camera already null, nothing to dispose.");
    }
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        print("❌ No cameras found!");
        return;
      }

      final frontCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first, // Fallback if no front camera found
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.unknown, // Use YUV420 format

      );

      // ✅ Properly await initialization
      // ✅ Store the Future before awaiting it
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      print("✅ Camera initialized successfully!");
      print("Aspect Ratio: ${_controller!.value.aspectRatio}");
      print("Preview Size: ${_controller!.value.previewSize}");

      setState(() {}); // Refresh UI
    } catch (e) {
      print("❌ Camera Initialization Error: $e");
    }
  }

  // Initialize WebSocket connection
  Future<void> _initializeWebSocket() async {
    if (_channel == null) {
      _channel = WebSocketChannel.connect(
        // Uri.parse('ws://192.168.18.194:5000/predict'), // Update with your backend URL

        Uri.parse('ws://10.0.2.2:5000/predict'), // Update with your backend URL
      );
      print("✅ 🎉 WebSocket Connected! 🎉 ✅");
      print("🟢 Connection Successful! 🚀");
    }
      print("🔹 Listening for messages...");

      _channel!.stream.listen((message) {

        print("📨 Received from server: $message");
        // Handle incoming WebSocket messages (e.g., translated text or other responses)
        // Parse JSON string into a Dart Map
        final Map<String, dynamic> data = jsonDecode(message);

        // Extract 'detections' list
        List<dynamic> detections = data["detections"];

        // Iterate through detections and get 'label' value
        if (detections.isNotEmpty) {
          for (var detection in detections) {
            label = detection["label"];
            confidence = detection["confidence"];
            // List<int> bbox = List<int>.from(detection["bbox"]);

            print("📌 Detected: $label (Confidence: $confidence)");
            print(originalTextController.text);
            // print("📦 Bounding Box: $bbox");
          }
        } else {
          print('no sign detected');
        }

        setState(() {
          if (label != null && label.isNotEmpty &&
              !originalTextController.text.contains(label)) {
            // print(data);
            originalTextController.value = TextEditingValue(
              text: "${originalTextController.text}$label ",
              // Adds label + space
              selection: TextSelection.collapsed(
                offset: originalTextController.text.length + label.length +
                    1, // Moves cursor
              ),
            );
            label = '';
            // Auto-translate after detecting new sign
            _translateText(originalTextController.text, selectedLanguage);


            // Speak translated text if available, otherwise original text
            String textToSpeak = translatedTextController.text.isNotEmpty
                ? translatedTextController.text
                : originalTextController.text;

            _speakText(textToSpeak);


          }
        });
      });
    }


  Future<void> downloadTranslationModels() async {
    final modelManager = OnDeviceTranslatorModelManager();

    // ✅ Convert TranslateLanguage to String using `.bcpCode`
    List<TranslateLanguage> languages = [
      TranslateLanguage.spanish,  // Spanish
      TranslateLanguage.french,   // French
      TranslateLanguage.urdu,     // Urdu
    ];

    for (TranslateLanguage language in languages) {
      String langCode = language.bcpCode;  // Convert enum to string

      bool isDownloaded = await modelManager.isModelDownloaded(langCode);

      if (!isDownloaded) {
        await modelManager.downloadModel(langCode, isWifiRequired: false);
        print("✅ $langCode model downloaded!");
      } else {
        print("✔️ $langCode model already downloaded.");
      }
    }
  }

  // Capture a frame and send it to the backend via WebSocket
  Future<void> _captureAndSendFrame() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;

      // ✅ Take a picture instead of processing frames
      XFile picture = await _controller!.takePicture();

      Uint8List bytes = await picture.readAsBytes();

      // ✅ Decode image correctly
      // img.Image? original = img.decodeImage(Uint8List.fromList(bytes));
      // if (original == null) {
      //   print("❌ Error: Decoded image is null!");
      //   return;
      // }
      //
      // // ✅ Convert to RGB format (if needed)
      // // img.Image processedImage = img.copyResize(original); // Just to ensure compatibility
      //
      // // ✅ Compress to JPG with lower quality
      // List<int> compressedBytes = img.encodeJpg(original, quality: 40);
      final String base64Image = base64Encode(bytes);

      // ✅ Send to WebSocket
      if (_channel != null && _channel!.sink != null) {
        _channel!.sink.add(jsonEncode({'frame': base64Image}));
        print("✅ Sent latest frame!");
      } else {
        print("🚨 WebSocket disconnected!");
      }
    } catch (e) {
      print("❌ Error capturing frame: $e");
    }
  }
  // Add this package to pubspec.yaml


  // Start streaming camera frames to backend
  Future<void> _startStreaming() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print("🚨 Camera is not initialized yet!");
      return;
    }

    while (true) {
      if (!_isCapturing) {
        _isCapturing = true;
        await _captureAndSendFrame();
        _isCapturing = false;
      }
      await Future.delayed(Duration(milliseconds: 900)); // ~5 FPS
    }
  }



  Future<void> _toggleSpeech() async {
    if (isSpeaking) {
      await flutterTts.stop();
    } else {

      String textToSpeak = translatedTextController.text.isNotEmpty
          ? translatedTextController.text
          : originalTextController.text;
      await flutterTts.speak(textToSpeak); // Speak the text

    }

    setState(() {
      isSpeaking = !isSpeaking; // Toggle icon state
    });
  }

  @override
  void initState()  {
    super.initState();
    _initializeAsync();

  }
  Future<void> _initializeAsync() async {
    await downloadTranslationModels();
    await _initializeWebSocket();
    await _initializeCamera();
    _startStreaming();
    _initializeTTS();
  }
  @override
  void dispose() {
    print("🚀 Disposing screen...");
    _disposeCamera();  // Ensure camera is closed
    _channel?.sink.close(); // Close WebSocket if needed
    super.dispose();
  }

  // Translate text using Yandex API

  Future<void> _translateText(String text, String language) async {
    if (text.isEmpty || language == "English") {
      return; // No translation needed
    }
    print(text);
    print(language);

    // Map user-friendly language names to ML Kit language codes
    Map<String, TranslateLanguage> languageMap = {
      'Spanish': TranslateLanguage.spanish,
      'French': TranslateLanguage.french,
      'Urdu': TranslateLanguage.urdu,
    };

    // Get the correct language code, default to English if not found
    TranslateLanguage? targetLanguage = languageMap[language];
    if (targetLanguage == null) return;

    try {
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english, // Always from English
        targetLanguage: targetLanguage,
      );

      String translatedText = await translator.translateText(text);
      print(translatedText);

      // Update the text controller
      translatedTextController.text = translatedText;

      translator.close(); // Free up resources
    } catch (e) {
      print("❌ Error translating text: $e");
    }
  }

  void _initializeTTS() {
    flutterTts.setLanguage("en-US");  // Default language
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
  }

  void _speakText(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow popping the screen

      onPopInvoked: (didPop) {
        if (!didPop) {
          print("onPopInvoked called: didPop = $didPop");

          _disposeCamera(); // Stop the camera before exiting
        }
      },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Sign to Text Conversion'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ⬅️ Custom back icon
          onPressed: () {
            Navigator.pop(context); // ✅ Goes back to the previous screen
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      child:Column(
        children: [
          // Camera view container
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.black,
              child: Center(
                child: _controller == null
                    ? const CircularProgressIndicator()
                    : FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                    //for webcam
                      return Transform(
                        transform: Matrix4.rotationZ(0), // Rotate 90 degrees clockwise (π/2)
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: 1.0, // Ensure the preview stays square
                          child: CameraPreview(_controller!),
                        ),
                      );
                    //   for mobile orignal
                    //   return AspectRatio(
                    //       aspectRatio: 1.0, // This ensures the preview remains square
                    //       child: CameraPreview(_controller!),
                    //   );


                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          // Original and translated text fields with language dropdown
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  // Original text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: originalTextController,
                        decoration: const InputDecoration(
                          hintText: 'Original Text will appear here...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Language dropdown and volume icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        items: <String>['English', 'Spanish', 'French']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                            _translateText(originalTextController.text, selectedLanguage);
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      MouseRegion(
                        onEnter: (_) {},
                        onExit: (_) {},
                        child: GestureDetector(
                          onTap: _toggleSpeech,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 33, 120, 219),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child:Icon(
                              isSpeaking ? Icons.volume_up : Icons.volume_off,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Translated text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: translatedTextController,
                        decoration: const InputDecoration(
                          hintText: 'Translated Text will appear here...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        // enabled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    ),
    );

  }
}
