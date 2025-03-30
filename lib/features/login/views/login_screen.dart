import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1), // Espaciado dinámico
              Text(
                "Listo para Reciclar?",
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontSize: 50,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Correo electrónico"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (loginViewModel.isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50), // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                  ),
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    loginViewModel.login(context, email, password); // Pasa el contexto
                  },
                  child: Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                ),

              if (loginViewModel.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    loginViewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}