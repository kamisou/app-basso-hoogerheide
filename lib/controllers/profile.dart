import 'package:basso_hoogerheide/interfaces/rest_api.dart';
import 'package:basso_hoogerheide/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = ChangeNotifierProvider(
  (ref) => ProfileController(ref),
);

class ProfileController extends ChangeNotifier {
  ProfileController(this.ref);

  final Ref ref;

  AsyncValue<ModelUser?> user = const AsyncValue.data(null);

  Future<void> getUser() async {
    try {
      user = const AsyncValue.loading();
      final data = await ref.read(restProvider).get('/user');
      user = AsyncValue.data(ModelUser.fromJson(data));
    } on Exception {
      user = const AsyncValue.error(
        'Não foi possível buscar dados do usuário',
      );
    }
  }
}
