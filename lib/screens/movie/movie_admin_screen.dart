import 'package:flutter/material.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/screens/movie/movie_form_screen.dart';
import 'package:movie_catalog_app/services/movie_service.dart';
import 'package:movie_catalog_app/widgets/loading_indicator.dart';
import 'package:movie_catalog_app/widgets/movie_list_item.dart';

class MovieAdminScreen extends StatefulWidget {
  const MovieAdminScreen({super.key});

  @override
  State<MovieAdminScreen> createState() => _MovieAdminScreenState();
}

class _MovieAdminScreenState extends State<MovieAdminScreen> {
  final MovieService _movieService = MovieService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Administration'),
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
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieListItem(
                      movie: movie,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieFormScreen(movie: movie),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteConfirmation(movie);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(Movie movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie'),
        content: Text('Are you sure you want to delete "${movie.title}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _movieService.deleteMovie(movie.id, movie.imageUrl);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${movie.title} deleted successfully'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
