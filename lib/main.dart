import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/interface/theme/app_colors.dart';
import 'package:noteshell/interface/theme/app_theme.dart';
import 'package:noteshell/interface/screens/notes_screen.dart';
import 'package:noteshell/logic/bloc/note_bloc.dart';
import 'package:noteshell/logic/repositories/notes_repository.dart';
import 'package:noteshell/logic/repositories/trash_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryColor));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotesRepository>(
            create: (context) => NotesRepository()),
        RepositoryProvider<TrashRepository>(
            create: (context) => TrashRepository()),
      ],
      child: BlocProvider(
        create: (context) => NoteBloc(
            notesRepository: RepositoryProvider.of<NotesRepository>(context),
            trashRepository: RepositoryProvider.of<TrashRepository>(context)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const NotesScreen(),
        ),
      ),
    );
  }
}
