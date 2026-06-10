import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:vault/ui/core/widgets/confirm_button.dart';
import 'package:vault/ui/features/albums/viemodel/add_album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/album_viewmodel.dart';
import 'package:vault/ui/features/albums/viemodel/albums_viewmodel.dart';

class AddAlbumDialog extends StatefulWidget {
  const AddAlbumDialog({super.key});

  @override
  State<StatefulWidget> createState() => AddAlbumDialogState();
}

class AddAlbumDialogState extends State<AddAlbumDialog> {
  final TextEditingController _albumNameController = TextEditingController();
  ServerConnection? _selectedConnection;

  @override
  void initState() {
    super.initState();

    context.read<AddAlbumViewModel>().getServerConnections();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = AppLocalizations.of(context);
    final AddAlbumViewModel vm = context.read<AddAlbumViewModel>();
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return switch (vm.isLoading) {
          true => Center(child: const CircularProgressIndicator()),
          false => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo_album),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _albumNameController,
                    onChanged: (value) {
                      setState(() {
                        vm.newAlbumName = value;
                      });
                    },
                    decoration: InputDecoration(
                      label: Text(localizations!.albumNameLabel),
                      prefixIcon: Icon(Icons.abc),
                    ),
                  ),

                  DropdownButton(
                    value: _selectedConnection,
                    items: vm.serverConnections
                        .map(
                          (conn) => DropdownMenuItem(
                            value: conn,
                            child: Text(conn.serverUrl),
                          ),
                        )
                        .toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        vm.newAlbumConnection = value;
                        _selectedConnection = value;
                      });
                    },
                    icon: Icon(Icons.dns),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  Selector<AddAlbumViewModel, bool>(
                    selector: (_, vm) => vm.isAddAlbumFormValid,
                    builder: (_, isValid, _) {
                      return ConfirmButton(
                        text: localizations.addAlbumAction,
                        onTap: isValid
                            ? () {
                                var res = vm.addAlbum();

                                if (context.mounted)
                                  Navigator.of(context).pop();
                              }
                            : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        };
      },
    );
  }
}
