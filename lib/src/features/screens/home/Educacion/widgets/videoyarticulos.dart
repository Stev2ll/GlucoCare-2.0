import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {'title': '¿Qué es la diabetes tipo 1?', 'url': 'https://www.youtube.com/watch?v=Cbzx4QMk_eY'},
      {'title': 'Manejo de Glucosa', 'url': 'https://www.youtube.com/watch?v=a8SSV7GNINU'},
      {'title': 'Administración de insulina', 'url': 'https://www.youtube.com/watch?v=wHQtl9Lwv4Q'},
      {'title': 'Complicaciones agudas y crónicas', 'url': 'https://www.youtube.com/watch?v=7hqYuK9osBw'},
      {'title': 'Manejo del estrés', 'url': 'https://www.youtube.com/watch?v=HYPing4b9VM'},
      {'title': 'Importancia del apoyo social y la comunicación', 'url': 'https://www.youtube.com/watch?v=F2xPo_3feXY'},
      {'title': 'Bombas de insulina', 'url': 'https://www.youtube.com/watch?v=rllqSFZvu1I'},
      {'title': 'Como usar el Glucometro', 'url': 'https://www.youtube.com/watch?v=V73N09LADbI'},
      {'title': 'Estilo de Vida Saludable', 'url': 'https://www.youtube.com/watch?v=PAK8Mwn5Tag'},
      {'title': 'Mitos y Verdades sobre la diabetes', 'url': 'https://www.youtube.com/watch?v=aulYLKQOr_g'},

    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos Educativos'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videos[index]['title']!),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              _launchURL(videos[index]['url']!);
            },
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> articles = [
      {'title': '¿ Qué es la diabetes ?', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/diabetes-tipo-1'},
      {'title': 'Cuándo ir al médico', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/criterios-ingreso-hospitalario'},
      {'title': 'Pastillas y geles: productos para tratar la hipoglucemia', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/consejos/pastillas-geles-productos-tratar-hipoglucemia'},
      {'title': '¿Qué puedo comer si tengo diabetes?', 'url': 'https://www.niddk.nih.gov/health-information/informacion-de-la-salud/diabetes/informacion-general/nutricion-alimentacion-actividad-fisica'},
      {'title': 'Dieta para diabéticos', 'url': 'https://medlineplus.gov/spanish/diabeticdiet.html'},
      {'title': 'Medicinas para la diabetes', 'url': 'https://medlineplus.gov/spanish/diabetesmedicines.html'},
      {'title': 'La diabetes mellitus es la tercera causa de mortalidad general en el pais', 'url': 'https://www.salud.gob.ec/msp-presento-el-programa-de-atencion-integral-de-la-diabetes-mellitus/#:~:text=La%20diabetes%20mellitus%20es%20la,con%20diagn%C3%B3stico%20de%20la%20enfermedad.'},
      {'title': 'Complicaciones', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/complicaciones'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artículos Educativos'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index]['title']!),
            trailing: const Icon(Icons.article),
            onTap: () {
              _launchURL(articles[index]['url']!);
            },
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
