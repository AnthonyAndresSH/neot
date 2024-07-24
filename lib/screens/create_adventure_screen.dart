import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreateAdventureScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userPhone;

  CreateAdventureScreen({required this.userId, required this.userName, required this.userPhone});

  @override
  _CreateAdventureScreenState createState() => _CreateAdventureScreenState();
}

class _CreateAdventureScreenState extends State<CreateAdventureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dayController = TextEditingController();
  List<File> _photos = [];
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (_photos.length < 5) {
          _photos.add(File(pickedFile.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No puedes cargar más de 5 fotos')),
          );
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dayController.text = "${picked.toLocal()}".split(' ')[0]; // Formato de la fecha
      });
  }

  Future<void> _createAdventure() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        List<String> photoUrls = await _uploadPhotos();

        await FirebaseFirestore.instance.collection('adventures').add({
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'description': _descriptionController.text.trim(),
          'day': _dayController.text.trim(),
          'photos': photoUrls,
          'createdBy': widget.userName,
          'phone': widget.userPhone,
          'userId': widget.userId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aventura creada exitosamente')),
        );

        Navigator.of(context).pop(); // Regresa a la pantalla anterior después de crear la aventura
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la aventura: ${e.toString()}')),
        );
      }
    }
  }

  Future<List<String>> _uploadPhotos() async {
    List<String> photoUrls = [];
    for (var photo in _photos) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('adventures/$fileName');
      UploadTask uploadTask = storageRef.putFile(photo);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      photoUrls.add(downloadUrl);
    }
    return photoUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Aventura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dayController,
                decoration: InputDecoration(
                  labelText: 'Día',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el día';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Fotos (hasta 5 fotos)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _photos.map((photo) {
                  return Stack(
                    children: [
                      Image.file(
                        photo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _photos.remove(photo);
                            });
                          },
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Cargar Foto'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createAdventure,
                child: Text(
                  'Crear Aventura',
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 23, 111, 241),
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
