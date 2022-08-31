import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider =
    Provider.autoDispose((ref) => const ProfileController());

class ProfileController {
  const ProfileController();

  // TODO: mudar imagem de perfil
  Future<void> changePicture() async {}

  // TODO: mudar senha
  Future<void> changePassword() async {}
}
