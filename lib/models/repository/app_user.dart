import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUserRepository = Provider.autoDispose(
  (ref) => AppUserRepository(
    filePicker: ref.read(filePickerProvider),
    fileUploader: ref.read(fileUploaderProvider),
  ),
);

final appUserProvider = FutureProvider.autoDispose(
  (ref) => ref.read(appUserRepository).getMyUser(),
);

class AppUserRepository {
  const AppUserRepository({
    required this.filePicker,
    required this.fileUploader,
  });

  final FilePicker filePicker;

  final FileUploader fileUploader;

  // TODO: fazer sign in app
  Future<void> signIn() async => log('signIn');

  // TODO: sair do app
  Future<void> signOut() async => log('signOut');

  // TODO: recuperar senha
  Future<void> recoverPassword() async => log('recoverPassword');

  // TODO: buscar app user real
  Future<AppUser> getMyUser() {
    log('getMyUser');
    return Future.delayed(
      const Duration(seconds: 1),
      () => const AppUser(
        division: 'Administrador',
        email: 'kamisou@outlook.com',
        name: 'João Marcos Kaminoski de Souza',
      ),
    );
  }

  // TODO: mudar imagem de perfil
  Future<FileUploadProgressStream?> changePicture() async {
    log('changePicture');
    final List<File>? result = await filePicker.pickFiles(
      dialogTitle: 'Selecione uma foto para o perfil:',
      withReadStream: true,
    );
    if (result == null) return null;

    return FileUploadProgressStream(
      fileUploader.upload(result.first),
      fileName: result.first.path.split('/').last,
    );
  }

  // TODO: mudar senha
  Future<void> changePassword() async {}
}
