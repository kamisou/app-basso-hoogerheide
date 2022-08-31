import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newEventProvider =
    StateNotifierProvider<NewCalendarEventNotifier, NewCalendarEvent>(
        (ref) => NewCalendarEventNotifier());

class NewCalendarEventNotifier extends StateNotifier<NewCalendarEvent> {
  NewCalendarEventNotifier() : super(const NewCalendarEvent.empty());

  void setStartTime(TimeOfDay? value) =>
      state = state.copyWith(startTime: value);

  void setEndTime(TimeOfDay? value) => state = state.copyWith(endTime: value);

  void setTitle(String? value) => state = state.copyWith(title: value);

  void setDescription(String? value) =>
      state = state.copyWith(description: value);

  void setColor(Color? value) => state = state.copyWith(color: value);

  String? validateTitle(String? value) =>
      (value?.isEmpty ?? true) ? 'Adicione um título para o evento' : null;
}

class NewCalendarEvent {
  const NewCalendarEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
  });

  const NewCalendarEvent.empty()
      : startTime = null,
        endTime = null,
        title = null,
        description = null,
        color = null;

  final TimeOfDay? startTime;

  final TimeOfDay? endTime;

  final String? title;

  final String? description;

  final Color? color;

  NewCalendarEvent copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? title,
    String? description,
    Color? color,
  }) =>
      NewCalendarEvent(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      );
}
