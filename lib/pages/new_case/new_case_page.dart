import 'package:flutter/material.dart';
import 'package:fixahead/classes/language_constants.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Text(
            translation(context).newCasePageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: ButtonRow(),
        ),
      ],
    );
  }
}

class ButtonRow extends StatefulWidget {
  const ButtonRow();
  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: ()=>Navigator.of(context, rootNavigator: true).pushNamed('case2'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF085cc9),
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

