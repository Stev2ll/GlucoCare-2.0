import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/signup_controller.dart';
import 'package:gluco_care/src/features/screens/login/login.dart';
import 'package:gluco_care/src/features/screens/signup/widgets/success_screen.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/image_strings.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:gluco_care/src/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormCreate extends StatefulWidget {
  final bool dark;

  const FormCreate({super.key, required this.dark, required FocusNode focusNode});

  @override
  // ignore: library_private_types_in_public_api
  _FormCreateState createState() => _FormCreateState();
}

class _FormCreateState extends State<FormCreate> {
  final SignupController controller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.fechanacimiento.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    MediaQuery.textScaleFactorOf(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          FocusTraversalGroup(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'Nombre',
                        child: TextFormField(
                          controller: controller.nombre,
                          validator: (value) => TValidator.validateText('Nombre', value),
                          decoration: const InputDecoration(
                            labelText: TTexts.firstName,
                            prefixIcon: Tooltip(message: 'Nombre de pila', child: Icon(Iconsax.user)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: Semantics(
                        label: 'Apellido',
                        child: TextFormField(
                          controller: controller.apellido,
                          validator: (value) => TValidator.validateText('Apellido', value),
                          decoration: const InputDecoration(
                            labelText: TTexts.lastName,
                            prefixIcon: Tooltip(message: 'Apellido paterno', child: Icon(Iconsax.user)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Semantics(
                  label: 'Correo electrónico',
                  child: TextFormField(
                    controller: controller.email,
                    validator: (value) => TValidator.validateEmail(value),
                    decoration: const InputDecoration(
                      labelText: TTexts.email,
                      prefixIcon: Tooltip(message: 'Correo electrónico válido', child: Icon(Iconsax.note)),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Obx(() => Semantics(
                      label: 'Contraseña',
                      child: TextFormField(
                        controller: controller.contrasena,
                        validator: (value) => TValidator.validateContrasena(value),
                        obscureText: controller.contraoculta.value,
                        decoration: InputDecoration(
                          labelText: TTexts.password,
                          hintText: 'Ej: Usuario1@',
                          prefixIcon: const Tooltip(message: 'Contraseña segura', child: Icon(Iconsax.password_check)),
                          suffixIcon: IconButton(
                            onPressed: () => controller.contraoculta.value = !controller.contraoculta.value,
                            icon: Icon(controller.contraoculta.value ? Iconsax.eye_slash : Iconsax.eye),
                            tooltip: controller.contraoculta.value ? 'Mostrar contraseña' : 'Ocultar contraseña',
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: Semantics(
                      label: 'Fecha de nacimiento',
                      child: TextFormField(
                        controller: controller.fechanacimiento,
                        validator: (value) => TValidator.validateFechaNacimiento(value),
                        decoration: const InputDecoration(
                          labelText: TTexts.boarddate,
                          prefixIcon: Tooltip(message: 'Fecha de nacimiento', child: Icon(Iconsax.calendar)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Semantics(
                  label: 'Género',
                  child: DropdownButtonFormField<String>(
                    value: null,
                    onChanged: (String? newValue) {
                      controller.genero.text = newValue!;
                    },
                    items: ['Masculino', 'Femenino', 'Otros'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: TTexts.sex,
                      prefixIcon: Tooltip(message: 'Seleccione su género', child: Icon(Iconsax.user)),
                    ),
                    validator: (value) => TValidator.validateGenero(value),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Semantics(
                  label: 'Peso en kilogramos',
                  child: TextFormField(
                    controller: controller.peso,
                    validator: (value) => TValidator.validatePeso(value),
                    decoration: const InputDecoration(
                      labelText: TTexts.peso,
                      hintText: 'Ej: 70 kg',
                      prefixIcon: Tooltip(message: 'Peso corporal', child: Icon(Iconsax.user)),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Semantics(
                  label: 'Altura en metros',
                  child: TextFormField(
                    controller: controller.altura,
                    validator: (value) => TValidator.validateAltura(value),
                    decoration: const InputDecoration(
                      labelText: TTexts.altura,
                      hintText: 'Ej: 1.75 m',
                      prefixIcon: Tooltip(message: 'Altura corporal', child: Icon(Iconsax.user)),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Focus(
                      child: Obx(() => Checkbox(
                            value: controller.privaPolitic.value,
                            onChanged: (value) => controller.privaPolitic.value = value ?? false,
                          )),
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: TTexts.iAgreeTo),
                            WidgetSpan(
                              child: Semantics(
                                label: 'Política de privacidad',
                                child: Text(
                                  TTexts.privacyPolicy,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: widget.dark ? TColors.white : TColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                            const TextSpan(text: TTexts.and),
                            WidgetSpan(
                              child: Semantics(
                                label: 'Términos de uso',
                                child: Text(
                                  TTexts.termsofUse,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: widget.dark ? TColors.white : TColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: controller.email.text.trim(),
                                  password: controller.contrasena.text.trim(),
                                );
                                await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user?.uid).set({
                                  'nombre': controller.nombre.text,
                                  'apellido': controller.apellido.text,
                                  'email': controller.email.text,
                                  'contrasena': controller.contrasena.text,
                                  'fechaNacimiento': controller.fechanacimiento.text,
                                  'genero': controller.genero.text,
                                  'peso': controller.peso.text,
                                  'altura': controller.altura.text,
                                });
                                Get.to(() => SuccessScreen(
                                      image: TImages.verifyCorrect,
                                      title: TTexts.yourAccountCreatedTitle,
                                      subTitle: TTexts.yourAccountCreatedSubTitle,
                                      onPressed: () => Get.to(() => const LoginScreen()),
                                    ));
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'Error desconocido.';
                                if (e.code == 'weak-password') {
                                  errorMessage = 'La contraseña es muy débil.';
                                } else if (e.code == 'email-already-in-use') {
                                  errorMessage = 'Ya existe una cuenta para este correo electrónico.';
                                }
                                Get.snackbar('Error', errorMessage);
                              } catch (_) {
                                Get.snackbar('Error', 'Error inesperado.');
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.dark ? TColors.white : TColors.primary,
                            foregroundColor: widget.dark ? TColors.primary : TColors.white,                          ),
                    child: _isLoading ? const CircularProgressIndicator() : const Text(TTexts.createAccount,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
