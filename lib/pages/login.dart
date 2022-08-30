import 'package:basso_hoogerheide/controllers/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final LoginController _controller = const LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
                  child: Form(child: _formBuilder(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Insira suas credenciais:',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Seu e-mail',
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 18),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: 'Sua senha',
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onEditingComplete: () => _signInAndNavigate(context),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _signInAndNavigate(context),
          child: const Text('Login'),
        ),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: _controller.recoverPassword,
            child: Text(
              'Esqueceu sua senha?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }

  void _signInAndNavigate(BuildContext context) => _controller
      .signIn()
      .then((_) => Navigator.pushReplacementNamed(context, '/home'));
}
