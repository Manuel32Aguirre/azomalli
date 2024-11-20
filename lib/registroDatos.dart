import 'package:azomalli/menuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroDatos extends StatefulWidget {
  const RegistroDatos({super.key});

  @override
  _RegistroDatosState createState() => _RegistroDatosState();
}

class _RegistroDatosState extends State<RegistroDatos> {
  // Variables para almacenar datos
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _familyPhoneController = TextEditingController();
  final TextEditingController _customGenderController = TextEditingController();
  String? _selectedGender;
  bool _isCustomGenderEnabled = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Variable para el nivel de estrés
  int _stressLevel = 1; // Valor inicial del nivel de estrés

  // Función para enviar datos a Firebase
  Future<void> _saveData() async {
    final String nombres = _nameController.text.trim();
    final String apellido = _lastNameController.text.trim();
    final String telefono = _phoneController.text.trim();
    final String telefonoFamiliar = _familyPhoneController.text.trim();
    final String genero = _isCustomGenderEnabled
        ? _customGenderController.text.trim()
        : _selectedGender ?? "No especificado";
    final String nombreUsuario = _userNameController.text.trim();
    final int edad = int.tryParse(_ageController.text.trim()) ?? 0;
    final double estatura =
        double.tryParse(_heightController.text.trim()) ?? 0.0;

    try {
      // Obtener el documento del usuario actual
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Usamos el ID del usuario para actualizar los datos
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid) // Referencia al documento por el UID del usuario
            .set({
          'nombre': nombres.isEmpty ? '' : nombres,
          'apellido': apellido.isEmpty ? '' : apellido,
          'genero': genero.isEmpty ? '' : genero,
          'telefono': telefono.isEmpty ? '' : telefono,
          'telefonoFamiliar': telefonoFamiliar.isEmpty ? '' : telefonoFamiliar,
          'edad': edad,
          'estatura': estatura,
          'nombreUsuario': nombreUsuario.isEmpty ? '' : nombreUsuario,
          'fechaRegistro': DateTime.now(), // Fecha de registro
          'nivelEstres': _stressLevel, // Guardar el nivel de estrés
        });

        // Mostrar un mensaje de éxito
        Fluttertoast.showToast(
          msg: "Datos guardados correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Redirigir a otra pantalla
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SegundaPantalla(
                    userName: "auxiliar",
                  )),
        );
      }
    } catch (e) {
      // Mostrar mensaje de error en caso de fallo
      Fluttertoast.showToast(
        msg: "Error al guardar los datos: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "AZOMALLI",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombres completos en dos columnas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration:
                                const InputDecoration(labelText: "Nombre"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _lastNameController,
                            decoration:
                                const InputDecoration(labelText: "Apellido"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Género
                    const Text("Seleccione su género"),
                    Row(
                      children: [
                        Checkbox(
                          value: _isCustomGenderEnabled,
                          onChanged: (bool? value) {
                            setState(() {
                              _isCustomGenderEnabled = value ?? false;
                              if (!_isCustomGenderEnabled) {
                                _customGenderController.clear();
                                _selectedGender = null;
                              }
                            });
                          },
                        ),
                        const Text("Crear género personalizado"),
                      ],
                    ),
                    _isCustomGenderEnabled
                        ? TextField(
                            controller: _customGenderController,
                            decoration: const InputDecoration(
                              labelText: "Ingrese su género",
                            ),
                          )
                        : DropdownButton<String>(
                            hint: const Text("Género"),
                            value: _selectedGender,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                            items: ['Hombre', 'Mujer', 'Otro']
                                .map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 20),

                    // Teléfonos en dos columnas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            decoration:
                                const InputDecoration(labelText: "Teléfono"),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _familyPhoneController,
                            decoration: const InputDecoration(
                                labelText: "Teléfono de un familiar"),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Edad y Estatura en dos columnas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ageController,
                            decoration:
                                const InputDecoration(labelText: "Edad"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                                labelText: "Estatura (m)"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Nombre de usuario
                    TextField(
                      controller: _userNameController,
                      decoration:
                          const InputDecoration(labelText: "Nombre de usuario"),
                    ),
                    const SizedBox(height: 20),

                    // Nivel de estrés con barra deslizante
                    const Text(
                        "¿Cuál es tu nivel de estrés? (1 = Bajo, 10 = Alto)"),
                    Slider(
                      value: _stressLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _stressLevel.toString(),
                      onChanged: (double value) {
                        setState(() {
                          _stressLevel = value.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Botón de guardar
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text("Guardar datos"),
                      ),
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
