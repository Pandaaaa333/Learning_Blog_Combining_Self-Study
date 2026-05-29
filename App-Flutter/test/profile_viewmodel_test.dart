import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:fe_mobile/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:fe_mobile/features/auth/data/services/auth_service.dart';
import 'package:fe_mobile/core/network/api_client.dart';

class MockAuthService implements AuthService {
  Map<String, dynamic>? currentUser;
  bool shouldThrow = false;
  String throwMessage = 'Auth Error';

  bool loginCalled = false;
  bool registerCalled = false;
  bool getCurrentUserCalled = false;
  bool logoutCalled = false;
  bool uploadAvatarCalled = false;

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    getCurrentUserCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    return currentUser;
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    loginCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    return {
      'token': 'mock_token',
      'user': currentUser ?? {'name': 'Mock User', 'email': email},
    };
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    registerCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    return {
      'id': 'mock_reg_id',
      'name': name,
      'email': email,
    };
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<Map<String, dynamic>> uploadAvatar(List<int> bytes, String fileName) async {
    uploadAvatarCalled = true;
    if (shouldThrow) throw Exception(throwMessage);
    return {'url': 'http://mock-avatar-url.com'};
  }
}

class MockDio implements Dio {
  final Future<Response> Function(String path, {Map<String, dynamic>? queryParameters})? getHandler;
  MockDio({this.getHandler});

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #get) {
      final path = invocation.positionalArguments[0] as String;
      final queryParams = invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
      return getHandler!(path, queryParameters: queryParams);
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
  group('ProfileViewModel Unit Tests', () {
    late MockAuthService mockAuthService;
    late MockDio mockDio;
    late MockApiClient mockApiClient;
    late Map<String, dynamic> testUser;

    setUp(() {
      mockAuthService = MockAuthService();
      
      testUser = {
        'id': 'u1',
        'name': 'Nguyễn Văn A',
        'email': 'student@gmail.com',
        'points': 500,
        'level': 2,
        'avatarUrl': 'http://old-avatar.com',
      };
      mockAuthService.currentUser = testUser;

      mockDio = MockDio(
        getHandler: (path, {queryParameters}) async {
          if (path == '/SelfLearn/stats') {
            return Response(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
              data: {
                'dailyStats': [
                  {'date': '2026-05-26', 'duration': 30}
                ],
                'totalSessions': 15,
                'totalDurationMinutes': 450,
              },
            );
          }
          throw DioException(requestOptions: RequestOptions(path: path));
        },
      );
      mockApiClient = MockApiClient(mockDio);
    });

    test('PROF_VM_01: Should initialize and set logged in status when user token exists', () async {
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);

      expect(viewModel.isLoading, isTrue);

      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isLoggedIn, isTrue);
      expect(viewModel.user, isNotNull);
      expect(viewModel.user!['name'], 'Nguyễn Văn A');
      expect(mockAuthService.getCurrentUserCalled, isTrue);
    });

    test('PROF_VM_02: Should initialize as logged out when token does not exist', () async {
      mockAuthService.currentUser = null;

      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isLoggedIn, isFalse);
      expect(viewModel.user, isNull);
    });

    test('PROF_VM_03: Should log in successfully and update state', () async {
      mockAuthService.currentUser = null; // start logged out
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoggedIn, isFalse);

      mockAuthService.currentUser = testUser; // login succeeds
      await viewModel.login('student@gmail.com', '123456');

      expect(viewModel.isLoggedIn, isTrue);
      expect(viewModel.user!['email'], 'student@gmail.com');
      expect(mockAuthService.loginCalled, isTrue);
    });

    test('PROF_VM_04: Should propagate exception when login fails', () async {
      mockAuthService.currentUser = null;
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      mockAuthService.shouldThrow = true;
      mockAuthService.throwMessage = 'Sai mật khẩu';

      expect(
        () async => await viewModel.login('student@gmail.com', 'wrong_pass'),
        throwsA(isA<Exception>()),
      );
      expect(viewModel.isLoggedIn, isFalse);
    });

    test('PROF_VM_05: Should log out and clear user state', () async {
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoggedIn, isTrue);

      await viewModel.logout();

      expect(viewModel.isLoggedIn, isFalse);
      expect(viewModel.user, isNull);
      expect(mockAuthService.logoutCalled, isTrue);
    });

    test('PROF_VM_06: Should fetch study stats successfully', () async {
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(viewModel.isStatsLoading, isFalse);
      expect(viewModel.studyStats, isEmpty);

      final future = viewModel.fetchStudyStats();
      expect(viewModel.isStatsLoading, isTrue);

      await future;

      expect(viewModel.isStatsLoading, isFalse);
      expect(viewModel.studyStats.length, 1);
      expect(viewModel.totalSessions, 15);
      expect(viewModel.totalDurationMinutes, 450);
    });

    test('PROF_VM_07: Should update XP points and levels immediately', () async {
      final viewModel = ProfileViewModel(authService: mockAuthService, apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(viewModel.user!['points'], 500);
      expect(viewModel.user!['level'], 2);

      viewModel.updateGamification(1500, 5);

      expect(viewModel.user!['points'], 1500);
      expect(viewModel.user!['level'], 5);
    });
  });
}
