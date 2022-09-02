import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationRepositoryProvider =
    Provider.autoDispose((ref) => const AuthenticationRepository());

final appUserProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authenticationRepositoryProvider).getMyUser());

class AuthenticationRepository {
  const AuthenticationRepository();

  // TODO: entrar no app
  Future<void> signIn() async {}

  // TODO: sair do app
  Future<void> signOut() async {}

  // TODO: recuperar senha
  Future<void> recoverPassword() async {}

  // TODO: buscar app user real
  Future<AppUser> getMyUser() => Future.delayed(
        const Duration(seconds: 3),
        () => const AppUser(
          division: 'Administrador',
          email: 'kamisou@outlook.com',
          name: 'João Marcos Kaminoski de Souza',
        ),
      );

  // TODO: mudar imagem de perfil
  Future<void> changePicture() async {}

  // TODO: mudar senha
  Future<void> changePassword() async {}
}
