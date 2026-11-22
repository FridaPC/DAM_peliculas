import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:movie_catalog_app/models/movie.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'movies';

  // Get all movies
  Stream<List<Movie>> getMovies() {
    return _firestore
        .collection(_collection)
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get a single movie by ID
  Future<Movie?> getMovie(String id) async {
    DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Movie.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Add a new movie
  Future<String> addMovie(Movie movie, File? imageFile) async {
    String imageUrl = '';
    
    // Upload image if provided
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    
    // Create a new movie with the image URL
    Movie newMovie = Movie(
      id: movie.id,
      title: movie.title,
      year: movie.year,
      director: movie.director,
      genre: movie.genre,
      synopsis: movie.synopsis,
      imageUrl: imageUrl,
    );
    
    // Add to Firestore
    DocumentReference docRef = await _firestore.collection(_collection).add(newMovie.toMap());
    return docRef.id;
  }

  // Update an existing movie
  Future<void> updateMovie(Movie movie, File? imageFile) async {
    String imageUrl = movie.imageUrl;
    
    // Upload new image if provided
    if (imageFile != null) {
      // Delete old image if exists
      if (imageUrl.isNotEmpty) {
        await _deleteImage(imageUrl);
      }
      imageUrl = await _uploadImage(imageFile);
    }
    
    // Update movie with new image URL if changed
    Movie updatedMovie = Movie(
      id: movie.id,
      title: movie.title,
      year: movie.year,
      director: movie.director,
      genre: movie.genre,
      synopsis: movie.synopsis,
      imageUrl: imageUrl,
    );
    
    // Update in Firestore
    await _firestore.collection(_collection).doc(movie.id).update(updatedMovie.toMap());
  }

  // Delete a movie
  Future<void> deleteMovie(String id, String imageUrl) async {
    // Delete image if exists
    if (imageUrl.isNotEmpty) {
      await _deleteImage(imageUrl);
    }
    
    // Delete from Firestore
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = _storage.ref().child('movie_images/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  // Delete image from Firebase Storage
  Future<void> _deleteImage(String imageUrl) async {
    try {
      Reference reference = _storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
