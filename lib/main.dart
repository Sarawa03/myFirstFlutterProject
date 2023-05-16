import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:saranotes/constants/routes.dart';
import 'package:saranotes/services/auth/auth_services.dart';
import 'package:saranotes/views/login_view.dart';
import 'package:saranotes/views/notes/create_update_note_view.dart';
import 'package:saranotes/views/notes/notes_view.dart';
import 'package:saranotes/views/register_view.dart';
import 'package:saranotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      notesRoute: (context) => const NotesView(),
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      creteOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentuser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('Email is verified');
                return const NotesView();
                //return Text('Email is verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          /*final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                return const Text('Done');
              } else {
                return const VerifyEmailView();
            return const LoginView();
              }*/

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
