import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/repository/app_user.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final AsyncButtonController _controller = AsyncButtonController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

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
            controller: _emailController,
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
          controller: _passwordController,
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
        ElevatedAsyncButton(
          controller: _controller,
          onPressed: () => _signIn(context),
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

  Future<void> _signIn(BuildContext context) async {
    if (Form.of(context)!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      return ref.read(appUserRepository).signIn({
        'email': _emailController.text,
        'password': _passwordController.text,
      }).then(
        (_) => Navigator.pushReplacementNamed(context, '/home'),
        onError: (e) => ErrorSnackbar<RestException>(
          content: (context, error) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                error.serverMessage ?? 'Ocorreu um erro inesperado',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Icon(
                Icons.wifi_off,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ).show(context, e),
      );
    }
  }
}
