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

  const FormCreate({super.key, required this.dark});

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.nombre,
                  validator: (value) =>
                      TValidator.validateText('Nombre', value),
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.apellido,
                  validator: (value) =>
                      TValidator.validateText('Apellido', value),
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.note),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Obx(
            () => TextFormField(
              controller: controller.contrasena,
              validator: (value) => TValidator.validateContrasena(value),
              obscureText: controller.contraoculta.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                hintText: 'Ej: Usuario1@',
                suffixIcon: IconButton(
                  onPressed: () => controller.contraoculta.value =
                      !controller.contraoculta.value,
                  icon: Icon(controller.contraoculta.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller.fechanacimiento,
                validator: (value) => TValidator.validateFechaNacimiento(value),
                decoration: const InputDecoration(
                  labelText: TTexts.boarddate,
                  prefixIcon: Icon(Iconsax.calendar),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          DropdownButtonFormField<String>(
            value: null,
            onChanged: (String? newValue) {
              controller.genero.text = newValue!;
            },
            items: ['Masculino', 'Femenino', 'Otros']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: TTexts.sex,
              prefixIcon: Icon(Iconsax.user),
            ),
            validator: (value) => TValidator.validateGenero(value),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.peso,
            validator: (value) => TValidator.validatePeso(value),
            decoration: const InputDecoration(
              labelText: TTexts.peso,
              prefixIcon: Icon(Iconsax.user),
              hintText: 'Ej: 70 kg',
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.altura,
            validator: (value) => TValidator.validateAltura(value),
            decoration: const InputDecoration(
              labelText: TTexts.altura,
              prefixIcon: Icon(Iconsax.user),
              hintText: 'Ej: 1.75 m',
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: Obx(() => Checkbox(
                      value: controller.privaPolitic.value,
                      onChanged: (value) =>
                          controller.privaPolitic.value = value ?? false,
                    )),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: TTexts.iAgreeTo,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10.0),
                    ),
                    TextSpan(
                      text: TTexts.privacyPolicy,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 10.0,
                            color:
                                widget.dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                widget.dark ? TColors.white : TColors.primary,
                          ),
                    ),
                    TextSpan(
                      text: TTexts.and,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10.0),
                    ),
                    TextSpan(
                      text: TTexts.termsofUse,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 10.0,
                            color:
                                widget.dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                widget.dark ? TColors.white : TColors.primary,
                          ),
                    ),
                  ],
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
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          // Registro en Firebase Authentication
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: controller.email.text.trim(),
                            password: controller.contrasena.text.trim(),
                          );

                          // Guardar información adicional en Firestore
                          await FirebaseFirestore.instance
                              .collection('usuarios')
                              .doc(userCredential.user?.uid)
                              .set({
                            'nombre': controller.nombre.text,
                            'apellido': controller.apellido.text,
                            'email': controller.email.text,
                            'contrasena': controller.contrasena.text,
                            'fechaNacimiento': controller.fechanacimiento.text,
                            'genero': controller.genero.text,
                            'peso': controller.peso.text,
                            'altura': controller.altura.text,
                          });

                          Get.to(() =>  SuccessScreen(
                        image: TImages.verifyCorrect,
                        title: TTexts.yourAccountCreatedTitle,
                        subTitle: TTexts.yourAccountCreatedSubTitle,
                        onPressed: () => Get.to(() => const LoginScreen()),
                      ));
                        } on FirebaseAuthException catch (e) {
                          String errorMessage;
                          if (e.code == 'weak-password') {
                            errorMessage =
                                'La contraseña proporcionada es demasiado débil.';
                          } else if (e.code == 'email-already-in-use') {
                            errorMessage =
                                'La cuenta ya existe para ese correo electrónico.';
                          } else {
                            errorMessage =
                                'Ocurrió un error al registrar el usuario.';
                          }
                          Get.snackbar('Error', errorMessage);
                        } catch (e) {
                          Get.snackbar('Error', 'Ocurrió un error inesperado.');
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
