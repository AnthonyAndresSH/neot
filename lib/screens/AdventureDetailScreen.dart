import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

class AdventureDetailScreen extends StatelessWidget {
  final DocumentSnapshot adventure;

  AdventureDetailScreen({required this.adventure});

  @override
  Widget build(BuildContext context) {
    final adventureData = adventure.data() as Map<String, dynamic>;
    final List<String> photos = adventureData['photos'].cast<String>();
    final int randomNumber = Random().nextInt(20) + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(adventureData['name'] ?? 'Sin nombre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: photos.map((photo) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(photo, fit: BoxFit.cover, width: 1000);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              adventureData['name'] ?? 'Sin nombre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  adventureData['location'] ?? 'Sin ubicación',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Fecha: ${adventureData['day'] ?? 'Sin fecha'}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(adventureData['description'] ?? 'Sin descripción'),
            SizedBox(height: 16),
            Text(
              'Creado por: ${adventureData['createdBy'] ?? 'Desconocido'}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Teléfono: ${adventureData['phone'] ?? 'Sin teléfono'}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.people, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '$randomNumber personas inscritas',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
