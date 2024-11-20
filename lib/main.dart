import 'package:azomalli/menuPrincipal.dart';
import 'package:azomalli/registro.dart';
import 'package:azomalli/registroDatos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Mi App",
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Inicio()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/img/robot.gif",
        ),
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmail() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          // Verificamos si ya existe la colección para este usuario

          // Mostrar mensaje de éxito
          _showAwesomeDialog(
              "¡Has iniciado sesión exitosamente!", DialogType.success);
          // Verificamos si el campo nombreUsuario está vacío
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .get();

          var userData = userDoc.data() as Map<String, dynamic>;
          if (userData['nombreUsuario'] == '') {
            // Si nombreUsuario está vacío, redirigimos a la pantalla de registro
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistroDatos()),
            );
          } else {
            // Si nombreUsuario no está vacío, redirigimos a la segunda pantalla
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SegundaPantalla(userName: userData['nombreUsuario']),
              ),
            );
          }
        } else {
          // Si el correo no está verificado, muestra una alerta
          _showVerificationAlert();
        }
      }
    } catch (e) {
      String errorMessage = "Error desconocido al intentar iniciar sesión.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "La dirección de correo no es válida.";
            break;
          case 'user-disabled':
            errorMessage = "La cuenta ha sido deshabilitada.";
            break;
          case 'user-not-found':
            errorMessage = "No se encontró una cuenta con ese correo.";
            break;
          case 'wrong-password':
            errorMessage = "La contraseña es incorrecta.";
            break;
          default:
            errorMessage = "Ocurrió un error inesperado: ${e.message}";
            break;
        }
      }

      // Mostrar mensaje de error con AwesomeDialog
      _showAwesomeDialog(errorMessage, DialogType.error);
    }
  }

  // Función para crear la colección del usuario en Firestore

  // Función para mostrar AwesomeDialog con color personalizado
  void _showAwesomeDialog(String message, DialogType dialogType) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: dialogType == DialogType.success ? "¡Éxito!" : "Error",
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: dialogType == DialogType.success ? Colors.green : Colors.red,
    ).show();
  }

  void _showVerificationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Correo no verificado"),
          content: const Text(
              "Por favor verifica tu correo antes de intentar iniciar sesión."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "AZOMALLI",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Image.asset(
                      "assets/img/azomalli.png",
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Ingresa tu usuarioo",
                      labelText: "Usuario",
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(3, 169, 244, 1)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Ingresa tu contraseña",
                      labelText: "Contraseña",
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
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
                    onPressed: _signInWithEmail,
                    child: const Text("Iniciar sesión"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registro()));
                    },
                    child: const Text(
                      "¿No tienes cuenta? Regístrate",
                      style: TextStyle(
                        color: Color.fromARGB(255, 251, 117, 117),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
