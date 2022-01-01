import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_auth_controller.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_fire_store_controller.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_notifications.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helpers,FbNotifications {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_note_screen');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              await FbAuthController().signOut();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/images_screen');
            },
            icon: const Icon(Icons.image),
          ),

        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FbFireStoreController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> notes = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(notes[index].get('title')),
                    subtitle: Text(notes[index].get('info')),
                    trailing: IconButton(
                      onPressed: () async =>
                          await deleteNote(path: notes[index].id),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.warning, size: 80),
                    Text(
                      'NO DATA',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<void> deleteNote({required String path}) async {
    bool status = await FbFireStoreController().delete(path: path);
    String message = status ? 'Deleted Successfully' : 'Delete failed';
    showSnackBar(context: context, message: message, error: !status);
  }
}
