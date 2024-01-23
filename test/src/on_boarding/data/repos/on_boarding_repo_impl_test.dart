import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/errors/exeptions.dart';
import 'package:educational_app/core/common/errors/failures.dart';
import 'package:educational_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:educational_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource dataSource;
  late OnBoardingRepoImpl repo;

  setUp(() {
    dataSource = MockOnBoardingLocalDataSource();
    repo = OnBoardingRepoImpl(dataSource);
  });

  group('cacheFirstTimer', () {
    test(
        'should complete successfully when call to locale source is successful',
        () async {
      when(
        () => dataSource.cacheFirstTimer(),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repo.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => dataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is '
        'unsuccessful',
        () async {
      when(
        () => dataSource.cacheFirstTimer(),
      ).thenThrow(
        const CacheException(
          message: 'Insufficient storage',
        ),
      );

      final result = await repo.cacheFirstTimer();

      expect(
        result,
        Left<CacheFailure, void>(
          CacheFailure(
            message: 'Insufficient storage',
            statusCode: 500,
          ),
        ),
      );

      verify(() => dataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    group('checkIfUserIsFirstTimer', () {
      test('should return true when user is first timer ', () async {
        when(
          () => dataSource.checkIfUserIsFirstTimer(),
        ).thenAnswer(
          (_) async => Future.value(true),
        );

        final result = await repo.checkIfUserIsFirstTimer();

        expect(result, equals(const Right<dynamic, bool>(true)));
      });

      test('should return fasle when user is not first timer ', () async {
        when(
          () => dataSource.checkIfUserIsFirstTimer(),
        ).thenAnswer(
          (_) async => Future.value(false),
        );

        final result = await repo.checkIfUserIsFirstTimer();

        expect(result, equals(const Right<dynamic, bool>(false)));
      });

      test('should return a [CacheFailure] when call to local data source '
      'is unsuccessful', () async {
        when(
          () => dataSource.checkIfUserIsFirstTimer(),
        ).thenThrow(
          const CacheException(
            message: 'Insufficient permissions',
            statusCode: 403,
          ),
        );

        final result = await repo.checkIfUserIsFirstTimer();

        expect(
          result,
          Left<CacheFailure, bool>(
            CacheFailure(
              message: 'Insufficient permissions',
              statusCode: 403,
            ),
          ),
        );
      });
    });
  });
}
