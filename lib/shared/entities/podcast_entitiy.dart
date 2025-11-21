import 'package:equatable/equatable.dart';

class PodcastEntity extends Equatable {
  final String id;
  final String title;
  final String author; // Biz buraya Category basıyoruz
  final String imageUrl;
  final Duration duration;
  final String audioUrl;
  final String description;
  final String categoryId;

  // --- YENİ EKLENENLER ---
  final bool isFavorite;
  final bool isTrend;

  const PodcastEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.duration,
    required this.audioUrl,
    required this.description,
    required this.categoryId,
    // Varsayılan değerler atadık ki eski kodlar bozulmasın
    this.isFavorite = false,
    this.isTrend = false,
  });

  // Equatable props'a isFavorite eklemek önemli!
  // Böylece favori durumu değişince Bloc bunu algılar ve ekranı günceller.
  @override
  List<Object?> get props => [id, isFavorite, isTrend];

  // COPYWITH GÜNCELLEMESİ (En kritik yer burasıydı)
  PodcastEntity copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    Duration? duration,
    String? audioUrl,
    String? description,
    String? categoryId,
    bool? isFavorite, // Yeni
    bool? isTrend,    // Yeni
  }) {
    return PodcastEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      isTrend: isTrend ?? this.isTrend,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'duration': duration.inSeconds,
      'audioUrl': audioUrl,
      'description': description,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
      'isTrend': isTrend,
    };
  }

  factory PodcastEntity.fromMap(Map<String, dynamic> map) {
    return PodcastEntity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      duration: Duration(seconds: map['duration'] ?? 0),
      audioUrl: map['audioUrl'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isTrend: map['isTrend'] ?? false,
    );
  }
}