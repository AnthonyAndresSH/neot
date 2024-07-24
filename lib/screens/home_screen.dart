import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'user_profile_screen.dart';
import 'create_adventure_screen.dart';
import 'MyAdventuresScreen.dart';
import 'AdventureDetailScreen.dart'; // Importa el archivo adventure_detail_screen.dart

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userId;
  final String userPhone;

  HomeScreen({required this.userName, required this.userId, required this.userPhone});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Hola, ${widget.userName}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Descubrir aventura',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sugerencia de aventuras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('adventures').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay aventuras disponibles'));
                  }

                  final adventures = snapshot.data!.docs.where((doc) {
                    final adventureData = doc.data() as Map<String, dynamic>;
                    final name = adventureData['name'].toString().toLowerCase();
                    final location = adventureData['location'].toString().toLowerCase();
                    return name.contains(_searchText) || location.contains(_searchText);
                  }).toList();

                  if (adventures.isEmpty) {
                    return Center(child: Text('No hay aventuras que coincidan con tu búsqueda'));
                  }

                  return ListView.builder(
                    itemCount: (adventures.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (index * 2 < adventures.length)
                            _buildAdventureCard(context, adventures[index * 2]),
                          if (index * 2 + 1 < adventures.length)
                            _buildAdventureCard(context, adventures[index * 2 + 1]),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: widget.userId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAdventureScreen(
                        userId: widget.userId,
                        userName: widget.userName,
                        userPhone: widget.userPhone,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAdventuresScreen(userId: widget.userId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  // Navegar a la pantalla de mensajes
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdventureCard(BuildContext context, QueryDocumentSnapshot adventure) {
    final adventureData = adventure.data() as Map<String, dynamic>;
    final image = adventureData['photos'] != null && adventureData['photos'].isNotEmpty
        ? adventureData['photos'][0]
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdventureDetailScreen(adventure: adventure),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image != null
                    ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              adventureData['name'] ?? 'Sin nombre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}