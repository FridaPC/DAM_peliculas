import 'package:flutter/material.dart';
import 'package:movie_catalog_app/screens/auth/login_screen.dart';
import 'package:movie_catalog_app/screens/movie/simple_movie_detail_screen.dart';

class SimpleMovieCatalogScreen extends StatefulWidget {
  const SimpleMovieCatalogScreen({super.key});

  @override
  State<SimpleMovieCatalogScreen> createState() => _SimpleMovieCatalogScreenState();
}

class _SimpleMovieCatalogScreenState extends State<SimpleMovieCatalogScreen> {
  String _searchQuery = '';

  // Lista de películas de ejemplo
  final List<Map<String, dynamic>> _demoMovies = [
    {
      'title': 'Cadena perpetua',
      'year': 1994,
      'director': 'Frank Darabont',
      'genre': 'Drama',
      'image': 'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg',
      'synopsis': 'A lo largo de varios años, dos presos forman una amistad, buscando consuelo y, eventualmente, redención a través de la compasión básica.',
    },
    {
      'title': 'El padrino',
      'year': 1972,
      'director': 'Francis Ford Coppola',
      'genre': 'Crimen, Drama',
      'image': 'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg',
      'synopsis': 'El envejecido patriarca de una dinastía del crimen organizado transfiere el control de su imperio clandestino a su reacio hijo.',
    },
    {
      'title': 'El caballero oscuro',
      'year': 2008,
      'director': 'Christopher Nolan',
      'genre': 'Acción, Crimen, Drama',
      'image': 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg',
      'synopsis': 'Cuando la amenaza conocida como el Joker causa estragos y caos en la gente de Gotham, Batman debe aceptar una de las mayores pruebas psicológicas y físicas de su capacidad para luchar contra la injusticia.',
    },
    {
      'title': 'Pulp Fiction',
      'year': 1994,
      'director': 'Quentin Tarantino',
      'genre': 'Crimen, Drama',
      'image': 'https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg',
      'synopsis': 'Las vidas de dos sicarios de la mafia, un boxeador, un gángster y su esposa, y un par de bandidos de restaurante se entrelazan en cuatro historias de violencia y redención.',
    },
  ];

  List<Map<String, dynamic>> get _filteredMovies {
    if (_searchQuery.isEmpty) return _demoMovies;
    return _demoMovies.where((movie) {
      return movie['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          movie['director'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          movie['genre'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de películas'),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Mostrar mensaje de logout simulado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cierre de sesión exitoso (simulado)'),
                  backgroundColor: Colors.green,
                ),
              );

              // Navegar a la pantalla de login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar películas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Movie List
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text('No hay películas que coincidan con tu búsqueda'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      return _MovieCard(
                        title: movie['title'],
                        year: movie['year'],
                        imageUrl: movie['image'],
                        onTap: () {
                          // Navegar a la pantalla de detalles
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimpleMovieDetailScreen(
                                title: movie['title'],
                                year: movie['year'],
                                director: movie['director'],
                                genre: movie['genre'],
                                imageUrl: movie['image'],
                                synopsis: movie['synopsis'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final String title;
  final int year;
  final String imageUrl;
  final VoidCallback onTap;

  const _MovieCard({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.movie,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // Movie Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$year',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
