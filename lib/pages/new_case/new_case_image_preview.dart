import 'package:detection_app/classes/language_constants.dart';
import 'package:detection_app/pages/new_case/new_case_lodaing_analyze.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreviewPage extends StatelessWidget {
  final File imageFile;
  final VoidCallback onCancel;

  const ImagePreviewPage(
      {super.key, required this.imageFile, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onCancel();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImageWidget(),
              _buildOverlay(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(context),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return FutureBuilder<bool>(
      future: imageFile.exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Image.file(
              imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Center(child: Text('Error loading image: $error'));
              },
            );
          } else {
            print('Image file does not exist');
            return const Center(child: Text('Image file not found'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.1),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    return Container(
      color: backgroundColor.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 40),
            onPressed: () {
              onCancel();
              Navigator.pop(context);
            },
          ),
          Text(
            translation(context).newCaseImagePreviewTitle,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 48), // Placeholder for symmetry
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Container(
      height: 100,
      color: backgroundColor.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              onCancel();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFC5F5F),
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Text(
              translation(context).newCaseImagePreviewRetakePhoto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyzeLoadingPage(
                    imageFile: imageFile,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B57A),
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translation(context).newCaseImagePreviewAnalyze,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
