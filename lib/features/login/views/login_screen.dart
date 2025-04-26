import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/connectivity_provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final isOnline = context.watch<ConnectivityProvider>().isOnline; // 👈 Agregado
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // 🚨 Mensaje de sin conexión
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

              SizedBox(height: screenHeight * 0.08),

              Text(
                "¿Listo para Reciclar?",
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontSize: 50,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerView');
                    },
                    child: const Text(
                      "Regístrate",
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo electrónico"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
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
                    String password = passwordController.text.trim();
                    loginViewModel.login(context, email, password);
                  },
                  child: const Text(
                    "Iniciar Sesión",
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
