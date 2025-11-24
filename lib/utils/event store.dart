import 'package:flutter/material.dart';

class EventModel {
  final String title;
  final String description;
  final String category;
  final String date;
  final String time;
  final String location;

  EventModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
  });
}


final List<EventModel> globalEvents = [];
final List<EventModel> myEvents = [];
