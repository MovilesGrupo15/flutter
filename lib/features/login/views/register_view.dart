import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAF50),
        centerTitle: true,
        title: Text("Registro"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Text(
                "Crea tu cuenta",
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontSize: 50,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Correo electrónico"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirmar contraseña"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (loginViewModel.isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    String email = emailController.text.trim();
                    String name = nameController.text.trim();
                    String password = passwordController.text.trim();
                    String confirmPassword = confirmPasswordController.text.trim();

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Las contraseñas no coinciden"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("El nombre no puede estar vacío"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Se asume que has modificado el método register en tu ViewModel
                    // para aceptar también el displayName
                    loginViewModel.register(context, email, password, name);
                  },
                  child: Text(
                    "Registrar",
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
