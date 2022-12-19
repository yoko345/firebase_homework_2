import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_pet.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ペット情報アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'ペット情報アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Stream<QuerySnapshot> _petsStream = FirebaseFirestore.instance.collection('pets').orderBy('date').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: [
          GestureDetector(
            onTapDown: (positions) {
              final position = positions.globalPosition;
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
                items: [
                  PopupMenuItem(
                    value: '犬のみ',
                    child: const Text('犬のみ'),
                    onTap: (){
                      setState(() {
                        _petsStream = FirebaseFirestore.instance.collection('pets').where('family', isEqualTo: '犬').snapshots();
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: '猫のみ',
                    child: const Text('猫のみ'),
                    onTap: (){
                      setState(() {
                        _petsStream = FirebaseFirestore.instance.collection('pets').where('family', isEqualTo: '猫').snapshots();
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: '年齢：昇順',
                    child: const Text('年齢：昇順'),
                    onTap: (){
                      setState(() {
                        _petsStream = FirebaseFirestore.instance.collection('pets').orderBy('age', descending: false).snapshots();
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: '年齢：降順',
                    child: const Text('年齢：降順'),
                    onTap: (){
                      setState(() {
                        _petsStream = FirebaseFirestore.instance.collection('pets').orderBy('age', descending: true).snapshots();
                      });
                    },
                  ),
                ],
              );
            },
            child: const Icon(Icons.sort, color: Colors.white,),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot> (
            stream: _petsStream,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<DocumentSnapshot> petsData = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                      itemCount: petsData.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> petData = petsData[index].data()! as Map<String, dynamic>;
                        return petCard(petData);
                      }
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AddPet();})),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget petCard(Map<String, dynamic> petData) {
    return Card(
      child: ListTile(
        title: Text('名前：${petData['name']}　品種：${petData['breed']}　性別：${petData['sex']}　年齢：${petData['age']}'),
      ),
    );
  }

}
