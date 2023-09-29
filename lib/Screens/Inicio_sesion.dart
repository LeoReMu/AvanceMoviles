import 'package:flutter/material.dart';
import 'package:moviles/routes/routes.dart';
import 'package:moviles/Screens/variables.dart' as globals;

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSessionChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 60.0), // Agrega el Padding a los lados
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isSessionChecked,
                    onChanged: (value) {
                      setState(() {
                        _isSessionChecked = value!;
                      });
                    },
                  ),
                  const Text('Mantener sesión iniciada'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar sesión
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  setState(() {
                    globals.logged = true;
                    globals.user = username;
                  });
                  Navigator.pushReplacementNamed(context, routes.HOME);
                  // Aquí puedes realizar la autenticación con el nombre de usuario y la contraseña
                  // y manejar el estado de "mantener sesión iniciada" (_isSessionChecked).
                },
                child: const Text('Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, routes.REGISTRARSE);
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
