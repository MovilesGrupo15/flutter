import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../../../core/services/connectivity_provider.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterView({super.key});

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        title: const Text("Registro"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            if (!isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sin conexión a Internet',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            const Text(
              "Crea tu cuenta",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            _buildTextField(nameController, "Nombre", Icons.person),
            const SizedBox(height: 16),

            _buildTextField(emailController, "Correo electrónico", Icons.email),
            const SizedBox(height: 16),

            _buildTextField(passwordController, "Contraseña", Icons.lock, isPassword: true),
            const SizedBox(height: 16),

            _buildTextField(confirmPasswordController, "Confirmar contraseña", Icons.lock_outline, isPassword: true),
            const SizedBox(height: 24),

            loginViewModel.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        String email = emailController.text.trim();
                        String name = nameController.text.trim();
                        String password = passwordController.text.trim();
                        String confirmPassword = confirmPasswordController.text.trim();

                        if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                          _showError(context, "Todos los campos son obligatorios.");
                          return;
                        }

                        if (!_isValidEmail(email)) {
                          _showError(context, "Correo electrónico inválido.");
                          return;
                        }

                        if (password != confirmPassword) {
                          _showError(context, "Las contraseñas no coinciden.");
                          return;
                        }

                        loginViewModel.register(context, email, password, name);
                      },
                      child: const Text("Registrar", style: TextStyle(fontSize: 16)),
                    ),
                  ),

            if (loginViewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  loginViewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
