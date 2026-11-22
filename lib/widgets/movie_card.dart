import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_catalog_app/models/movie.dart';
import 'package:movie_catalog_app/widgets/loading_indicator.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
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
              child: Hero(
                tag: 'movie-${movie.id}',
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: movie.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: movie.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const LoadingIndicator(size: 30),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.movie,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
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
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${movie.year} • ${movie.genre}',
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
