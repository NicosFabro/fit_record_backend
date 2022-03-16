import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.dateCreated,
    this.dateUpdated,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var dateTimeNow = DateTime.now();
    var dateCreated = json['dateCreated'] != null
        ? DateTime.parse(json['dateCreated'])
        : dateTimeNow;
    var dateUpdated = json['dateUpdated'] != null
        ? DateTime.parse(json['dateUpdated'])
        : dateTimeNow;
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      dateCreated: dateCreated,
      dateUpdated: dateUpdated,
    );
  }

  factory Exercise.fromJsonWithoutId(Map<String, dynamic> json) {
    return Exercise(
      id: '',
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'dateCreated': dateCreated?.toString(),
        // 'dateCreated': dateCreated?.toIso8601String(),
        'dateUpdated': dateUpdated?.toIso8601String(),
      };

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    DateTime? dateUpdated,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      dateCreated: dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  static const empty = Exercise(
    id: '',
    name: '',
    description: '',
    image: '',
    dateCreated: null,
    dateUpdated: null,
  );

  bool get isEmpty => this == empty;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        dateCreated,
        dateUpdated,
      ];

  @override
  String toString() {
    return 'Exercise$props';
  }
}
