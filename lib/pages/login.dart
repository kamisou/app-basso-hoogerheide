import 'package:basso_hoogerheide/models/repository/app_user.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final AsyncButtonController _controller = AsyncButtonController();

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
                  child: Form(
                    child: Builder(
                      builder: (context) => _formBuilder(context, ref),
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

  Widget _formBuilder(BuildContext context, WidgetRef ref) {
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
            validator: (value) => (value?.isEmpty ?? true)
                ? 'Informe seu endereço de e-mail'
                : null),
        const SizedBox(height: 18),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: 'Sua senha',
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onEditingComplete: _controller.press,
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'Informe sua senha' : null,
        ),
        const SizedBox(height: 20),
        AsyncButton(
          controller: _controller,
          onPressed: () async {
            if (Form.of(context)!.validate()) {
              return ref.read(appUserRepository).signIn().then(
                    (_) => Navigator.pushReplacementNamed(context, '/home'),
                  );
            }
          },
          loadingChild: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: ref.read(appUserRepository).recoverPassword,
            child: Text(
              'Esqueceu sua senha?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }
}
