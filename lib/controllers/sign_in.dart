import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInControllerProvider = Provider.autoDispose(SignInController.new);

class SignInController {
  const SignInController(this.ref);

  final Ref ref;

  Future<void> signIn(Map<String, dynamic> body) async {
    final String response = await ref
        .read(restClientProvider)
        .post('/login', body: body)
        .then((value) => value['token']);
    ref.read(authTokenProvider.notifier).state = response;
    ref.invalidate(appUserProvider);
    return ref
        .read(secureStorageProvider)
        .write(SecureStorageKey.authToken, response);
  }

  Future<void> logout() => Future.wait([
        ref.read(restClientProvider).post('/logout'),
        ref.read(secureStorageProvider).delete(SecureStorageKey.authToken),
      ]).then((_) => ref.refresh(authTokenProvider));
}
