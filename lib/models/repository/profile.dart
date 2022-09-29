import 'dart:io';

import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepository = Provider.autoDispose(ProfileRepository.new);

final appUserProvider = FutureProvider(
  (ref) => ref.read(profileRepository).getMyUser(),
);

class ProfileRepository {
  const ProfileRepository(this.ref);

  final Ref ref;

  Future<void> signIn(Map<String, dynamic> body) async {
    final String response = await ref
        .read(restClientProvider)
        .post('/login', body: body)
        .then((value) => value['token']);
    ref.read(authTokenProvider.notifier).state = response;
    ref.refresh(appUserProvider);
    return ref
        .read(secureStorageProvider)
        .write(SecureStorageKey.authToken.key, response);
  }

  Future<void> logout() {
    return Future.wait([
      ref.read(restClientProvider).post('/logout'),
      ref.read(secureStorageProvider).delete(SecureStorageKey.authToken.key),
    ]).then((_) => ref.refresh(authTokenProvider));
  }

  // Future<void> recoverPassword(Map<String, dynamic> body) =>
  //     ref.read(restClientProvider).put('/profile/recover_password', body: body);

  Future<AppUser> getMyUser() => ref
      .read(restClientProvider)
      .get('/profile')
      .then((value) => AppUser.fromJson(value));

  Future<void> changeAvatar(File file) => ref
      .read(restClientProvider)
      .uploadImage('POST', '/profile/change_avatar',
          field: 'new_avatar', file: file)
      .then((_) => ref.refresh(appUserProvider));

  Future<void> changePassword(String password) =>
      ref.read(restClientProvider).post(
        '/profile/change_password',
        body: {'new_password': password},
      );
}
