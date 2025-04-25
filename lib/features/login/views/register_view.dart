import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../../../connectivity_provider.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final isOnline = context.watch<ConnectivityProvider>().isOnline; // 👈 integración de estado de red

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        title: const Text("Registro"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // 🚨 Aviso de conexión
              if (!isOnline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Sin conexión a Internet',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito-Bold',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(height: screenHeight * 0.05),
              const Text(
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
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo electrónico"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: "Confirmar contraseña"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              if (loginViewModel.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    String email = emailController.text.trim();
                    String name = nameController.text.trim();
                    String password = passwordController.text.trim();
                    String confirmPassword = confirmPasswordController.text.trim();

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Las contraseñas no coinciden"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("El nombre no puede estar vacío"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    loginViewModel.register(context, email, password, name);
                  },
                  child: const Text(
                    "Registrar",
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                ),
              if (loginViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    loginViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
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
