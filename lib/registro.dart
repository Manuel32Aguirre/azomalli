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
  bool _acceptedTerms = false;

  Future<void> _register() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Debe aceptar los términos y condiciones")),
      );
      return;
    }

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;

        if (user != null) {
          await _createUserInFirestore(user);

          await user.sendEmailVerification();

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

  Future<void> _createUserInFirestore(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
        'nombre': '',
        'apellido': '',
        'genero': '',
        'telefono': '',
        'telefonoFamiliar': '',
        'nivelEstres': '',
        'edad': 0,
        'estatura': 0.0,
        'nombreUsuario': '',
      });
    } catch (e) {
      print("Error al crear la colección de usuario: $e");
    }
  }

  void showTermsModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Términos y Condiciones"),
          content: SingleChildScrollView(
            child: Text(
              "Al usar la aplicación AZOMALLI, aceptas los siguientes términos:\n\n"
              "1. La aplicación ofrece consejos y herramientas para gestionar el estrés, "
              "pero no sustituye el asesoramiento profesional.\n"
              "2. No nos hacemos responsables de posibles consecuencias derivadas del uso de la aplicación.\n"
              "3. La información proporcionada es con fines educativos y de bienestar personal.\n"
              "4. Cualquier decisión tomada basándose en nuestra app es responsabilidad del usuario.\n\n"
              "Al aceptar, confirmas que has leído y aceptado estos términos.",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: showTermsModal,
                            child: const Text(
                              "Acepto los términos y condiciones",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      onPressed: _register,
                      child: const Text("Registrarse"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
