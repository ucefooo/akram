import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:detection_app/classes/language_constants.dart';

class NewCasePage extends StatefulWidget {
  const NewCasePage({super.key});

  @override
  State<NewCasePage> createState() => _NewCasePageState();
}

class _NewCasePageState extends State<NewCasePage> {
  String? activeHotspotId;

  void setActiveHotspot(String? id) {
    setState(() {
      activeHotspotId = (activeHotspotId == id) ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            translation(context).newCasePageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ModelViewerWithHotspots(
              activeHotspotId: activeHotspotId,
              setActiveHotspot: setActiveHotspot),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ButtonRow(
              activeHotspotId: activeHotspotId,
              activeHotspotIdSetter: setActiveHotspot),
        ),
      ],
    );
  }
}

class ButtonRow extends StatefulWidget {
  final String? activeHotspotId;
  final Function(String?) activeHotspotIdSetter;
  const ButtonRow(
      {super.key,
      required this.activeHotspotId,
      required this.activeHotspotIdSetter});
  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Add cancel functionality here
            widget.activeHotspotIdSetter(widget.activeHotspotId);
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
          child: Text(translation(context).newCasePageCancelButton,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        ),
        // SizedBox(width: 10), // Add small gap between buttons
        ElevatedButton(
          onPressed: widget.activeHotspotId == null
              ? null
              : () {
                  Navigator.of(context, rootNavigator: true).pushNamed('case2');
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
              Text(translation(context).newCasePageNextStepButton,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class ModelViewerWithHotspots extends StatefulWidget {
  final String? activeHotspotId;
  final Function(String) setActiveHotspot;
  const ModelViewerWithHotspots(
      {super.key,
      required this.activeHotspotId,
      required this.setActiveHotspot});

  @override
  _ModelViewerWithHotspotsState createState() =>
      _ModelViewerWithHotspotsState();
}

class _ModelViewerWithHotspotsState extends State<ModelViewerWithHotspots> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModelViewer(
          src: 'assets/male_character.glb',
          alt: "A 3D model",
          ar: false,
          autoRotate: false,
          cameraControls: true,
          disableZoom: true,
          disableTap: true,
          disablePan: true,
          maxCameraOrbit: 'auto 90deg auto',
          minCameraOrbit: 'auto 90deg auto',
        ),
        Positioned(
          top: 60,
          left: 170,
          child: StaticCircularHotspot(
            id: 'head',
            content: 'This is the head',
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'head',
            onTap: widget.setActiveHotspot,
          ),
        ),
        Positioned(
          top: 140,
          left: 150,
          child: StaticCircularHotspot(
            id: 'chest',
            content: 'This is the chest',
            // inactiveColor:
            //     Colors.lightBlue.shade500,
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'chest',
            onTap: widget.setActiveHotspot,
          ),
        ),
        Positioned(
          top: 180,
          left: 220,
          child: StaticCircularHotspot(
            id: 'back',
            content: 'This is the stomach/back',
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'back',
            onTap: widget.setActiveHotspot,
          ),
        ),
        Positioned(
          top: 250,
          left: 100,
          child: StaticCircularHotspot(
            id: 'hand',
            content: 'This is the hand',
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'hand',
            onTap: widget.setActiveHotspot,
          ),
        ),
        Positioned(
          top: 260,
          left: 230,
          child: StaticCircularHotspot(
            id: 'thigh',
            content: 'This is the thigh',
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'thigh',
            onTap: widget.setActiveHotspot,
          ),
        ),
        Positioned(
          top: 350,
          left: 160,
          child: StaticCircularHotspot(
            id: 'leg',
            content: 'This is the leg',
            activeColor: Colors.blue.shade700,
            isActive: widget.activeHotspotId == 'leg',
            onTap: widget.setActiveHotspot,
          ),
        ),
      ],
    );
  }
}

class StaticCircularHotspot extends StatelessWidget {
  final String id;
  final String content;
  final Color inactiveColor;
  final Color activeColor;
  final bool isActive;
  final Function(String) onTap;

  const StaticCircularHotspot({
    super.key,
    required this.id,
    required this.content,
    required this.isActive,
    required this.onTap,
    this.inactiveColor = const Color.fromARGB(255, 193, 206, 218),
    this.activeColor = const Color.fromARGB(255, 124, 132, 139),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => onTap(id),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : inactiveColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        if (isActive)
          Positioned(
            top: 30,
            left: -50,
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                content,
                style: const TextStyle(fontSize: 12, color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
      ],
    );
  }
}
