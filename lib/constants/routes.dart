import 'package:basso_hoogerheide/pages/home/calendar/new_event.dart';
import 'package:basso_hoogerheide/pages/home/contacts/new_contact.dart';
import 'package:basso_hoogerheide/pages/home/folders/annotations.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_search.dart';
import 'package:basso_hoogerheide/pages/home/folders/new_folder.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile/profile.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const LoginPage(),
  '/home': (_) => const HomePage(),
  '/newEvent': (_) => const NewEventPage(),
  '/newContact': (_) => const NewContactPage(),
  '/newFolder': (_) => const NewFolderPage(),
  '/folderSearch': (_) => const FolderSearchPage(),
  '/annotations': (_) => const AnnotationsPage(),
  '/profile': (_) => const ProfilePage(),
};
