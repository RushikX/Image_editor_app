import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageEditorExample(),
    ),
  );
}

class ImageEditorExample extends StatefulWidget {
  const ImageEditorExample({
    super.key,
  });

  @override
  createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  Uint8List? imageData;
  Uint8List? editedImageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "ImageEditor Example",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (editedImageData != null) ...[
              Image.memory(editedImageData!), // Show edited image
              const SizedBox(height: 16),
            ],
            if (imageData != null) ...[
              Image.memory(imageData!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final selectedImageData = await loadAsset();
                  if (selectedImageData != null) {
                    setState(() {
                      imageData = selectedImageData;
                      editedImageData = null; // Clear previously edited image
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Select an Image",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imageData != null) {
                    var editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          image: imageData,
                        ),
                      ),
                    );

                    // Replace with edited image and update UI
                    if (editedImage != null) {
                      setState(() {
                        editedImageData = editedImage;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Single image editor",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              if (editedImageData != null) ...[
                ElevatedButton(
                  onPressed: () {
                    saveEditedImage(editedImageData!);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Save Image",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ] else ...[
              ElevatedButton(
                onPressed: () async {
                  final selectedImageData = await loadAsset();
                  if (selectedImageData != null) {
                    setState(() {
                      imageData = selectedImageData;
                      editedImageData = null; // Clear previously edited image
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Select an Image",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> loadAsset() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var data = await pickedFile.readAsBytes();
      return data.buffer.asUint8List();
    }
    return null;
  }

  Future<void> saveEditedImage(Uint8List editedImage) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/edited_image.png';
      final file = File(filePath);
      await file.writeAsBytes(editedImage);

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved successfully'),
        ),
      );
    } catch (e) {
      // Show a failure message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image save failed: $e'),
        ),
      );
    }
  }
}
