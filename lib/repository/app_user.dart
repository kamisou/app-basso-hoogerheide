import 'package:basso_hoogerheide/data_objects/input/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUserRepositoryProvider =
    Provider.autoDispose((ref) => const AppUserRepository());

final appUserProvider = FutureProvider.autoDispose(
  (ref) => ref.read(appUserRepositoryProvider).getMyUser(),
);

class AppUserRepository {
  const AppUserRepository();

  // TODO: buscar app user real
  Future<AppUser> getMyUser() => Future.delayed(
        const Duration(seconds: 3),
        () => const AppUser(
          division: 'Administrador',
          email: 'kamisou@outlook.com',
          name: 'João Marcos Kaminoski de Souza',
        ),
      );
}
