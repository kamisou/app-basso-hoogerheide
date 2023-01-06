import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/controllers/folders.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/folder_card/folder_card_body.dart';
import 'package:basso_hoogerheide/widgets/folder_card/folder_card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderCard extends ConsumerStatefulWidget {
  const FolderCard({
    super.key,
    required this.folder,
    this.onDeleteFolderFile,
  });

  final void Function(DownloadableFile)? onDeleteFolderFile;

  final Folder folder;

  @override
  ConsumerState<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends ConsumerState<FolderCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;

  late CurvedAnimation _curvedAnimation;

  TapDownDetails? _tapDetails;

  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          child: InkWell(
            onTap: _onTapFolder,
            onTapDown: (details) => _tapDetails = details,
            onLongPress: _onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FolderCardHeader(folder: widget.folder),
                ),
                SizeTransition(
                  sizeFactor: _curvedAnimation,
                  child: FolderCardBody(folder: widget.folder),
                ),
              ],
            ),
          ),
        ),
        if (widget.folder.writtenOff)
          FadeTransition(
            opacity: _curvedAnimation,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: Theme.of(context)
                    .extension<SuccessThemeExtension>()
                    ?.success,
              ),
              margin: const EdgeInsets.only(top: 8, right: 8),
              height: 6,
              width: 6,
            ),
          ),
      ],
    );
  }

  void _onTapFolder() async {
    if (_animationController.isAnimating) return;
    if (_expanded) {
      await _animationController.reverse();
    } else {
      await _animationController.forward();
    }
    setState(() => _expanded = !_expanded);
  }

  void _onLongPress() async {
    if (_tapDetails == null) return;
    final double dx = _tapDetails!.globalPosition.dx;
    final double dy = _tapDetails!.globalPosition.dy;
    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Editar pasta')),
        PopupMenuItem(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
          value: 'delete',
          child: const Text('Deletar pasta'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        Navigator.pushNamed(context, '/newFolder', arguments: widget.folder.id);
      } else if (value == 'delete') {
        ref
            .read(foldersControllerProvider)
            .deleteFolder(widget.folder)
            .catchError(
              (e) => ErrorSnackbar(
                context: context,
                error: e,
              ).on<RestException>(
                content: (error) => ErrorContent(message: error.serverMessage),
              ),
            );
      }
    });
  }
  
  @override
  bool get wantKeepAlive => _expanded;
}
