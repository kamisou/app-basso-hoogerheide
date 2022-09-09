import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:basso_hoogerheide/models/repository/app_user.dart';
import 'package:basso_hoogerheide/pages/profile/profile_option.dart';
import 'package:basso_hoogerheide/widgets/shimmering_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ModalRoute.of(context)!.settings.arguments as AppUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => _onTapProfilePic(ref),
              child: Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    height: 100,
                    width: 100,
                    child: ShimmeringImage(
                      url: appUser.avatarUrl,
                      errorBuilder: (context) => Text(
                        appUser.initials,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            spreadRadius: -4,
                            offset: Offset(-2, 2),
                          ),
                        ],
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            appUser.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            appUser.division,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ProfileOption(
            title: Text(
              'Mudar Senha',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Row(
              children: [
                Text(
                  '∗' * 12,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ],
            ),
            bodyBuilder: (_, close) => Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Builder(
                  builder: (context) =>
                      _changePasswordFormBuilder(context, ref, close),
                ),
              ),
            ),
            headerPadding: const EdgeInsets.only(
              top: 12,
              right: 12,
              bottom: 12,
              left: 20,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: () => () {
                Navigator.pushReplacementNamed(context, '/login');
                Future.delayed(
                  const Duration(milliseconds: 500),
                  ref.read(appUserRepository).signOut,
                );
              },
              child: Text(
                'Sair',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapProfilePic(WidgetRef ref) async {
    final List<File>? result = await ref.read(filePickerProvider).pickFiles(
          allowMultiple: false,
          dialogTitle: 'Selecione uma foto para o perfil:',
        );
    if (result == null) return;
    // TOOD: exibir snackbar
    return ref.read(appUserRepository).changePicture(result.first);
  }

  Widget _changePasswordFormBuilder(
    BuildContext context,
    WidgetRef ref,
    VoidCallback close,
  ) {
    final TextEditingController passwordController = TextEditingController();
    return StatefulBuilder(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Senha',
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Informe a nova senha' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Confirmar Senha',
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Repita a nova senha';
                } else if (passwordController.text != value) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // TODO: substituir por async button
            GestureDetector(
              onTap: () {
                if (Form.of(context)!.validate()) {
                  ref
                      .read(appUserRepository)
                      .changePassword(passwordController.text)
                      .then((_) => close());
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Salvar',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
