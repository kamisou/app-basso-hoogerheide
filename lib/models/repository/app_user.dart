import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUserRepository = Provider.autoDispose(AppUserRepository.new);

final appUserProvider = FutureProvider.autoDispose(
  (ref) => ref.read(appUserRepository).getMyUser(),
);

class AppUserRepository {
  const AppUserRepository(this.ref);

  final Ref ref;

  Future<void> signIn(Map<String, dynamic> body) async {
    final String response = await ref
        .read(restClientProvider)
        .post('/profile/login', body: body)
        .then((value) => json.decode(value)['token']);
    return ref
        .read(secureStorageProvider)
        .write(SecureStorageKey.authToken.key, response);
  }

  Future<void> signOut() {
    log('signOut');
    return ref
        .read(secureStorageProvider)
        .delete(SecureStorageKey.authToken.key);
  }

  Future<void> recoverPassword() =>
      ref.read(restClientProvider).get('/profile/recover_password');

  Future<AppUser> getMyUser() => ref
      .read(restClientProvider)
      .get('/profile')
      .then((value) => AppUser.fromJson(json.decode(value)));

  // TODO: mudar imagem de perfil
  Future<FileUploadProgressStream?> changePicture() async {
    log('changePicture');
    final List<File>? result = await ref.read(filePickerProvider).pickFiles(
          dialogTitle: 'Selecione uma foto para o perfil:',
          withReadStream: true,
        );
    if (result == null) return null;

    return FileUploadProgressStream(
      ref.read(fileUploaderProvider).upload(result.first),
      fileName: result.first.path.split('/').last,
    );
  }

  Future<void> changePassword() =>
      ref.read(restClientProvider).get('/profile/change_password');
}
