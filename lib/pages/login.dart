import 'package:basso_hoogerheide/models/repository/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: Form(
                    child: Builder(
                      builder: (context) => Column(
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
                            onEditingComplete: () =>
                                _signInAndNavigate(context, ref),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _signInAndNavigate(context, ref),
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: GestureDetector(
                              onTap: ref
                                  .read(authenticationRepositoryProvider)
                                  .recoverPassword,
                              child: Text(
                                'Esqueceu sua senha?',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInAndNavigate(BuildContext context, WidgetRef ref) => ref
      .read(authenticationRepositoryProvider)
      .signIn()
      .then((_) => Navigator.pushReplacementNamed(context, '/home'));
}
