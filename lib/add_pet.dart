import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController breedTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();

  String _family = '';
  String _sex = '';

  void addPet() async {
    FirebaseFirestore.instance.collection('pets').add({
      'name': nameTextEditingController.text,
      'family': _family,
      'breed': breedTextEditingController.text,
      'sex': _sex,
      'age': int.parse(ageTextEditingController.text),
      'date': DateTime.now().toString(),
    });
    nameTextEditingController.clear();
    breedTextEditingController.clear();
    ageTextEditingController.clear();
  }

  void _onFamilySelected(value) {
    setState(() {
      _family = value;
    });
  }
  void _onSexSelected(value) {
    setState(() {
      _sex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: nameTextEditingController,
              decoration: const InputDecoration(
                labelText: '名前',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width/3*2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: '犬',
                          groupValue: _family,
                          onChanged: (value) => _onFamilySelected(value),
                        ),
                        const Text('犬'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: '猫',
                          groupValue: _family,
                          onChanged: (value) => _onFamilySelected(value),
                        ),
                        const Text('猫'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: breedTextEditingController,
              decoration: const InputDecoration(
                labelText: '品種',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width/3*2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: 'オス',
                          groupValue: _sex,
                          onChanged: (value) => _onSexSelected(value),
                        ),
                        const Text('オス'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: 'メス',
                          groupValue: _sex,
                          onChanged: (value) => _onSexSelected(value),
                        ),
                        const Text('メス'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: ageTextEditingController,
              decoration: const InputDecoration(
                labelText: '年齢',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                addPet();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
              child: const Text('登録', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
