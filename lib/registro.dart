import 'package:azomalli/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        // Crear el usuario en Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Obtener el usuario recién creado
        User? user = userCredential.user;

        if (user != null) {
          // Crear la colección del usuario en Firestore
          await _createUserInFirestore(user);

          // Enviar el correo de verificación
          await user.sendEmailVerification();

          // Mostrar mensaje de éxito
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: '¡Éxito!',
            desc:
                'Te hemos enviado un correo de verificación. Revisa tu correo.',
            btnOkOnPress: () {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MiApp()),
                );
              });
            },
          ).show();
        }
      } catch (e) {
        // Mostrar mensaje de error en caso de fallo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
    }
  }

  // Función para crear la colección del usuario en Firestore
  Future<void> _createUserInFirestore(User user) async {
    try {
      // Crear el documento con los campos vacíos
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
        'nombre': '', // Nombres aún no asignados
        'apellido': '', // Apellido paterno aún no asignado
        'genero': '', // Género aún no asignado
        'telefono': '', // Teléfono aún no asignado
        'telefonoFamiliar': '', // Teléfono familiar aún no asignado
        'nivelEstres': '', // El estado actual estará vacío por ahora
        'edad': 0, // Edad aún no asignada
        'estatura': 0.0, // Estatura aún no asignada
        'nombreUsuario': '', // El nombre de usuario aún no se ha asignado
      });
    } catch (e) {
      print("Error al crear la colección de usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "AZOMALLI",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Correo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Confirmar Contraseña",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _register, // Función de registro
                      child: const Text("Registrarse"),
                    ),
                  ],
                ),
              ),
            ),
            // Aquí puedes agregar los botones de Google y Facebook si lo deseas
          ],
        ),
      ),
    );
  }
}
