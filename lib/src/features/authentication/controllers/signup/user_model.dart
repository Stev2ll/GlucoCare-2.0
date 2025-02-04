class UserModel {
  final String id;
  String nombres;
  String apellidos;
  final String email;
  final String contrasena;
  String fechanacimiento;
  String genero;
  String peso;
  String altura;
  String fotperfil;

  UserModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.contrasena,
    required this.fechanacimiento,
    required this.genero,
    required this.peso,
    required this.altura,
    required this.fotperfil,
  });

  // Me une los nombres
  String get fullName => '$nombres $apellidos';

  // Convierte los datos en formato JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': email,
      'contrasena': contrasena,
      'fechanacimiento': fechanacimiento,
      'genero': genero,
      'peso': peso,
      'altura': altura,
      'fotperfil': fotperfil,
    };
  }
}
