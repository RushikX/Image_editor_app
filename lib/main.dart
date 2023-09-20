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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageData != null) ...[
                const Text(
                  "Original Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (imageData != null) {
                      var initialImage = editedImageData ?? imageData;
                      var editedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageEditor(
                            image: initialImage,
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
                    "Edit the Image",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                if (editedImageData != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Edited Image",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Image.memory(editedImageData!),
                  const SizedBox(
                    height: 16,
                  ),
                  // Display the edited image
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
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
      final directory = await getExternalStorageDirectory();
      final uniqueId = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Generate a unique ID
      final filePath = '${directory!.path}/edited_image_$uniqueId.png';
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
