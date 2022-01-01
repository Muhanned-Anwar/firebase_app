import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_fire_store_controller.dart';
import 'package:vp7_firebase_app/models/note.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController = TextEditingController();
    _infoTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREATE NOTE'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          TextField(
            controller: _titleTextController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: _infoTextController,
            decoration: const InputDecoration(hintText: 'Info'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await performSave(),
            child: const Text('SAVE'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
            ),
          )
        ],
      ),
    );
  }

  Future<void> performSave() async {
    if (checkData()) {
      save();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context: context, message: 'Enter required data', error:  true);
    return false;
  }

  Future<void> save() async {
    bool status = await FbFireStoreController().create(note: note);
    String message = status ? 'Created Successfully' : 'Create failed';
    showSnackBar(context: context, message: message, error:  !status);
    if(status) clear();
  }

  Note get note {
    Note note = Note();
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }

  void clear(){
    _titleTextController.text = '';
    _infoTextController.text = '';
  }
}
