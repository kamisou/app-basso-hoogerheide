import 'dart:io';

import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = Provider.autoDispose(ProfileController.new);

class ProfileController {
  const ProfileController(this.ref);

  final Ref ref;

  Future<void> deleteAvatar() => ref
      .read(restClientProvider)
      .delete('/profile/delete_avatar')
      .then((_) => ref.refresh(appUserProvider));

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