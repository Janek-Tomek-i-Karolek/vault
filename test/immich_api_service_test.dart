import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:vault/data/model/album/album_response_dto.dart';
import 'package:vault/domain/server/server_connection.dart';
import 'package:vault/utils/result.dart';
import 'package:vault/data/services/api/demo_api_client.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

class FakeBaseRequest extends Fake implements http.BaseRequest {}

class FakeServerConnection extends Fake implements ServerConnection {
  @override
  String get serverUrl => 'https://test-vault.com';

  @override
  String get apiKey => 'pdw123';

  @override
  Map<String, String> get jsonHeaders => {
    "Content-Type": "application/json",
    "x-api-key": apiKey,
  };
}

void main() {
  late DemoApiClient apiClient;
  late MockClient mockClient;
  late FakeServerConnection mockServerConnection;

  setUpAll(() {
    registerFallbackValue(FakeUri());
    registerFallbackValue(FakeBaseRequest());
  });

  setUp(() {
    apiClient = DemoApiClient();
    mockClient = MockClient();
    mockServerConnection = FakeServerConnection();
  });

  group('DemoApiClient - Albums', () {
    test('addAlbum returns Result.ok on 201 status', () async {
      final mockResponse = {
        'id': '1',
        'albumName': 'Vacation',
        'albumThumbnailAssetId': null,
        'albumUsers': [],
        'assets': [],
        'description': 'A test album',
        'owner': {
          'id': 'user_1',
          'email': 'test@vault.com',
          'name': 'Test User',
          'profileImagePath': '',
        },
        'ownerId': 'user_1',
        'shared': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 201));

      final result = await http.runWithClient(
        () => apiClient.addAlbum(mockServerConnection, 'Vacation'),
        () => mockClient,
      );

      expect(result, isA<Ok<AlbumResponseDTO>>());

      verify(
        () => mockClient.post(
          Uri.parse('https://test-vault.com/api/albums'),
          headers: mockServerConnection.jsonHeaders,
          body: jsonEncode({'albumName': 'Vacation'}),
        ),
      ).called(1);
    });

    test('addAlbum returns Result.error on non-201 status', () async {
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      final result = await http.runWithClient(
        () => apiClient.addAlbum(mockServerConnection, 'Vacation'),
        () => mockClient,
      );

      expect(result, isA<Error>());

      final errorResult = result as Error;
      expect(errorResult.error.toString(), contains('Failed to add album'));
    });

    test('getAlbums returns list of AlbumResponseDTO on 200 status', () async {
      final mockResponse = [
        {
          'id': '1',
          'albumName': 'Album 1',
          'albumThumbnailAssetId': null,
          'albumUsers': [],
          'assets': [],
          'description': '',
          'owner': {
            'id': 'user_1',
            'email': 'test@vault.com',
            'name': 'Test User',
            'profileImagePath': '',
          },
          'ownerId': 'user_1',
          'shared': false,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        {
          'id': '2',
          'albumName': 'Album 2',
          'albumThumbnailAssetId': null,
          'albumUsers': [],
          'assets': [],
          'description': '',
          'owner': {
            'id': 'user_1',
            'email': 'test@vault.com',
            'name': 'Test User',
            'profileImagePath': '',
          },
          'ownerId': 'user_1',
          'shared': false,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      ];

      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await http.runWithClient(
        () => apiClient.getAlbums(mockServerConnection),
        () => mockClient,
      );

      expect(result, isA<Ok<List<AlbumResponseDTO>>>());
      verify(
        () => mockClient.get(
          Uri.parse('https://test-vault.com/api/albums'),
          headers: mockServerConnection.jsonHeaders,
        ),
      ).called(1);
    });
  });
}
