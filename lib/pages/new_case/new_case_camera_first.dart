import 'dart:math';

import 'package:fixahead/pages/new_case/new_case_image_preview.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:fixahead/classes/language_constants.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _selectedImg;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _checkCameraPermission() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isCameraPermissionGranted = false;
        });
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isCameraPermissionGranted = true;
          });
        }
      }).catchError((error) {
        print('Error initializing camera: $error');
        if (mounted) {
          setState(() {
            _isCameraPermissionGranted = false;
          });
        }
      });
    } catch (e) {
      print('Error checking camera permission: $e');
      setState(() {
        _isCameraPermissionGranted = false;
      });
    }
  }

  Future _pickFromGallery() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        setState(() {
          _selectedImg = null;
        });
        return;
      }
      setState(() {
        _selectedImg = File(img.path);
      });
      _navigateToPreview();
    } catch (e) {
      print('Error picking from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing gallery: $e')),
      );
    }
  }

  Future<void> _disposeCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      _initializeControllerFuture = null;
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // await _disposeCamera();
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException(
            'No cameras found', 'No cameras available on this device');
      }

      final firstCamera = cameras.first;
      final newController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      _initializeControllerFuture = newController.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _controller = newController;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<String?> _getDownloadsPath() async {
    try {
      if (Platform.isAndroid) {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          final externalDir = await getExternalStorageDirectory();
          return externalDir?.path;
        }
        return directory.path;
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final downloadsDir = Directory('${directory.path}/Downloads');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        return downloadsDir.path;
      }
    } catch (e) {
      print('Could not access the downloads directory: $e');
    }
    return null;
  }

  void _navigateToPreview() async {
    if (_selectedImg != null) {
      // await _disposeCamera();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewPage(
            imageFile: _selectedImg!,
            onCancel: () {
              setState(() {
                _selectedImg = null;
              });
            },
          ),
        ),
      ).then((_) {
        // This will run when returning to the camera page
        if (mounted) {
          _initializeCamera();
        }
      });
    }
  }

  @override
  void dispose() {
    // _disposeCamera();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Camera access is required',
                style: TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => _checkCameraPermission(),
                child: const Text('Grant Access'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _initializeControllerFuture == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_controller!),
                        // _buildCameraPreview(),
                        _buildOverlay(),
                        _buildTopBar(),
                        _buildBottomBar(),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }

  Widget _buildOverlay() {
    // Check if there is a selected image
    if (_selectedImg != null) {
      return Center(
        child: Image.file(
          File(_selectedImg!.path),
          fit: BoxFit.contain, // Adjust the fit as needed
          width: 250,
          height: 250,
        ),
      );
    }

    // If no image is selected, display the original overlay
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            translation(context).newCasePageCameraOverlayText,
            // 'Please focus the desired area\ninside the box for better analysis',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.orange, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_ios_outlined,
                  color: Colors.white, size: 40),
              onPressed: () async {
                if (_controller == null || _controller!.value.isTakingPicture) {
                  return; // Prevent switching if the camera is not initialized or is taking a picture
                }
                try {
                  // Dispose of the current camera controller
                  WidgetsFlutterBinding.ensureInitialized();
                  final cameras = await availableCameras();
                  if (cameras.isEmpty) {
                    throw CameraException('No cameras found',
                        'No cameras available on this device');
                  }
                  if (cameras.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(translation(context)
                              .newCasePageCameraSwitchError)),
                    );
                    return;
                  }
                  await _controller?.dispose();

                  // Get the list of available cameras

                  // Determine the new camera lens direction to switch to
                  CameraDescription? newCamera;
                  final lensDirection = _controller!.description.lensDirection;

                  // if (lensDirection == CameraLensDirection.front) {
                  //   // Switch to back camera if available
                  //   newCamera = cameras.firstWhere((camera) =>
                  //       camera.lensDirection == CameraLensDirection.back);
                  // } else {
                  //   // Switch to front camera if available
                  //   newCamera = cameras.firstWhere((camera) =>
                  //       camera.lensDirection == CameraLensDirection.front);
                  // }

                  newCamera = cameras.firstWhere(
                    (camera) => camera.lensDirection != lensDirection,
                    orElse: () => cameras.first,
                  );

                  // Initialize the new camera
                  _controller = CameraController(
                    newCamera,
                    ResolutionPreset.medium,
                    enableAudio: false,
                    imageFormatGroup: Platform.isIOS
                        ? ImageFormatGroup.bgra8888
                        : ImageFormatGroup.yuv420,
                  );

                  // Reinitialize the camera
                  _initializeControllerFuture = _controller!.initialize();
                  await _initializeControllerFuture;
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error switching camera: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryButton() {
    return Column(
      children: [
        InkWell(
          onTap: _pickFromGallery,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF085cc9), width: 2),
              borderRadius: BorderRadius.circular(15),
              image: null,
            ),
            child: const Icon(Icons.photo, color: Color(0xFF085cc9)),
          ),
        ),
        Text(
          translation(context).newCasePageCameraGalleryButton,
          style: const TextStyle(color: Color(0xFF085cc9)),
        ),
      ],
    );
  }

  Widget _buildCameraButton(Color textColor) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: const Color(0xFF085cc9),
          shape: const CircleBorder(),
          child: Icon(Icons.photo_camera_outlined, color: textColor, size: 36),
          onPressed: () async {
            if (_controller == null || !_controller!.value.isInitialized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Camera not initialized')),
              );
              return;
            }

            try {
              final image = await _controller!.takePicture();
              final String? downloadsPath = await _getDownloadsPath();
              if (downloadsPath == null) {
                throw Exception('Could not access the downloads directory');
              }

              final String fileName =
                  'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final String filePath = path.join(downloadsPath, fileName);

              await File(image.path).copy(filePath);
              await File(image.path).delete();

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Picture saved to $filePath')),
              // );
              setState(() {
                _selectedImg = File(filePath);
              });
              _navigateToPreview();
              print('Picture saved to ${image.path}');
            } catch (e) {
              print('Error taking picture: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error taking picture: $e')),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        // const Text(
        //   'Take Picture',
        //   style: TextStyle(color: Color(0xFF085cc9), fontSize: 16),
        // ),
      ],
    );
  }

  void _popUpTips() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  translation(context).newCasePageCameraTipsTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomPaint(
                  size: const Size(250, 240),
                  painter: GuidelinePainter(context),
                ),
                const SizedBox(height: 20),
                ...buildTipsList(context),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF085cc9),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    translation(context).newCasePageCameraTipsClose,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildTipsList(BuildContext context) {
    return [
      buildTipItem(context, '1', translation(context).newCasePageCameraTips1),
      buildTipItem(context, '2', translation(context).newCasePageCameraTips2),
      buildTipItem(context, '3', translation(context).newCasePageCameraTips3),
      buildTipItem(context, '4', translation(context).newCasePageCameraTips4),
    ];
  }

  Widget buildTipItem(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF085cc9).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFF085cc9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget buildTipsButton() {
    return Column(
      children: [
        InkWell(
          onTap: _popUpTips,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF085cc9), width: 2),
              borderRadius: BorderRadius.circular(25),
              image: null,
            ),
            child: const Icon(
              Icons.question_mark_outlined,
              color: Color(0xFF085cc9),
              size: 30,
            ),
          ),
        ),
        Text(
          translation(context).newCasePageCameraTipsButton,
          style: const TextStyle(color: Color(0xFF085cc9), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        color: textColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGalleryButton(),
                _buildCameraButton(textColor),
                buildTipsButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GuidelinePainter extends CustomPainter {
  final BuildContext context;

  GuidelinePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFF085cc9).withOpacity(0.2);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );

    final paint = Paint()
      ..color = const Color(0xFF085cc9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 1.0;
    final Path dashedPath = Path();
    bool shouldDraw = true;

    for (double i = rect.left; i < rect.right; i += dashWidth + dashSpace) {
      if (shouldDraw) {
        dashedPath.moveTo(i, rect.top);
        dashedPath.lineTo(min(i + dashWidth, rect.right), rect.top);
      }
      shouldDraw = !shouldDraw;
    }

    shouldDraw = true;
    for (double i = rect.top; i < rect.bottom; i += dashWidth + dashSpace) {
      if (shouldDraw) {
        dashedPath.moveTo(rect.right, i);
        dashedPath.lineTo(rect.right, min(i + dashWidth, rect.bottom));
      }
      shouldDraw = !shouldDraw;
    }

    shouldDraw = true;
    for (double i = rect.right; i > rect.left; i -= (dashWidth + dashSpace)) {
      if (shouldDraw) {
        dashedPath.moveTo(i, rect.bottom);
        dashedPath.lineTo(max(i - dashWidth, rect.left), rect.bottom);
      }
      shouldDraw = !shouldDraw;
    }

    shouldDraw = true;
    for (double i = rect.bottom; i > rect.top; i -= (dashWidth + dashSpace)) {
      if (shouldDraw) {
        dashedPath.moveTo(rect.left, i);
        dashedPath.lineTo(rect.left, max(i - dashWidth, rect.top));
      }
      shouldDraw = !shouldDraw;
    }

    canvas.drawPath(dashedPath, paint);

    final cornerLength = size.width * 0.1;

    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + cornerLength)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + cornerLength, rect.top),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerLength, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + cornerLength),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - cornerLength)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left + cornerLength, rect.bottom),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerLength, rect.bottom)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right, rect.bottom - cornerLength),
      paint,
    );

    final centerPaint = Paint()
      ..color = const Color(0xFF085cc9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      4,
      centerPaint,
    );

    final crosshairPaint = Paint()
      ..color = const Color(0xFF085cc9)
      ..strokeWidth = 1;

    const crosshairLength = 10.0;
    canvas.drawLine(
      Offset(size.width / 2 - crosshairLength, size.height / 2),
      Offset(size.width / 2 + crosshairLength, size.height / 2),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - crosshairLength),
      Offset(size.width / 2, size.height / 2 + crosshairLength),
      crosshairPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: translation(context).newCasePageCameraGuidelineText,
        style: const TextStyle(
          color: Color(0xFF085cc9),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        rect.top - 25,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
