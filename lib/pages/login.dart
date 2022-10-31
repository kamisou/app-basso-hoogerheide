import 'dart:io';

import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/repository/profile.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/text_form_field.dart';
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
        CustomTextFormField(
          controller: _passwordController,
          prefixIcon: Icons.lock_outline,
          hintText: 'Sua senha',
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
      ],
    );
  }

  Future<void> _signIn(BuildContext context) async {
    if (Form.of(context)!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      return ref.read(profileRepository).signIn({
        'email': _emailController.text,
        'password': _passwordController.text,
      }).then(
        (_) => Navigator.pushReplacementNamed(context, '/home').ignore(),
        onError: (e) => ErrorSnackbar(context: context, error: e)
          ..on<RestException>(
            content: (error) => ErrorContent(message: error.serverMessage),
          )
          ..on<SocketException>(
            content: (error) => const ErrorContent(
              message: 'Não foi possível estabelecer conexão com o servidor.',
              icon: Icons.wifi_off_outlined,
            ),
          ),
      );
    }
  }
}
