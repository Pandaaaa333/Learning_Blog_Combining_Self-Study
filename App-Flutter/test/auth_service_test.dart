import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_mobile/features/auth/data/services/auth_service.dart';
import 'package:fe_mobile/core/network/api_client.dart';

class MockDio implements Dio {
  final Future<Response> Function(String path, {dynamic data})? postHandler;
  final Future<Response> Function(String path)? getHandler;
  MockDio({this.postHandler, this.getHandler});

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #post) {
      final path = invocation.positionalArguments[0] as String;
      final data = invocation.namedArguments[#data];
      return postHandler!(path, data: data);
    }
    if (invocation.memberName == #get) {
      final path = invocation.positionalArguments[0] as String;
      return getHandler!(path);
    }
    return super.noSuchMethod(invocation);
  }
}

class MockApiClient implements ApiClient {
  final Dio mockDio;
  MockApiClient(this.mockDio);

  @override
  Dio get dio => mockDio;
}

void main() {
  group('AuthService Unit Tests', () {
    late MockDio mockDio;
    late MockApiClient mockApiClient;
    late AuthService authService;

    setUp(() async {
      // Set up in-memory mock shared preferences storage
      SharedPreferences.setMockInitialValues({});
      
      mockDio = MockDio(
        postHandler: (path, {data}) async {
          if (path == '/Auth/login') {
            final mapData = data as Map<String, dynamic>;
            if (mapData['email'] == 'test@gmail.com' && mapData['password'] == '123456') {
              return Response(
                requestOptions: RequestOptions(path: path),
                statusCode: 200,
                data: {
                  'token': 'jwt_mock_token_123',
                  'user': {'id': '1', 'name': 'Test User', 'email': 'test@gmail.com'},
                },
              );
            } else {
              return Response(
                requestOptions: RequestOptions(path: path),
                statusCode: 400,
                data: {'message': 'Sai tài khoản hoặc mật khẩu'},
              );
            }
          }

          if (path == '/Auth/register') {
            final mapData = data as Map<String, dynamic>;
            if (mapData['email'] == 'duplicate@gmail.com') {
              return Response(
                requestOptions: RequestOptions(path: path),
                statusCode: 400,
                data: {'message': 'Email đã tồn tại'},
              );
            }
            return Response(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
              data: {
                'id': 'new_u_id',
                'name': mapData['name'],
                'email': mapData['email'],
              },
            );
          }

          if (path == '/Users/avatar') {
            return Response(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
              data: {'url': 'http://upload-avatar.com/new.png'},
            );
          }

          throw DioException(requestOptions: RequestOptions(path: path));
        },
        getHandler: (path) async {
          if (path == '/Auth/me') {
            return Response(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
              data: {'id': '1', 'name': 'Test User', 'email': 'test@gmail.com'},
            );
          }
          throw DioException(requestOptions: RequestOptions(path: path));
        },
      );

      mockApiClient = MockApiClient(mockDio);
      authService = AuthService(apiClient: mockApiClient);
    });

    test('AUTH_S_01: Should login successfully and cache token in SharedPreferences', () async {
      final res = await authService.login('test@gmail.com', '123456');

      expect(res['token'], 'jwt_mock_token_123');
      expect(res['user']['name'], 'Test User');

      // Verify token is saved in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), 'jwt_mock_token_123');
    });

    test('AUTH_S_02: Should throw exception on login failure', () async {
      expect(
        () async => await authService.login('test@gmail.com', 'wrong_pass'),
        throwsA(isA<Exception>()),
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), isNull);
    });

    test('AUTH_S_03: Should register successfully', () async {
      final res = await authService.register('New User', 'new@gmail.com', 'pass123');

      expect(res['id'], 'new_u_id');
      expect(res['name'], 'New User');
      expect(res['email'], 'new@gmail.com');
    });

    test('AUTH_S_04: Should get current user info', () async {
      final user = await authService.getCurrentUser();

      expect(user, isNotNull);
      expect(user!['name'], 'Test User');
      expect(user['email'], 'test@gmail.com');
    });

    test('AUTH_S_05: Should clear token on logout', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'cached_token_to_remove');

      await authService.logout();

      expect(prefs.getString('auth_token'), isNull);
    });

    test('AUTH_S_06: Should upload avatar successfully', () async {
      final bytes = [1, 2, 3, 4];
      final res = await authService.uploadAvatar(bytes, 'my_avatar.png');

      expect(res['url'], 'http://upload-avatar.com/new.png');
    });
  });
}
