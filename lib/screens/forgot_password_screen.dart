import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olvidaste la contraseña'),
      ),
      body: Center(
        child: Text('Pantalla de "Olvidaste la contraseña"'),
      ),
    );
  }
}
