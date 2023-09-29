import 'package:flutter/material.dart';
import 'package:moviles/routes/routes.dart';
import 'dart:developer' as dev;
import 'package:moviles/Screens/variables.dart' as globals;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _email;
  late String _password;
  late String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu nombre de usuario.';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu correo electrónico.';
                  }
                  // Puedes agregar validación de formato de correo electrónico aquí.
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa una contraseña.';
                  } else {
                    _password = value!;
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, confirma tu contraseña.';
                  } else if (value! != _password) {
                    return 'Las contraseñas no coinciden.';
                  } else {
                    dev.log("Las contraseñas coinciden.");
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Si los campos son válidos, guarda los valores y realiza el registro.
                    _formKey.currentState!.save();
                    dev.log("Usuario '$_username' registrado correctamente");
                    setState(() {
                      globals.logged = true;
                      globals.user = _username;
                    });
                    Navigator.pushReplacementNamed(context, routes.HOME);
                    // Aquí puedes implementar la lógica para el registro.
                    // Puedes usar los valores de _username, _email y _password.

                    // Una vez completado el registro, puedes navegar a la siguiente pantalla o realizar otras acciones.

                    // Por ejemplo, puedes navegar a la pantalla de inicio después del registro.
                    //Navigator.pushReplacement(
                    //  context,
                    //  MaterialPageRoute(builder: (context) => HomeScreen()),
                    //);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Confirmar registro'),
              ),
              const SizedBox(
                  height:
                      16), // Espacio entre el botón y el texto "Ya tengo una cuenta"
              // Texto "Ya tengo una cuenta"
              GestureDetector(
                onTap: () {
                  // Navegar de nuevo a la pantalla de inicio de sesión
                  Navigator.pushReplacementNamed(context, routes.INICIARSESION);
                },
                child: const Text(
                  '¿Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(
                    color: Colors.blue, // Cambia el color del texto
                    decoration: TextDecoration.underline, // Agrega subrayado
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
