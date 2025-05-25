import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/navigatio_menu.dart';
import 'package:gluco_care/src/features/screens/login/password_config/forget_password.dart';
import 'package:gluco_care/src/features/screens/signup/signup.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/text_strings.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TLoginFormState createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true; // Estado para mostrar u ocultar la contraseña

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Por favor, llene todos los campos');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Usuario autenticado, redirigir a la pantalla de menú
      Get.to(() => const NavigatioMenu());
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de autenticación
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Get.snackbar('Error', 'Usuario no registrado o contraseña incorrecta');
      } else {
        Get.snackbar('Error', 'Ocurrió un error al verificar el usuario');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
      child: Column(
        children: [
          // Email
          Semantics(
            label: 'Campo de entrada para correo electrónico',
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
                contentPadding: EdgeInsets.symmetric(vertical: 26),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password
          Semantics(
            label: 'Campo de entrada para contraseña',
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                contentPadding: const EdgeInsets.symmetric(vertical: 26),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su contraseña';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),

          // Remember me and forget password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember
              Semantics(
                label: 'Casilla para recordar sesión iniciada',
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
              ),

              // Forget Password
              Semantics(
                label: 'Enlace para recuperar contraseña',
                link: true,
                child: TextButton(
                  onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Sign In Button
          Semantics(
            label: 'Botón para iniciar sesión',
            button: true,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(TTexts.signIn),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Create Account Button
          Semantics(
            label: 'Botón para crear una cuenta nueva',
            button: true,
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(TTexts.createAccount, style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}