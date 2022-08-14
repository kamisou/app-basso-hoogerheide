import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.pageTitles,
  });

  final List<String> pageTitles;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              type: MaterialType.circle,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Center(
                  child: Text(
                    'JM',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0x00FFFFFF),
                ],
                end: Alignment(.65, 0),
              ).createShader(bounds),
              child: ListView.builder(
                itemCount: pageTitles.length,
                itemExtent: 100,
                physics: const NeverScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pageTitles[index],
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            // TODO: leave app
            onTap: () {},
            child: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
