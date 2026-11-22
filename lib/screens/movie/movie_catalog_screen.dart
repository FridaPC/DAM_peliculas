import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/screens/auth/login_screen.dart';
import 'package:movie_catalog_app/screens/movie/movie_detail_screen.dart';
import 'package:movie_catalog_app/screens/movie/movie_admin_screen.dart';
import 'package:movie_catalog_app/services/auth_service.dart';
import 'package:movie_catalog_app/services/movie_service.dart';
import 'package:movie_catalog_app/widgets/movie_card.dart';
import 'package:movie_catalog_app/widgets/loading_indicator.dart';

class MovieCatalogScreen extends StatefulWidget {
  const MovieCatalogScreen({super.key});

  @override
  State<MovieCatalogScreen> createState() => _MovieCatalogScreenState();
}

class _MovieCatalogScreenState extends State<MovieCatalogScreen> {
  final MovieService _movieService = MovieService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Catalog'),
        actions: [
          // Admin button
          if (authService.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MovieAdminScreen()),
                );
              },
              tooltip: 'Admin Panel',
            ),
          
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: 'Logout',
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
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Movie List
          Expanded(
            child: StreamBuilder<List<Movie>>(
              stream: _movieService.getMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No movies available'),
                  );
                }
                
                // Filter movies based on search query
                final movies = snapshot.data!.where((movie) {
                  if (_searchQuery.isEmpty) return true;
                  return movie.title.toLowerCase().contains(_searchQuery) ||
                      movie.director.toLowerCase().contains(_searchQuery) ||
                      movie.genre.toLowerCase().contains(_searchQuery);
                }).toList();
                
                if (movies.isEmpty) {
                  return const Center(
                    child: Text('No movies match your search'),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
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
