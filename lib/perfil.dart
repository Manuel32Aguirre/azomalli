import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azomalli/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Cargando...";
  String userPassword = "*********";
  String userPhone = "Cargando...";

  // Estados para los ajustes
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Cargar los ajustes guardados
    _loadUserData(); // Cargar datos del usuario desde Firestore
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      vibrationEnabled = prefs.getBool('vibrationEnabled') ?? false;
    });
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['nombre'] ?? "Sin nombre";
            userPhone = userDoc['telefono'] ?? "Sin teléfono";
          });
        } else {
          showToast("Datos del usuario no encontrados en Firestore.");
        }
      } else {
        showToast("Usuario no autenticado.");
      }
    } catch (e) {
      showToast("Error al cargar datos: $e");
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> newData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .update(newData);

        showToast("Datos actualizados correctamente.");
      } else {
        showToast("Usuario no autenticado.");
      }
    } catch (e) {
      showToast("Error al actualizar los datos: $e");
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setBool('soundEnabled', soundEnabled);
    await prefs.setBool('vibrationEnabled', vibrationEnabled);
  }

  void showEditDialog({
    required String title,
    required String currentValue,
    required Function(String) onSave,
  }) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Ingresa tu nuevo $title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/img/azomalli.png"),
                  radius: 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Mis Datos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1),
              _buildUserInfoTile(
                icon: Icons.person,
                title: "Usuario",
                subtitle: userName,
                onEdit: () => showEditDialog(
                  title: "Usuario",
                  currentValue: userName,
                  onSave: (newValue) {
                    setState(() {
                      userName = newValue;
                    });
                    _updateUserData({'nombre': newValue});
                  },
                ),
              ),
              _buildUserInfoTile(
                icon: Icons.lock,
                title: "Contraseña",
                subtitle: userPassword,
                onEdit: () => showEditDialog(
                  title: "Contraseña",
                  currentValue: '',
                  onSave: (newValue) async {
                    try {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await user.updatePassword(newValue);
                        setState(() {
                          userPassword = newValue;
                        });
                        showToast("Contraseña actualizada correctamente.");
                      } else {
                        showToast("Usuario no autenticado.");
                      }
                    } catch (e) {
                      showToast("Error al actualizar la contraseña: $e");
                    }
                  },
                ),
              ),
              _buildUserInfoTile(
                icon: Icons.phone,
                title: "Teléfono",
                subtitle: userPhone,
                onEdit: () => showEditDialog(
                  title: "Teléfono",
                  currentValue: userPhone,
                  onSave: (newValue) {
                    setState(() {
                      userPhone = newValue;
                    });
                    _updateUserData({'telefono': newValue});
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Ajustes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1),
              _buildSwitchTile(
                title: "Notificaciones",
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                    _savePreferences();
                  });
                },
              ),
              _buildSwitchTile(
                title: "Sonido",
                value: soundEnabled,
                onChanged: (value) {
                  setState(() {
                    soundEnabled = value;
                    _savePreferences();
                  });
                },
              ),
              _buildSwitchTile(
                title: "Vibración",
                value: vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    vibrationEnabled = value;
                    _savePreferences();
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Inicio()),
                  );
                  showToast("Sesión cerrada.");
                },
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
