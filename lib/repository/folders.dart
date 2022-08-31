import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider =
    Provider.autoDispose((ref) => const FoldersRepository());

class FoldersRepository {
  const FoldersRepository();

  // TODO: buscar id de nova pasta real
  Future<int> getNewFolderId() =>
      Future.delayed(const Duration(seconds: 2), () => 1501);
}
