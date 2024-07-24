import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAdventuresScreen extends StatelessWidget {
  final String userId;

  MyAdventuresScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Aventuras'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('adventures')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No has creado ninguna aventura.'));
          }

          final adventures = snapshot.data!.docs;

          return ListView.builder(
            itemCount: adventures.length,
            itemBuilder: (context, index) {
              final adventure = adventures[index];
              final adventureData = adventure.data() as Map<String, dynamic>;
              final image = adventureData['photos'] != null && adventureData['photos'].isNotEmpty
                  ? adventureData['photos'][0]
                  : null;

              return ListTile(
                leading: image != null
                    ? Image.network(
                  image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
                )
                    : Icon(Icons.image, size: 50),
                title: Text(adventureData['name'] ?? 'Sin nombre'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(adventureData['location'] ?? 'Sin ubicación'),
                    Text(adventureData['description'] ?? 'Sin descripción'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, adventure.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String adventureId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar esta aventura?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseFirestore.instance
                  .collection('adventures')
                  .doc(adventureId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aventura eliminada.')),
              );
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
  }
}
