import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginControllerProvider =
    Provider.autoDispose((ref) => const LoginController());

class LoginController {
  const LoginController();

  // TODO: entrar no app (jogar exceção no erro)
  Future<void> signIn() async {}

  // TODO: sair do app
  Future<void> signOut() async {}

  // TODO: recuperar senha
  Future<void> recoverPassword() async {}
}
