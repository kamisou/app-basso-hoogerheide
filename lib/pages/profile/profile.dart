import 'package:basso_hoogerheide/controllers/profile.dart';
import 'package:basso_hoogerheide/controllers/sign_in.dart';
import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/pages/profile/profile_option.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:basso_hoogerheide/widgets/shimmering_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  TapDownDetails? _tapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        children: [
          ref.watch(appUserProvider).when(
                data: (data) => Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => _onTapProfilePic(context, ref),
                        onTapDown: (details) => _tapDetails = details,
                        onLongPress: _onLongPressProfilePic,
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
                                url: data.avatarUrl,
                                height: 100,
                                width: 100,
                                errorBuilder: (context) => Text(
                                  data.initials,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
                      data.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      data.division,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
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
              onTap: () {
                ref.read(signInControllerProvider).logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
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
          ),
        ],
      ),
    );
  }

  Future<void> _onTapProfilePic(BuildContext context, WidgetRef ref) async {
    ref
        .read(filePickerProvider)
        .pickFiles(
          allowMultiple: false,
          dialogTitle: 'Selecione uma foto para o perfil:',
        )
        .then((value) {
      if (value == null) return;
      LoadingSnackbar(
        contentBuilder: (context) => Text(
          'Fazendo upload da foto de perfil...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        errorBuilder: (context, error) {
          String? errorMessage =
              error is RestException ? error.serverMessage : null;
          return Row(
            children: [
              Expanded(
                child: Text(
                  errorMessage ??
                      'Ocorreu um erro inesperado ao fazer upload da imagem.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          );
        },
      ).show(
        context,
        ref.read(profileControllerProvider).changeAvatar(value.first),
      );
    });
  }

  Future<void> _onLongPressProfilePic() async {
    if (ref.read(appUserProvider).value?.avatarUrl == null ||
        _tapDetails == null) {
      return;
    }

    final double dx = _tapDetails!.globalPosition.dx;
    final double dy = _tapDetails!.globalPosition.dy;

    final String? result = await showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      items: [
        PopupMenuItem(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
          value: 'delete',
          child: const Text('Deletar foto'),
        ),
      ],
    );

    if (result == 'delete') {
      return ref.read(profileControllerProvider).deleteAvatar();
    }
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
              keyboardType: TextInputType.visiblePassword,
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
              keyboardType: TextInputType.visiblePassword,
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
            TextAsyncButton(
              onPressed: () async {
                if (Form.of(context).validate()) {
                  return ref
                      .read(profileControllerProvider)
                      .changePassword(passwordController.text)
                      .then(
                        (_) => close(),
                        onError: (e) =>
                            ErrorSnackbar(context: context, error: e)
                              ..on<RestException>(
                                content: (error) =>
                                    ErrorContent(message: error.serverMessage),
                              ),
                      );
                }
              },
              loadingChild: const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('Salvar'),
              ),
            ),
          ],
        );
      },
    );
  }
}
