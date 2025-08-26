import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadinMessages(){

    final messages = <String>[
      'Cargando películas...',
      'Las mejores peliculas para ti...',
      'Estrenos y clásicos...',
      'Disfruta del cine...'
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          StreamBuilder(
            stream: getLoadinMessages(), 
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('Cargando...');
              
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text( snapshot.data! ),
              );
            },
          )
        ],
      )
    );
  }
} 