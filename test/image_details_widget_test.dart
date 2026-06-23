import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:vault/domain/asset/asset.dart';
import 'package:vault/domain/asset/details.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/ui/features/albums/view/widgets/asset_details.dart';
import 'package:vault/ui/features/albums/view/widgets/photo_view.dart';
import 'package:vault/ui/features/albums/view/widgets/single_asset_page_viewer.dart';

abstract class MockData {
  static const kAssetImage = 'lib/assetImages/testingImage_5184x3888.jpg';
  static const kAssetImage2 = 'lib/assetImages/thumbnail-placeholder.jpg';
  static const kImageHeight = 980;
  static const kImageWidth = 1093;
  static Details kDummyDetails = Details(
    dateTimeOriginal: DateTime.parse('2026-06-23T18:00:00Z'),
    timeZone: 'GMT+2',
    city: 'Warsaw',
    country: 'Poland',
    fileSizeInByte: 4096,
    height: 3888,
    width: 5184,
    cameraModel: 'Sony A7IV',
    lensModel: '24-70mm f/2.8',
    iso: 100,
    exposureTime: '1/125',
    focalLength: 50.0,
    fStop: 2.8,
    server: 'test-server',
  );
}

class MockAsset extends Asset {
  MockAsset.mock()
    : super(
        id: "",
        serverConnection: ServerConnection(serverUrl: "", apiKey: ""),
        mimeType: "",
        isVideo: false,
        details: MockData.kDummyDetails,
        width: MockData.kImageWidth,
        height: MockData.kImageHeight,
      );

  @override
  Image buildImage({
    Key? key,
    bool original = false,
    double? width,
    double? height,
    bool skipThumbhash = true,
  }) {
    return Image(
      key: key,
      image: AssetImage(MockData.kAssetImage2),
      width: width,
      height: height,
    );
  }
}

Future<void> pumpViewer(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = Size(800, 600);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SingleAssetPageViewer(asset: MockAsset.mock())),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> swipeUp(WidgetTester tester) async {
  await tester.drag(find.byType(PhotoView), const Offset(0, -500));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("Details panel is hidden before swipe", (tester) async {
    await pumpViewer(tester);

    final animatedOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const Key("DetailsAnimatedOpacity")),
    );
    final ignorePointer = tester.widget<IgnorePointer>(
      find.byKey(const Key("DetailsIgnorePointer")),
    );

    expect(animatedOpacity.opacity, 0);
    expect(ignorePointer.ignoring, true);
  });

  testWidgets("Details panel is visible after swipe up", (tester) async {
    await pumpViewer(tester);
    await swipeUp(tester);

    final animatedOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const Key("DetailsAnimatedOpacity")),
    );
    final ignorePointer = tester.widget<IgnorePointer>(
      find.byKey(const Key("DetailsIgnorePointer")),
    );
    final photoView = tester.widget<PhotoView>(find.byType(PhotoView));

    expect(animatedOpacity.opacity, 1);
    expect(ignorePointer.ignoring, false);
    expect(photoView.disableZoomGestures, true);
  });

  testWidgets("Details panel displays correct asset metadata", (tester) async {
    await pumpViewer(tester);
    await swipeUp(tester);

    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('2026-06-23 18:00:00.000Z'), findsOneWidget);

    expect(find.text('Sony A7IV'), findsOneWidget);
    expect(find.text('24-70mm f/2.8'), findsOneWidget);

    expect(find.text('1/125'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('2.8'), findsOneWidget);
    expect(find.text('50.0'), findsOneWidget);

    expect(find.text('test-server'), findsOneWidget);
    expect(find.text('5184x3888'), findsOneWidget);
    expect(find.text('4.096 KB'), findsOneWidget);

    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Lens'), findsOneWidget);
    expect(find.text('Server'), findsOneWidget);
    expect(find.text('Resolution'), findsOneWidget);
    expect(find.text('Size'), findsOneWidget);
  });
}
