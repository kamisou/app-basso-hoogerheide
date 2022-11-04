import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepository = Provider.autoDispose(ProfileRepository.new);

final appUserProvider = FutureProvider(
  (ref) => ref.read(profileRepository).getMyUser(),
);

class ProfileRepository {
  const ProfileRepository(this.ref);

  final Ref ref;

  Future<AppUser> getMyUser() => ref
      .read(restClientProvider)
      .get('/profile')
      .then((value) => AppUser.fromJson(value));
}
