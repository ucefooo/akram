import 'dart:convert';

import 'package:detection_app/pages/new_case/new_case_result.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:detection_app/classes/language_constants.dart';
import 'package:http/http.dart' as http;

class AnalyzeLoadingPage extends StatefulWidget {
  final File imageFile;

  const AnalyzeLoadingPage({super.key, required this.imageFile});

  @override
  State<AnalyzeLoadingPage> createState() => _AnalyzeLoadingPageState();
}

class _AnalyzeLoadingPageState extends State<AnalyzeLoadingPage> {
  String results = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getResults(widget.imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildControls(context)),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildOverlay(),
        _buildBottomBar(context),
        _buildBottomBarText(context),
        FloatingActionButton(
          onPressed: () {
            // if (!isLoading && results.isEmpty) _getResults(widget.imageFile);
            // if (isLoading) {
            //   return;
            // }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewCaseResult(
                  imageFile: widget.imageFile,
                  results: '80%',
                ),
              ),
            );
          },
          child: const Icon(Icons.next_plan_outlined),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 350,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              20), // Match the borderRadius of the Container
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, size: 40),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    translation(context).newCaseCancelTestPopUpTitle,
                    // "Are you sure you want to cancel the new test?",
                    style: const TextStyle(
                        fontSize: 16), // Adjust font size if needed
                  ),
                  content: Text(
                    translation(context).newCaseCancelTestPopUpContent,
                    // 'Do you want to discard the current test?'
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            backgroundColor: const Color(0xFFFC5F5F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 40),
                            maximumSize: const Size(120, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            translation(context).newCaseCancelTestPopUpCancel,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            backgroundColor: const Color(0xFF00B57A),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 40),
                            maximumSize: const Size(120, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            translation(context).newCaseCancelTestPopUpContinue,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
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
        Text(
          translation(context).newCaseAnalyzeLoadingTitle,
          // 'Analyzing...',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 48), // Placeholder for symmetry
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Text(
        translation(context).newCaseAnalyzeLoadingSubtitle,
        // 'Analyzing your photo',
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00B57A)),
      ),
    );
  }

  Widget _buildBottomBarText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        translation(context).newCaseAnalyzeLoadingContent,
        // 'please be patient,\nit may take some time...',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 134, 134, 134),
        ),
      ),
    );
  }

  Future _getResults(File img) async {
    setState(() {
      isLoading = true;
      results = '';
    });

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.1.12:8000/api/image/'));

      request.files.add(await http.MultipartFile.fromPath('image', img.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        setState(() {
          var jsonResponse = json.decode(responseBody);
          results = jsonResponse['result'];
          isLoading = false;
        });
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewCaseResult(
              imageFile: widget.imageFile,
              results: results,
            ),
          ),
        );
      } else {
        setState(() {
          results = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        results = 'Error: $e';
        isLoading = false;
      });
    }
  }
}
