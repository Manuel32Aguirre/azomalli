import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azomalli/chatbot.dart';
import 'package:azomalli/perfil.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SegundaPantalla extends StatefulWidget {
  final String userName;

  const SegundaPantalla({Key? key, required this.userName}) : super(key: key);

  @override
  _SegundaPantallaState createState() => _SegundaPantallaState();
}

class _SegundaPantallaState extends State<SegundaPantalla> {
  int _selectedRating = 0;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int localSelectedRating = _selectedRating;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.8,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Califica la App",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Por favor, selecciona una calificación:"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < localSelectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              localSelectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedRating = localSelectedRating;
                        });
                        showToast(
                            "Gracias por calificar con $_selectedRating estrellas.");
                      },
                      child: const Text("Calificar"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "No mires el reloj. Haz lo mismo que él: ve avanzando -- Sam Levenson",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Estadísticas"),
              ),
            ),
            const SizedBox(height: 10),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: buildOptionCard(
                            "assets/img/retoPersonal.jpg",
                            "Retos Personales",
                            "Entrando a Retos Personales",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: buildOptionCard(
                            "assets/img/ejercicioDia.jpg",
                            "Ejercicio del día",
                            "Entrando a Ejercicio del día",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: buildOptionCard(
                            "assets/img/comida.jpg",
                            "Plan Alimenticio",
                            "Entrando a Plan Alimenticio",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: buildOptionCard(
                            "assets/img/consejo.jpeg",
                            "Consejo del día",
                            "Entrando a Consejo del día",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rate),
            label: "Califica la App",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Lógica para emergencias (aquí vacío)
          } else if (index == 1) {
            // Navegación al perfil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 2) {
            // Navegación al chatbot
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          } else if (index == 3) {
            // Mostrar el diálogo de calificación
            showRatingDialog();
          }
        },
      ),
    );
  }

  Widget buildOptionCard(String imagePath, String title, String toastMessage) {
    return GestureDetector(
      onTap: () => showToast(toastMessage),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
