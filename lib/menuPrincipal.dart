import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azomalli/chatbot.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SegundaPantalla extends StatefulWidget {
  final String userName;

  const SegundaPantalla({Key? key, required this.userName}) : super(key: key);

  @override
  _SegundaPantallaState createState() => _SegundaPantallaState();
}

class _SegundaPantallaState extends State<SegundaPantalla> {
  @override
  void initState() {
    super.initState();
    // Mostrar el Toast con el nombre del usuario
    Fluttertoast.showToast(
      msg: "Usuario actual: ${widget.userName}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actual de Firebase
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo y título en una fila (horizontal)
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/azomalli.png",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "AZOMALLI",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            // Frase de motivación
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "No mires el reloj. Haz lo mismo que él: ve avanzando -- Sam Levenson",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Bienvenida con el nombre del usuario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Bienvenido, ${widget.userName}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón de estadísticas y estado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para navegar a la pantalla de estadísticas
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Estadísticas"),
              ),
            ),
            const SizedBox(height: 10),

            // Estado: bien en verde
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Estado: Bien",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botones en la mitad de la pantalla hacia abajo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de retos personales
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para los retos personales
                    },
                    child: const Text("Retos Personales"),
                  ),
                  // Botón de ejercicio del día
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para el ejercicio del día
                    },
                    child: const Text("Ejercicio del día"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de plan alimenticio
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para el plan alimenticio
                    },
                    child: const Text("Plan Alimenticio"),
                  ),
                  // Botón de consejo
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para el consejo
                    },
                    child: const Text("Consejo"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // Barra de navegación en la parte inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Emergencias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "IA",
          ),
        ],
        onTap: (index) {
          // Lógica para cada uno de los botones
          if (index == 0) {
            // Lógica para emergencias
          } else if (index == 1) {
            // Lógica para el perfil
          } else if (index == 2) {
            // Navegar al chatbot o pantalla IA
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          }
        },
      ),
    );
  }
}
