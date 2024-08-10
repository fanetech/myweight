import 'package:flutter/material.dart';

class AccueilPage extends StatelessWidget {
  final String nom;
  final String prenom;
  final String username;

  AccueilPage({required this.nom, required this.prenom, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          onSelected: (String value) {
            switch (value) {
              case 'Accueil':
                Navigator.pushReplacementNamed(context, '/accueil', arguments: {
                  'nom': nom,
                  'prenom': prenom,
                  'username': username,
                });
                break;
              case 'Suivi Corporel':
                Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                  'nom': nom,
                  'prenom': prenom,
                  'username': username,
                });
                break;
              case 'Profil':
                Navigator.pushReplacementNamed(context, '/profile', arguments: {
                  'nom': nom,
                  'prenom': prenom,
                  'username': username,
                });
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Accueil',
                child: Row(
                  children: [
                    Icon(Icons.home, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Accueil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Suivi Corporel',
                child: Row(
                  children: [
                    Icon(Icons.show_chart, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Suivi Corporel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Profil',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Profil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ];
          },
        ),
        title: Text('Suivi de poids', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              username[0].toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/connexion');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Se déconnecter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(username)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bienvenue $nom $prenom',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/infopoids', arguments: {
                        'nom': nom,
                        'prenom': prenom,
                        'username': username,
                      });
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Renseigner votre poids',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graphique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon profil',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/accueil', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/suivi', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile', arguments: {
                'nom': nom,
                'prenom': prenom,
                'username': username,
              });
              break;
          }
        },
      ),
    );
  }
}
