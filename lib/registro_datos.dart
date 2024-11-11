import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  // Variables para almacenar la selección
  String? _selectedGender;
  bool _isCustomGenderEnabled =
      false; // Indica si el usuario quiere crear un género
  TextEditingController _customGenderController = TextEditingController();

  // Controladores para teléfono
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _familyPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Registro"),
      ),
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
                    const TextField(
                      decoration: InputDecoration(labelText: "Nombres"),
                    ),
                    const TextField(
                      decoration: InputDecoration(labelText: "Primer apellido"),
                    ),
                    const TextField(
                      decoration:
                          InputDecoration(labelText: "Segundo apellido"),
                    ),
                    const SizedBox(height: 20),
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
                                _selectedGender = null; // Restablecer género
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
                                labelText: "Ingrese su género"),
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
                    const TextField(
                      decoration: InputDecoration(labelText: "Teléfono"),
                      keyboardType: TextInputType.phone,
                    ),
                    const TextField(
                      decoration:
                          InputDecoration(labelText: "Teléfono de un familiar"),
                      keyboardType: TextInputType.phone,
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

void main() {
  runApp(MaterialApp(
    home: Registro(),
  ));
}
