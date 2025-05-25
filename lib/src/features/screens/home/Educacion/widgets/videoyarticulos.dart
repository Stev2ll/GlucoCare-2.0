import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  final List<Map<String, String>> videos = const [
    {'title': '¿Qué es la diabetes tipo 1?', 'url': 'https://www.youtube.com/watch?v=Cbzx4QMk_eY'},
    {'title': 'Manejo de glucosa', 'url': 'https://www.youtube.com/watch?v=a8SSV7GNINU'},
    {'title': 'Administración de insulina', 'url': 'https://www.youtube.com/watch?v=wHQtl9Lwv4Q'},
    {'title': 'Complicaciones agudas y crónicas', 'url': 'https://www.youtube.com/watch?v=7hqYuK9osBw'},
    {'title': 'Manejo del estrés', 'url': 'https://www.youtube.com/watch?v=HYPing4b9VM'},
    {'title': 'Importancia del apoyo social y la comunicación', 'url': 'https://www.youtube.com/watch?v=F2xPo_3feXY'},
    {'title': 'Bombas de insulina', 'url': 'https://www.youtube.com/watch?v=rllqSFZvu1I'},
    {'title': 'Cómo usar el glucómetro', 'url': 'https://www.youtube.com/watch?v=V73N09LADbI'},
    {'title': 'Estilo de vida saludable', 'url': 'https://www.youtube.com/watch?v=PAK8Mwn5Tag'},
    {'title': 'Mitos y verdades sobre la diabetes', 'url': 'https://www.youtube.com/watch?v=aulYLKQOr_g'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos Educativos')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(video['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.blue),
              onTap: () => _launchURL(video['url']!),
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}


class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  final List<Map<String, String>> articles = const [
    {'title': '¿Qué es la diabetes?', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/diabetes-tipo-1'},
    {'title': 'Cuándo ir al médico', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/criterios-ingreso-hospitalario'},
    {'title': 'Pastillas y geles para la hipoglucemia', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/consejos/pastillas-geles-productos-tratar-hipoglucemia'},
    {'title': '¿Qué puedo comer si tengo diabetes?', 'url': 'https://www.niddk.nih.gov/health-information/informacion-de-la-salud/diabetes/informacion-general/nutricion-alimentacion-actividad-fisica'},
    {'title': 'Dieta para personas con diabetes', 'url': 'https://medlineplus.gov/spanish/diabeticdiet.html'},
    {'title': 'Medicinas para la diabetes', 'url': 'https://medlineplus.gov/spanish/diabetesmedicines.html'},
    {'title': 'Diabetes mellitus en Ecuador', 'url': 'https://www.salud.gob.ec/msp-presento-el-programa-de-atencion-integral-de-la-diabetes-mellitus/#:~:text=La%20diabetes%20mellitus%20es%20la,con%20diagn%C3%B3stico%20de%20la%20enfermedad.'},
    {'title': 'Complicaciones de la diabetes tipo 1', 'url': 'https://diabetes.sjdhospitalbarcelona.org/es/diabetes-tipo-1/debut/complicaciones'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artículos Educativos')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(article['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.article_outlined, color: Colors.teal),
              onTap: () => _launchURL(article['url']!),
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}