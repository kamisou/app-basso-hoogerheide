import 'package:basso_hoogerheide/pages/profile/profile_option.dart';
import 'package:basso_hoogerheide/widgets/shimmering_image.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 48,
        ),
        children: [
          Center(
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
                    url: 'https://picsum.photos/800',
                    errorBuilder: (context) => Text(
                      'JM',
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
          const SizedBox(height: 32),
          Text(
            'Flávia Mendes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Civil e Trabalhista',
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
            bodyBuilder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Senha',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Confirmar Senha',
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    // TODO: mudar senha
                    onTap: () {},
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
              // TODO: sair do aplicativo
              onTap: () {},
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
}
