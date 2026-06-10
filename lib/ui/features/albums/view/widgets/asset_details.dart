import 'package:flutter/material.dart';
import 'package:vault/domain/asset/details.dart';
import 'package:vault/l10n/vault_localizations.dart';
import 'package:proper_filesize/proper_filesize.dart';

class AssetDetails extends StatelessWidget {
  final Details details;
  final double minHeight;

  const AssetDetails({
    super.key,
    required this.details,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.onSurface,
    );
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final metricFileSize;
    if (details.fileSizeInByte != null) {
      metricFileSize = FileSize.fromBytes(details.fileSizeInByte!).toString(
        unit: Unit.auto(
          size: details.fileSizeInByte!,
          baseType: BaseType.metric,
        ),
      );
    } else {
      metricFileSize = "-";
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: minHeight,
        minWidth: double.infinity,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ColoredBox(
          color: theme.colorScheme.surfaceContainerHigh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                  width: 40,
                  child: Divider(
                    thickness: 5,
                    radius: BorderRadius.circular(5),
                  ),
                ),
              ),

              // date header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getWeekday(localizations), style: titleStyle),
                        Text(
                          details.dateTimeOriginal?.toString() ?? "-",
                          style: labelStyle,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.camera,
                      size: 50,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    // camera card
                    Card.filled(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 200,
                          minWidth: double.infinity,
                        ),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations?.cameraLabel ?? "Camera",
                              style: labelStyle,
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SelectableText(
                                details.cameraModel ?? "-",
                                style: titleStyle,
                                selectionColor:
                                    theme.colorScheme.inversePrimary,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              localizations?.lensLabel ?? "Lens",
                              style: labelStyle,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SelectableText(
                                details.lensModel ?? "-",
                                style: titleStyle,
                                selectionColor:
                                    theme.colorScheme.inversePrimary,
                              ),
                            ),

                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildCameraStatWithIcon(
                                    theme,
                                    Icons.shutter_speed,
                                    details.exposureTime?.toString(),
                                  ),
                                  _buildCameraStatWithIcon(
                                    theme,
                                    Icons.money,
                                    details.iso?.toString(),
                                  ),
                                  _buildCameraStatWithIcon(
                                    theme,
                                    Icons.camera,
                                    details.fStop?.toString(),
                                  ),

                                  _buildCameraStatWithIcon(
                                    theme,
                                    Icons.center_focus_strong,
                                    details.focalLength?.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // server and size card
                    Card.filled(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 150,
                          minWidth: double.infinity,
                        ),

                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations?.serverLabel ?? "Server",
                              style: labelStyle,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SelectableText(
                                details.server.toString(),
                                style: titleStyle,
                                selectionColor:
                                    theme.colorScheme.inversePrimary,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              localizations?.resolutionLabel ?? "Resolution",
                              style: labelStyle,
                            ),
                            Text(
                              details.hasDimensions()
                                  ? "${details.width}x${details.height}"
                                  : "-",
                              style: titleStyle,
                            ),

                            SizedBox(height: 10),

                            Text(
                              localizations?.sizeLabel ?? "Size",
                              style: labelStyle,
                            ),
                            Text(metricFileSize, style: titleStyle),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekday(AppLocalizations? localizations) {
    final weekDay = details.dateTimeOriginal?.weekday;
    switch (weekDay) {
      case 1:
        return localizations?.weekday_1 ?? "Monday";
      case 2:
        return localizations?.weekday_2 ?? "Tuesday";
      case 3:
        return localizations?.weekday_3 ?? "Wednesday";
      case 4:
        return localizations?.weekday_4 ?? "Thursday";
      case 5:
        return localizations?.weekday_5 ?? "Friday";
      case 6:
        return localizations?.weekday_6 ?? "Saturday";
      case 7:
        return localizations?.weekday_7 ?? "Sunday";
      default:
        return "Unknown";
    }
  }

  Widget _buildCameraStatWithIcon(
    ThemeData theme,
    IconData icon,
    String? value,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        Padding(padding: const EdgeInsets.all(2.0), child: Text(value ?? "-")),
      ],
    );
  }
}
