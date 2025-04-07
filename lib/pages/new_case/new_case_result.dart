import 'package:fixahead/boxes.dart';
import 'package:fixahead/main_layout.dart';
import 'package:fixahead/result.dart';
import 'package:fixahead/router/route_constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fixahead/classes/language_constants.dart';

class NewCaseResult extends StatefulWidget {
  final File imageFile;
  final String results;
  const NewCaseResult(
      {super.key, required this.imageFile, required this.results});

  @override
  State<NewCaseResult> createState() => _NewCaseResultState();
}

class _NewCaseResultState extends State<NewCaseResult> {
  @override
  void initState() {
    super.initState();
    _verifyFile();
  }

  void _verifyFile() {
    try {
      if (!widget.imageFile.existsSync()) {
        debugPrint('Image file does not exist: ${widget.imageFile.path}');
      } else {
        debugPrint('Image file exists: ${widget.imageFile.path}');
        debugPrint('Image file size: ${widget.imageFile.lengthSync()} bytes');
      }
    } catch (e) {
      debugPrint('Error checking image file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 40,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          translation(context)
                                              .newCaseCancelTestPopUpTitle,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        content: Text(
                                          translation(context)
                                              .newCaseCancelTestPopUpContent,
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst),
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  backgroundColor:
                                                      const Color(0xFFFC5F5F),
                                                  foregroundColor: Colors.white,
                                                  minimumSize:
                                                      const Size(120, 40),
                                                  maximumSize:
                                                      const Size(120, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: Text(
                                                  translation(context)
                                                      .newCaseCancelTestPopUpCancel,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  backgroundColor:
                                                      const Color(0xFF085cc9),
                                                  foregroundColor: Colors.white,
                                                  minimumSize:
                                                      const Size(120, 40),
                                                  maximumSize:
                                                      const Size(120, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: Text(
                                                  translation(context)
                                                      .newCaseCancelTestPopUpContinue,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              height: 300,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image(
                                      image: FileImage(widget.imageFile),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        debugPrint(
                                            'Error loading image: $error');
                                        debugPrint('Stack trace: $stackTrace');
                                        return const Center(
                                          child: Text(
                                            'Error loading image',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                      },
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (frame == null) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return child;
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 205, 221, 216),
                                              Color(0xFF085cc9)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${widget.results} ${translation(context).newCaseResultOfLechmaniasis}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: const Divider(
                                    color: Color(0xFF085cc9), thickness: 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translation(context).newCaseResultResults,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  SizedBox(
                                    height: 120,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        '${translation(context).newCaseResultAfterAnalysis} ${widget.results} ${translation(context).newCaseResultOfLechmaniasis}.',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Bottom Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 12.0,
                                  left: 8.0,
                                  right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButton(
                                    backgroundColor: Colors.red,
                                    text: translation(context)
                                        .newCaseResultRedoTest,
                                    onPressed: () {
                                      setState(() {
                                        boxResult.put(
                                            'key_${widget.imageFile.path}',
                                            Result(
                                              imagePath: widget.imageFile.path,
                                              results: widget.results,
                                              date: DateTime.now(),
                                            ));
                                      });
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                  ),
                                  CustomButton(
                                    backgroundColor: Colors.blue[600]!,
                                    text: translation(context)
                                        .newCaseResultSaveResults,
                                    onPressed: () async {
                                      setState(() {
                                        boxResult.put(
                                            'key_${widget.imageFile.path}',
                                            Result(
                                              imagePath: widget.imageFile.path,
                                              results: widget.results,
                                              date: DateTime.now(),
                                            ));
                                      });
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainLayout(
                                                  initialRoute: savedCaseRoute,
                                                )),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 40),
        maximumSize: const Size(120, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
