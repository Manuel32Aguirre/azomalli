import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MiApp());

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Color de fondo azul
      body: SingleChildScrollView(
        // Aquí se agrega SingleChildScrollView
        padding:
            const EdgeInsets.symmetric(horizontal: 20.0), // Espacio horizontal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Texto en la parte superior, centrado
            Padding(
              padding: const EdgeInsets.only(
                  top: 40.0), // Añadir un poco de margen superior
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
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
            // Contenedor con borde redondeado que encierra los campos y botones
            Container(
              margin: const EdgeInsets.only(
                  top: 100.0), // Más margen superior para desplazar hacia abajo
              padding:
                  const EdgeInsets.all(20.0), // Espacio interno del contenedor
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco para el contenedor
                borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Sombra ligera
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Campo de texto para usuario
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Ingresa tu usuario",
                      labelText: "Usuario",
                      labelStyle: TextStyle(
                          color: Colors.lightBlue), // Color azul claro
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlue), // Línea inferior visible
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromRGBO(3, 169, 244, 1)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio entre campos

                  // Campo de texto para contraseña
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Ingresa tu contraseña",
                      labelText: "Contraseña",
                      labelStyle: TextStyle(
                          color: Colors.lightBlue), // Color azul claro
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.lightBlue), // Línea inferior visible
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Espacio antes de los botones

                  // Botón de iniciar sesión
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color de fondo azul
                      foregroundColor: Colors.white, // Color de texto blanco
                      minimumSize: Size(double.infinity, 50), // Botón más ancho
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Bordes redondeados
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const segundaPantalla()));
                    },
                    child: const Text("Iniciar"),
                  ),
                  const SizedBox(height: 10), // Espacio entre botones

                  // Botón de registrarse
                  TextButton(
                    onPressed: () {
                      // Acción para registrarse
                    },
                    child: Text(
                      "Registrarse",
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 251, 117, 117) // Color vino fuerte
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // Espacio inferior opcional
          ],
        ),
      ),
    );
  }
}

class segundaPantalla extends StatelessWidget {
  const segundaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Segunda activity"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Volver"),
        ),
      ),
    );
  }
}
